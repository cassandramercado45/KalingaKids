import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';
import 'add_child_dialog.dart';

class ChildSelectorOverlay extends StatelessWidget {
  final Widget child;

  const ChildSelectorOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final theme = Theme.of(context);

    // If no child is selected, prompt selection
    if (appState.selectedChild == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Pumili ng Bata'),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.child_care_rounded,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Pumili ng Bata',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kailangan pumili ng bata bago makita ang mga nilalaman ng screen na ito.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  if (appState.children.isEmpty) ...[
                    Text(
                      'Wala pang nakarehistrong bata. Magdagdag ng anak upang magpatuloy.',
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _showAddChild(context, appState),
                      icon: const Icon(Icons.add),
                      label: const Text('Magdagdag ng Anak'),
                    ),
                  ] else ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: appState.children.length,
                      itemBuilder: (context, index) {
                        final childItem = appState.children[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: childItem.gender == 'Lalaki'
                                  ? Colors.blue.shade100
                                  : Colors.pink.shade100,
                              child: Icon(
                                childItem.gender == 'Lalaki' ? Icons.boy : Icons.girl,
                                color: childItem.gender == 'Lalaki'
                                    ? Colors.blue
                                    : Colors.pink,
                              ),
                            ),
                            title: Text(
                              childItem.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(childItem.ageString),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              appState.selectChild(childItem.id);
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => _showAddChild(context, appState),
                      icon: const Icon(Icons.add),
                      label: const Text('Magdagdag ng Isa Pang Anak'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    // If child is selected, show child along with a switch header
    final activeChild = appState.selectedChild!;
    return Column(
      children: [
        // Tiny Switcher Bar at the top of feature screens
        Container(
          color: theme.colorScheme.primaryContainer.withAlpha(102),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: activeChild.gender == 'Lalaki'
                          ? Colors.blue.shade200
                          : Colors.pink.shade200,
                      child: Icon(
                        activeChild.gender == 'Lalaki' ? Icons.boy : Icons.girl,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Aktibong Bata: ',
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        activeChild.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () {
                  // Reset selection to force selector
                  appState.selectChild('');
                },
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: const Text('Palitan', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }

  void _showAddChild(BuildContext context, AppState appState) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddChildDialog(),
    );

    if (result != null) {
      await appState.addChild(
        result['name'],
        result['birthDate'],
        result['gender'],
        result['bloodType'],
        result['height'],
        result['weight'],
      );
    }
  }
}
