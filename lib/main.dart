import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registration Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int _counter = 0;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _acceptedTerms = false;
  String? _selectedGroup;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Регистрация выполнена'),
          backgroundColor: Colors.green,
        ),
      );

      debugPrint('Имя: ${_nameController.text}');
      debugPrint('Email: ${_emailController.text}');
      debugPrint('Пароль: ${_passwordController.text}');
      debugPrint('Группа: $_selectedGroup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Форма регистрации')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCounter(),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameController,
                    label: 'Имя',
                    hint: 'Введите имя',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Введите имя';
                      }
                      if (value.trim().length < 2) {
                        return 'Имя слишком короткое';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'example@mail.com',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Некорректный email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Пароль',
                    hint: 'Минимум 6 символов',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Введите пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль минимум 6 символов';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGroup,
              decoration: const InputDecoration(
                labelText: 'Группа',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
              items: const [
                DropdownMenuItem(value: 'ИС-21', child: Text('ИС-21')),
                DropdownMenuItem(value: 'ИС-22', child: Text('ИС-22')),
                DropdownMenuItem(value: 'ПИ-21', child: Text('ПИ-21')),
                DropdownMenuItem(value: 'ПИ-22', child: Text('ПИ-22')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGroup = value;
                });
              },
              validator: (value) {
                if (value == null) return 'Выберите группу';
                return null;
              },
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Принимаю условия'),
              value: _acceptedTerms,
              onChanged: (value) {
                setState(() {
                  _acceptedTerms = value;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _acceptedTerms ? _submitForm : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Зарегистрироваться',
                style: TextStyle(fontSize: 16),
              ),
            ),
            if (!_acceptedTerms)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Необходимо принять условия',
                  style: TextStyle(color: Colors.red, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounter() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Счётчик',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Нажато: $_counter', style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: () => setState(() => _counter--),
                  icon: const Icon(Icons.remove),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: () => setState(() => _counter++),
                  icon: const Icon(Icons.add),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () => setState(() => _counter = 0),
                  child: const Text('Сброс'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?) validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }
}