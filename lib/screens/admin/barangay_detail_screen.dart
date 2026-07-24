import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/child_model.dart';
import '../../models/vaccine_model.dart';
import '../../models/milestone_model.dart';

class BarangayDetailScreen extends StatelessWidget {
  const BarangayDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    
    // Retrieve barangay name from route settings arguments
    // Retrieve barangay name from route settings arguments
    final barangayName = ModalRoute.of(context)!.settings.arguments as String;
    
    // Filter children belonging to this Barangay
    final barangayChildren = appState.children.where((c) => c.barangay == barangayName).toList();

    // Filter parents belonging to this Barangay
    final barangayParents = appState.registeredParents.where((p) => p['barangay'] == barangayName).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Brgy. $barangayName'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              color: theme.colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_city_rounded,
                      size: 48,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Barangay $barangayName',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mga Bata: ${barangayChildren.length} | Mga Magulang: ${barangayParents.length}',
                            style: TextStyle(
                              color: theme.colorScheme.onPrimaryContainer.withAlpha(200),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Parents section
            Row(
              children: [
                Icon(Icons.people_alt_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Mga Rehistradong Magulang',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            barangayParents.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Walang rehistradong magulang sa Barangay na ito.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: barangayParents.length,
                    itemBuilder: (context, index) {
                      final parent = barangayParents[index];
                      final name = parent['name'] ?? '';
                      final email = parent['email'] ?? '';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(email),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 24),

            // Children section
            Row(
              children: [
                Icon(Icons.child_care_rounded, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Mga Rehistradong Bata',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            barangayChildren.isEmpty
                ? const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Walang rehistradong bata sa Barangay na ito.',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: barangayChildren.length,
                    itemBuilder: (context, index) {
                      final child = barangayChildren[index];
                      final isBoy = child.gender == 'Lalaki';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isBoy ? Colors.blue.shade100 : Colors.pink.shade100,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: isBoy ? Colors.blue.shade50 : Colors.pink.shade50,
                            child: Icon(
                              isBoy ? Icons.boy_outlined : Icons.girl_outlined,
                              color: isBoy ? Colors.blue : Colors.pink,
                            ),
                          ),
                          title: Text(
                            child.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${child.ageString} | Blood Type: ${child.bloodType}',
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          onTap: () => _showChildDetailSheet(context, child, appState, theme),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  void _showChildDetailSheet(BuildContext context, ChildModel child, AppState appState, ThemeData theme) {
    final completedVaccinesCount = appState.getCompletedVaccines(child.id).length;
    final totalVaccines = VaccineModel.dummyVaccines.length;

    final completedMilestonesCount = appState.getCompletedMilestones(child.id).length;
    final totalMilestones = MilestoneModel.dummyMilestones.length;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    child.name,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Impormasyon at Health Records',
                    style: TextStyle(color: Colors.grey.shade600),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(height: 32),
                  
                  // Wrap rest in scroll view to prevent height overflow
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Basic details
                          _buildDetailItem('Kasarian', child.gender),
                          _buildDetailItem('Edad', child.ageString),
                          _buildDetailItem('Blood Type', child.bloodType),
                          const Divider(height: 24),

                          // Progress reports
                          Text(
                            'Katayuan ng Kalusugan (Progress)',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          _buildProgressItem(
                            'Mga Bakunang Natanggap',
                            completedVaccinesCount,
                            totalVaccines,
                            theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          _buildProgressItem(
                            'Mga Nakumpletong Milestones',
                            completedMilestonesCount,
                            totalMilestones,
                            Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  // Close Button
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Isara'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, int completed, int total, Color color) {
    final percent = total > 0 ? (completed / total) : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$completed / $total (${(percent * 100).toInt()}%)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            color: color,
            backgroundColor: color.withAlpha(26),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
