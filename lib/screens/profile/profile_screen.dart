import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../widgets/add_child_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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

  void _showEditChild(BuildContext context, AppState appState, String childId, String currentName, DateTime currentBirth, String currentGender, String currentBlood) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AddChildDialog(
        initialData: {
          'name': currentName,
          'birthDate': currentBirth,
          'gender': currentGender,
          'bloodType': currentBlood,
        },
      ),
    );

    if (result != null) {
      await appState.editChildProfile(
        childId,
        result['name'],
        result['birthDate'],
        result['gender'],
        result['bloodType'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // User Information Header
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: theme.colorScheme.primary,
                      child: const Icon(Icons.person, size: 48, color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appState.userName,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appState.userEmail,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                    children: [
                                      const TextSpan(text: 'Barangay: '),
                                      TextSpan(
                                        text: appState.userBarangay,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Children list header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mga Rehistradong Anak',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                FilledButton.icon(
                  onPressed: () => _showAddChild(context, appState),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Dagdag'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            appState.children.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Text(
                        'Wala pang nakarehistrong bata.\nMag-tap sa "Dagdag" sa itaas upang magdagdag ng bata.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appState.children.length,
                    itemBuilder: (context, index) {
                      final child = appState.children[index];
                      final isSelected = appState.selectedChildId == child.id;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: isSelected
                              ? BorderSide(color: theme.colorScheme.primary, width: 2)
                              : BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: child.gender == 'Lalaki'
                                        ? Colors.blue.shade100
                                        : Colors.pink.shade100,
                                    child: Icon(
                                      child.gender == 'Lalaki' ? Icons.boy : Icons.girl,
                                      color: child.gender == 'Lalaki' ? Colors.blue : Colors.pink,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          child.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          child.ageString,
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isSelected)
                                    TextButton(
                                      onPressed: () => appState.selectChild(child.id),
                                      child: const Text('Piliin'),
                                    )
                                  else
                                    Chip(
                                      label: const Text('Aktibo', style: TextStyle(fontSize: 11)),
                                      backgroundColor: theme.colorScheme.primaryContainer,
                                    ),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Blood Type: ${child.bloodType}', style: const TextStyle(fontSize: 13)),
                                  Text(
                                    'Taas: ${child.latestRecord?.height ?? "--"} cm',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                  Text(
                                    'Timbang: ${child.latestRecord?.weight ?? "--"} kg',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, size: 20),
                                    onPressed: () => _showEditChild(
                                      context,
                                      appState,
                                      child.id,
                                      child.name,
                                      child.birthDate,
                                      child.gender,
                                      child.bloodType,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                    onPressed: () => _confirmDelete(context, appState, child.id, child.name),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppState appState, String childId, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tanggalin ang Bata?'),
        content: Text('Sigurado ka bang nais mong tanggalin si $name sa iyong profile? Mabubura ang lahat ng tala nito.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kanselahin'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await appState.deleteChild(childId);
            },
            child: const Text('Tanggalin', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
