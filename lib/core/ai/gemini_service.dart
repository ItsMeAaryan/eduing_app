import 'dart:async';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'exceptions/gemini_exception.dart';

enum GeminiModelType { pro, flash }

class GeminiService {
  static final GeminiService _instance = GeminiService._internal();

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal();

  late final GenerativeModel _proModel;
  late final GenerativeModel _flashModel;
  bool _isInitialized = false;

  // Rate limiting variables
  final int _maxRequestsPerMinute = 10;
  final List<DateTime> _requestTimestamps = [];

  void initialize(String apiKey) {
    if (_isInitialized) return;

    _proModel = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: apiKey,
    );

    _flashModel = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );

    _isInitialized = true;
  }

  Future<Either<GeminiException, void>> _checkRateLimit() async {
    final now = DateTime.now();
    _requestTimestamps.removeWhere((timestamp) =>
        now.difference(timestamp) > const Duration(minutes: 1));

    if (_requestTimestamps.length >= _maxRequestsPerMinute) {
      return Left(QuotaExceededException('Rate limit exceeded. Max $_maxRequestsPerMinute requests per minute.'));
    }

    _requestTimestamps.add(now);
    return const Right(null);
  }

  GenerativeModel _getModel(GeminiModelType type) {
    switch (type) {
      case GeminiModelType.pro:
        return _proModel;
      case GeminiModelType.flash:
        return _flashModel;
    }
  }

  Future<Either<GeminiException, String>> generateText({
    required String prompt,
    GeminiModelType modelType = GeminiModelType.pro,
  }) async {
    try {
      final rateLimitCheck = await _checkRateLimit();
      if (rateLimitCheck.isLeft()) {
        return Left(rateLimitCheck.fold((l) => l, (r) => throw Exception()));
      }

      final model = _getModel(modelType);
      final content = [Content.text(prompt)];

      // Token counting
      final tokenCount = await model.countTokens(content);
      debugPrint('Token usage for prompt: ${tokenCount.totalTokens}');

      final response = await model
          .generateContent(content)
          .timeout(const Duration(seconds: 30));

      if (response.text == null || response.text!.isEmpty) {
        return const Left(InvalidResponseException('Empty response received.'));
      }

      return Right(response.text!);
    } on GenerativeAIException catch (e) {
      if (e.message.contains('quota') || e.message.contains('429')) {
        return Left(QuotaExceededException(e.message));
      }
      return Left(InvalidResponseException(e.message));
    } on SocketException catch (e) {
      return Left(NetworkException(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutException(e.message));
    } catch (e) {
      return Left(GeminiException('Unexpected error occurred', details: e.toString()));
    }
  }

  Future<Either<GeminiException, String>> generateTextWithImage({
    required String prompt,
    required File imageFile,
    GeminiModelType modelType = GeminiModelType.pro, // vision is integrated in pro/flash 1.5
  }) async {
    try {
      final rateLimitCheck = await _checkRateLimit();
      if (rateLimitCheck.isLeft()) {
        return Left(rateLimitCheck.fold((l) => l, (r) => throw Exception()));
      }

      final model = _getModel(modelType);
      final imageBytes = await imageFile.readAsBytes();
      
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ];

      // Token counting
      final tokenCount = await model.countTokens(content);
      debugPrint('Token usage for prompt: ${tokenCount.totalTokens}');

      final response = await model
          .generateContent(content)
          .timeout(const Duration(seconds: 45));

      if (response.text == null || response.text!.isEmpty) {
        return const Left(InvalidResponseException('Empty response received.'));
      }

      return Right(response.text!);
    } on GenerativeAIException catch (e) {
      if (e.message.contains('quota') || e.message.contains('429')) {
        return Left(QuotaExceededException(e.message));
      }
      return Left(InvalidResponseException(e.message));
    } on SocketException catch (e) {
      return Left(NetworkException(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutException(e.message));
    } catch (e) {
      return Left(GeminiException('Unexpected error occurred', details: e.toString()));
    }
  }

  ChatSession startChat({GeminiModelType modelType = GeminiModelType.flash, List<Content>? history}) {
    final model = _getModel(modelType);
    return model.startChat(history: history);
  }

  Future<Either<GeminiException, String>> sendMessage({
    required ChatSession chat,
    required String message,
  }) async {
    try {
      final rateLimitCheck = await _checkRateLimit();
      if (rateLimitCheck.isLeft()) {
        return Left(rateLimitCheck.fold((l) => l, (r) => throw Exception()));
      }

      // Token counting (approximated for chat context)
      final content = Content.text(message);
      
      final response = await chat
          .sendMessage(content)
          .timeout(const Duration(seconds: 30));

      if (response.text == null || response.text!.isEmpty) {
        return const Left(InvalidResponseException('Empty response received.'));
      }

      return Right(response.text!);
    } on GenerativeAIException catch (e) {
      if (e.message.contains('quota') || e.message.contains('429')) {
        return Left(QuotaExceededException(e.message));
      }
      return Left(InvalidResponseException(e.message));
    } on SocketException catch (e) {
      return Left(NetworkException(e.message));
    } on TimeoutException catch (e) {
      return Left(TimeoutException(e.message));
    } catch (e) {
      return Left(GeminiException('Unexpected error occurred', details: e.toString()));
    }
  }
}
