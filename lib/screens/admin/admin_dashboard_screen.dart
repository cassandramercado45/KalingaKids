import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/child_model.dart';
import '../../models/vaccine_model.dart';
import '../../models/milestone_model.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final children = appState.children;
    final feedbacksCount = appState.feedbacks.length;

    // Calculate stats
    final totalChildren = children.length;
    final boysCount = children.where((c) => c.gender == 'Lalaki').length;
    final girlsCount = children.where((c) => c.gender == 'Babae').length;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Analytics Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    theme,
                    title: 'Total na Bata',
                    value: totalChildren.toString(),
                    subtitle: 'Lalaki: $boysCount | Babae: $girlsCount',
                    icon: Icons.child_care_rounded,
                    color: Colors.blue.shade600,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    theme,
                    title: 'Mensahe / Feedback',
                    value: feedbacksCount.toString(),
                    subtitle: 'Galing sa mga magulang',
                    icon: Icons.mail_outline_rounded,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Children List Section
            Text(
              'Listahan ng mga Bata sa Barangay',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            children.isEmpty
                ? Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(child: Text('Walang rehistradong bata sa system.')),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      final child = children[index];
                      final isBoy = child.gender == 'Lalaki';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isBoy ? Colors.blue.shade100 : Colors.pink.shade100,
                            width: 1,
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
                            'Edad: ${child.ageString} | Blood Type: ${child.bloodType}',
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

  Widget _buildStatCard(
    ThemeData theme, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 32),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
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

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                child.name,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                'Impormasyon at Health Records',
                style: TextStyle(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const Divider(height: 32),

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
            Text(label, style: const TextStyle(fontSize: 13)),
            Text('$completed / $total (${(percent * 100).toInt()}%)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
