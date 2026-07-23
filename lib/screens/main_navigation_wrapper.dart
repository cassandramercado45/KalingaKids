import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import '../widgets/app_drawer.dart';
import 'dashboard_screen.dart';
import 'wellness/wellness_screen.dart';
import 'parenting/tips_screen.dart';
import 'profile/profile_screen.dart';
import 'admin/admin_dashboard_screen.dart';
import 'info/admin_inbox_screen.dart';

class MainNavigationWrapper extends StatefulWidget {
  final int initialIndex;
  const MainNavigationWrapper({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final isAdmin = appState.isAdmin;

    final List<Widget> screens = isAdmin
        ? [
            const AdminDashboardScreen(),
            const AdminInboxScreen(),
          ]
        : [
            const DashboardScreen(),
            const WellnessScreen(),
            const TipsScreen(),
            const ProfileScreen(),
          ];

    final List<String> titles = isAdmin
        ? [
            'Admin Dashboard',
            'Mga Inbox ng Barangay',
          ]
        : [
            'KalingaKids Dashboard',
            'Kalusugan ng Bata',
            'Gabay sa Pagpapalaki',
            'Profile ng Magulang at Anak',
          ];

    final activeIndex = _selectedIndex >= screens.length ? 0 : _selectedIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[activeIndex],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Mag-logout',
            onPressed: () async {
              await appState.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      drawer: isAdmin ? null : const AppDrawer(),
      body: IndexedStack(
        index: activeIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: activeIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: isAdmin
            ? const [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                NavigationDestination(
                  icon: Icon(Icons.mail_outline_rounded),
                  selectedIcon: Icon(Icons.mail_rounded),
                  label: 'Mga Inbox',
                ),
              ]
            : const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.child_care_outlined),
                  selectedIcon: Icon(Icons.child_care),
                  label: 'Wellness',
                ),
                NavigationDestination(
                  icon: Icon(Icons.lightbulb_outline),
                  selectedIcon: Icon(Icons.lightbulb),
                  label: 'Gabay',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
      ),
    );
  }
}
