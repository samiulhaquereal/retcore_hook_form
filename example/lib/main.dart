import 'package:flutter/material.dart';
import 'package:retcore_hook_form/retcore_hook_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const RegistrationPage(),
    );
  }
}

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final form = FormHook();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Always dispose to clean up internal TextEditingControllers
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Hook (React Style)')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          // Note: You can still use the standard Form widget for auto-validation UI
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Create Account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 2. Register Name Field
              TextFormField(
                controller: form.register("name", rules: ValidationRules(
                  required: true, 
                  requiredMessage: "Please enter your full name"
                )).controller,
                validator: form.register("name").validator,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Register Email Field with Pattern
              TextFormField(
                controller: form.register("email", rules: ValidationRules(
                  required: true,
                  pattern: r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  patternMessage: "Enter a valid email address"
                )).controller,
                validator: form.register("email").validator,
                decoration: const InputDecoration(
                  labelText: "Email Address",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Register Password with Min Length
              TextFormField(
                obscureText: true,
                controller: form.register("password", rules: ValidationRules(
                  required: true,
                  minLength: 6,
                )).controller,
                validator: form.register("password").validator,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 24),

              // 5. Custom "Reset" and "Auto-Fill" functions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => form.reset(),
                      child: const Text("Reset"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        form.setValue("name", "Samiul Islam");
                        form.setValue("email", "sami@example.com");
                      },
                      child: const Text("Pre-fill"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 6. Handle Submit
              ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () {
                  // Trigger UI validation
                  if (_formKey.currentState!.validate()) {
                    form.handleSubmit((data) {
                      print("SUCCESS: $data");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Account created for ${data['name']}")),
                      );
                    }).call();
                  }
                },
                child: const Text("REGISTER NOW", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
