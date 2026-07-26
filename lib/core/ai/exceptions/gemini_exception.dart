class GeminiException implements Exception {
  final String message;
  final String? details;

  const GeminiException(this.message, {this.details});

  @override
  String toString() {
    if (details != null) {
      return 'GeminiException: $message\nDetails: $details';
    }
    return 'GeminiException: $message';
  }
}

class QuotaExceededException extends GeminiException {
  const QuotaExceededException([String? details])
      : super('AI is busy, try again in a moment', details: details);
}

class NetworkException extends GeminiException {
  const NetworkException([String? details])
      : super('Check your internet connection', details: details);
}

class InvalidResponseException extends GeminiException {
  const InvalidResponseException([String? details])
      : super('AI returned unexpected response, retrying...', details: details);
}

class TimeoutException extends GeminiException {
  const TimeoutException([String? details])
      : super('Request timed out, please try again', details: details);
}
