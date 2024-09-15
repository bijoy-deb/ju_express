
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ju_express/source/utils/helper_functions.dart';
import 'dart:io';

void main() {
  group('form', () {
    // Test case to validate behavior when the email is empty
    test('Empty Email Test', () {
      // Call the function with an empty string
      var result = FormValidator.validateEmail2('');
      // Expect the result to match the specific error message
      expect(result, 'Please enter an email!');
    });

    // Test case to validate behavior when the email is invalid
    test('Invalid Email Test', () {
      String input = "bijoycsepu"; // Invalid email format
      // Call the function with an invalid email string
      var result = FormValidator.validateEmail2(input);
      // Expect an error message indicating invalid email
      expect(result, 'Please enter a valid email');
    });

    // Test case to validate behavior when the email is valid
    test('Valid Email Test', () {
      String input = "bijoycsepu@gmail.com"; // Valid email format
      // Call the function with a valid email
      var result = FormValidator.validateEmail2(input);
      // Expect no errors (result should be null for valid email)
      expect(result, null);
    });

  });
}
