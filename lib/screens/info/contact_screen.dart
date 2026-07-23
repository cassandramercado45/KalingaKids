import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _msgController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });

      final appState = Provider.of<AppState>(context, listen: false);
      await appState.addFeedback(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _msgController.text.trim(),
      );

      if (!mounted) return;
      setState(() {
        _isSending = false;
      });

      _nameController.clear();
      _emailController.clear();
      _msgController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Matagumpay na naipadala ang inyong mensahe! Salamat.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Makipag-ugnayan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Makipag-ugnayan sa Amin',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Mayroon ka bang mga katanungan o feedback tungkol sa app? Punan ang form sa ibaba.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Name field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Buong Pangalan',
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Pakilagay ang inyong pangalan.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Pakilagay ang inyong email.';
                      }
                      if (!val.contains('@')) {
                        return 'Wastong email ang kailangan.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Message field
                  TextFormField(
                    controller: _msgController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Mensahe / Katanungan',
                      prefixIcon: const Icon(Icons.chat_bubble_outline),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Ilagay ang inyong mensahe.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  
                  _isSending
                      ? const Center(child: CircularProgressIndicator())
                      : FilledButton.icon(
                          onPressed: _submit,
                          icon: const Icon(Icons.send),
                          label: const Text('Ipadala ang Mensahe'),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
