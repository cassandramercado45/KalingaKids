import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(24),
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.child_care, size: 40, color: Color(0xFF64B5F6)),
            ),
            accountName: Text(
              appState.userName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(appState.userEmail),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Tungkol sa KalingaKids'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/about');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_support_outlined),
                  title: const Text('Mga Madalas Itanong (FAQ)'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/faq');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.phone_in_talk_outlined),
                  title: const Text('Makipag-ugnayan'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/contact');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.emergency_outlined, color: Colors.redAccent),
                  title: const Text(
                    'Pang-emergency na Tulong',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/emergency');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Mga Setting'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/settings');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.mark_email_unread_outlined),
                  title: const Text('Inbox ng Barangay (Demo)'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin_inbox');
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await appState.logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Mag-logout'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
