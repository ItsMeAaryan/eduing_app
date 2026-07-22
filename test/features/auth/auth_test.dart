import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth Unit Tests', () {
    test('Email regex validation unit test', () {
      final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      expect(emailRegex.hasMatch('test@eduing.com'), isTrue);
      expect(emailRegex.hasMatch('user.name+tag@domain.co.in'), isTrue);
      expect(emailRegex.hasMatch('invalid-email'), isFalse);
      expect(emailRegex.hasMatch('a@'), isFalse);
    });
  });
}
