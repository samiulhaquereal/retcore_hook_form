# RetCore Hook Form 🚀

A headless, lightweight form manager for Flutter inspired by **React Hook Form**. It helps you manage form state, validation, and field registration in a central place without the boilerplate of multiple controllers or complex state management.

[![pub package](https://img.shields.io/pub/v/retcore_hook_form.svg)](https://pub.dev/packages/retcore_hook_form)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features ✨

- **Headless**: No UI components included, use it with any widget.
- **Centralized**: Manage all form values and errors in one place.
- **Validation**: Built-in rules (required, minLength, maxLength, pattern) and custom validation functions.
- **Easy Integration**: Simple `register` method to link fields to the form manager.
- **Lightweight**: Zero dependencies (except Flutter).

## Installation 📦

Add `retcore_hook_form` to your `pubspec.yaml`:

```yaml
dependencies:
  retcore_hook_form: ^1.0.0
```

Then run:
```bash
flutter pub get
```

## Usage 🛠️

### 1. Initialize the Form

```dart
final form = FormHook();

// Don't forget to dispose in your State's dispose method
@override
void dispose() {
  form.dispose();
  super.dispose();
}
```

### 2. Register Fields

Use the `register` method to connect your `TextField` or `TextFormField` to the form manager.

```dart
TextFormField(
  controller: form.register("email", rules: ValidationRules(
    required: true,
    pattern: r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    patternMessage: "Enter a valid email address"
  )).controller,
  validator: form.register("email").validator,
  decoration: InputDecoration(labelText: "Email"),
)
```

### 3. Handle Submission

```dart
ElevatedButton(
  onPressed: form.handleSubmit((data) {
    print("Form Data: $data"); // {email: "...", ...}
  }),
  child: Text("Submit"),
)
```

### 4. Advanced: Custom Validation

```dart
form.register("username", rules: ValidationRules(
  validate: (value) {
    if (value == "admin") return "Username 'admin' is reserved";
    return null;
  }
))
```

## API Reference 📖

### `FormHook`

- `register(String name, {ValidationRules? rules})`: Registers a field and returns a `FormRegister` object.
- `handleSubmit(Function(Map<String, dynamic>) onValid)`: Returns a callback that validates all fields and calls `onValid` if successful.
- `setValue(String name, dynamic value)`: Programmatically set a field's value.
- `getValue(String name)`: Get a field's current value.
- `reset()`: Resets all fields to their initial state.
- `dispose()`: Cleans up internal controllers.

### `ValidationRules`

- `required`: Boolean, makes the field mandatory.
- `requiredMessage`: Custom error message for required validation.
- `minLength`: Minimum character length.
- `maxLength`: Maximum character length.
- `pattern`: Regex pattern for validation.
- `patternMessage`: Custom error message for pattern validation.
- `validate`: Custom function for complex validation logic.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
