import 'package:flutter/widgets.dart';

/// Configuration for field validation, similar to React Hook Form options.
class ValidationRules {
  final bool required;
  final String? requiredMessage;
  final int? minLength;
  final int? maxLength;
  final String? pattern;
  final String? patternMessage;
  final String? Function(dynamic value)? validate;

  ValidationRules({
    this.required = false,
    this.requiredMessage,
    this.minLength,
    this.maxLength,
    this.pattern,
    this.patternMessage,
    this.validate,
  });
}

/// The result of [FormHook.register]. 
/// This can be spread or used directly in TextFields and custom widgets.
class FormRegister {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(dynamic)? onChanged;
  final String name;

  FormRegister({
    required this.name,
    this.controller,
    this.validator,
    this.onChanged,
  });
}
