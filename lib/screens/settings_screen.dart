import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mga Setting'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Text(
            'Pagpapasadya',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark Mode (Madilim na Tema)'),
              subtitle: const Text('Isaayos ang kulay ng app para sa dilim.'),
              value: appState.isDarkMode,
              onChanged: (bool value) {
                appState.toggleTheme(value);
              },
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Pamamahala ng Data',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.delete_forever_outlined, color: Colors.redAccent),
              title: const Text('I-reset ang lahat ng Data', style: TextStyle(color: Colors.redAccent)),
              subtitle: const Text('Burahin ang lahat ng na-save na profile at bakuna.'),
              onTap: () => _confirmReset(context, appState),
            ),
          ),

          const SizedBox(height: 48),
          const Center(
            child: Text(
              'KalingaKids v1.0.0 (Capstone Project)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context, AppState appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sigurado ka ba?'),
        content: const Text(
          'Mabubura ang lahat ng impormasyon ng inyong mga anak pati na ang mga checklists ng bakuna at milestones. Hindi ito maibabalik.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kanselahin'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await appState.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              }
            },
            child: const Text('I-reset', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
