import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;
  String _selectedBarangay = 'Sabang';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final appState = Provider.of<AppState>(context, listen: false);
      await appState.register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
        _selectedBarangay,
      );

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Gumawa ng Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 450),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'KalingaKids Registration',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Punan ang mga patlang sa ibaba upang makapagsimula.',
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // Name
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Pangalan',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Mangyaring ilagay ang iyong pangalan.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Barangay Selection
                      DropdownButtonFormField<String>(
                        initialValue: _selectedBarangay,
                        decoration: InputDecoration(
                          labelText: 'Barangay',
                          prefixIcon: const Icon(Icons.location_city_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        items: kBarangays.map((b) {
                          return DropdownMenuItem(value: b, child: Text(b));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedBarangay = val;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Email
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mangyaring ilagay ang iyong email.';
                          }
                          if (!value.contains('@')) {
                            return 'Mangyaring ilagay ang wastong email.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mangyaring ilagay ang iyong password.';
                          }
                          if (value.length < 6) {
                            return 'Dapat hindi bababa sa 6 na karakter.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Confirm Password
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          labelText: 'Kumpirmahin ang Password',
                          prefixIcon: const Icon(Icons.lock_clock_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Mangyaring kumpirmahin ang iyong password.';
                          }
                          if (value != _passwordController.text) {
                            return 'Hindi nagtutugma ang password.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      
                      // Register Button
                      _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : FilledButton(
                              onPressed: _submit,
                              child: const Text(
                                'Magrehistro',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
