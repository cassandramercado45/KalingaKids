import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vaccine_model.dart';
import '../../services/app_state.dart';
import '../../widgets/child_selector_overlay.dart';

class VaccinationScreen extends StatelessWidget {
  const VaccinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final activeChild = appState.selectedChild;

    // Load standard immunization schedule
    final vaccines = VaccineModel.dummyVaccines;
    final completedVaccines = activeChild != null ? appState.getCompletedVaccines(activeChild.id) : <String>[];

    // Group vaccines by age range, filtered by child's age
    final Map<String, List<VaccineModel>> groupedVaccines = {};
    if (activeChild != null) {
      final totalMonths = activeChild.age['years']! * 12 + activeChild.age['months']!;
      String targetGroup = 'Pagkapanganak';
      if (totalMonths < 1.5) {
        targetGroup = 'Pagkapanganak';
      } else if (totalMonths < 2.5) {
        targetGroup = '1.5 Buwan';
      } else if (totalMonths < 3.5) {
        targetGroup = '2.5 Buwan';
      } else if (totalMonths < 9.0) {
        targetGroup = '3.5 Buwan';
      } else if (totalMonths < 12.0) {
        targetGroup = '9 na Buwan';
      } else if (totalMonths < 72.0) {
        targetGroup = '12 Buwan';
      } else if (totalMonths < 144.0) {
        targetGroup = '6 na Taon';
      } else if (totalMonths < 216.0) {
        targetGroup = '12 na Taon';
      } else {
        targetGroup = '18 na Taon';
      }

      for (var v in vaccines) {
        bool matches = v.ageRange == targetGroup;
        if (targetGroup == '9 na Buwan' && v.ageRange == '9 Buwan') {
          matches = true;
        }
        if (matches) {
          groupedVaccines.putIfAbsent(v.ageRange, () => []).add(v);
        }
      }
    }

    return ChildSelectorOverlay(
      child: activeChild == null
          ? const SizedBox()
          : Scaffold(
              appBar: AppBar(
                title: const Text('Gabay at Timeline ng Bakuna'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'I-refresh ang data',
                    onPressed: () async {
                      await appState.refreshData();
                    },
                  ),
                ],
              ),
              body: groupedVaccines.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Walang nakatalagang bakuna para sa edad na ito.',
                    style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: groupedVaccines.keys.length,
                itemBuilder: (context, index) {
            final ageGroup = groupedVaccines.keys.elementAt(index);
            final groupItems = groupedVaccines[ageGroup]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Age Group Header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          ageGroup,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),

                // Vaccine list inside group
                ...groupItems.map((vac) {
                  final isDone = completedVaccines.contains(vac.id);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CheckboxListTile(
                        activeColor: theme.colorScheme.primary,
                        title: Text(
                          vac.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Sakit na Pinipigilan: ${vac.diseasePrevented}'),
                            const SizedBox(height: 2),
                            Text(
                              vac.description,
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        value: isDone,
                        onChanged: (val) {
                          appState.toggleVaccine(activeChild.id, vac.id);
                        },
                      ),
                    ),
                  );
                }),

                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }
}
