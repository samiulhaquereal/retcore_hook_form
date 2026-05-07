import 'package:flutter/widgets.dart';
import 'models.dart';

/// A headless form manager inspired by React Hook Form.
/// It manages values, validation, and controllers in one central place.
class FormHook {
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _values = {};
  final Map<String, String?> _errors = {};
  final Map<String, ValidationRules> _rules = {};

  /// Access the current values of the form
  Map<String, dynamic> get values => Map.unmodifiable(_values);

  /// Access the current errors of the form
  Map<String, String?> get errors => Map.unmodifiable(_errors);

  /// Registers a field into the form manager.
  /// 
  /// Returns a [FormRegister] which contains the [TextEditingController] 
  /// and [validator] needed for the widget.
  FormRegister register(String name, {ValidationRules? rules}) {
    // Only set rules if they are provided or if none exist yet.
    // This prevents subsequent calls to register() from wiping out previous rules.
    if (rules != null || !_rules.containsKey(name)) {
      _rules[name] = rules ?? ValidationRules();
    }

    // Create controller if it doesn't exist (only for text-based fields)
    if (!_controllers.containsKey(name)) {
      final controller = TextEditingController();
      _controllers[name] = controller;
      
      // Initialize value from controller
      _values[name] = controller.text;

      // Listen for changes
      controller.addListener(() {
        _values[name] = controller.text;
      });
    }

    return FormRegister(
      name: name,
      controller: _controllers[name],
      validator: (value) => _validateField(name, value),
      onChanged: (value) {
        _values[name] = value;
        // If it's a manual change (custom widget), update controller if exists
        if (_controllers.containsKey(name) && value is String) {
          if (_controllers[name]!.text != value) {
            _controllers[name]!.text = value;
          }
        }
      },
    );
  }

  /// Internal validation logic
  String? _validateField(String name, dynamic value) {
    final rules = _rules[name];
    if (rules == null) return null;

    if (rules.required && (value == null || value.toString().isEmpty)) {
      return rules.requiredMessage ?? 'This field is required';
    }

    if (value != null && value.toString().isNotEmpty) {
      final strValue = value.toString();

      if (rules.minLength != null && strValue.length < rules.minLength!) {
        return 'Minimum length is ${rules.minLength}';
      }

      if (rules.maxLength != null && strValue.length > rules.maxLength!) {
        return 'Maximum length is ${rules.maxLength}';
      }

      if (rules.pattern != null) {
        final regExp = RegExp(rules.pattern!);
        if (!regExp.hasMatch(strValue)) {
          return rules.patternMessage ?? 'Invalid format';
        }
      }
    }

    // Custom validation function
    if (rules.validate != null) {
      return rules.validate!(value);
    }

    return null;
  }

  /// Sets a value for a specific field programmatically.
  void setValue(String name, dynamic value) {
    _values[name] = value;
    if (_controllers.containsKey(name) && value is String) {
      _controllers[name]!.text = value;
    }
  }

  /// Gets a value for a specific field.
  dynamic getValue(String name) => _values[name];

  /// Resets the form to initial values and clears errors.
  void reset() {
    _values.clear();
    _errors.clear();
    for (var controller in _controllers.values) {
      controller.clear();
    }
  }

  /// Validates all fields and calls [onValid] if successful.
  /// Use this in your submit button's onPressed.
  void Function() handleSubmit(void Function(Map<String, dynamic> data) onValid) {
    return () {
      bool isValid = true;
      final data = <String, dynamic>{};

      for (var name in _rules.keys) {
        final value = _values[name];
        final error = _validateField(name, value);
        
        if (error != null) {
          isValid = false;
        }
        data[name] = value;
      }

      if (isValid) {
        onValid(data);
      }
    };
  }

  /// Clean up all controllers.
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}
