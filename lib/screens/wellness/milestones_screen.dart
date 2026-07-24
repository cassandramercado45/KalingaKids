import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/milestone_model.dart';
import '../../services/app_state.dart';
import '../../widgets/child_selector_overlay.dart';

class MilestonesScreen extends StatefulWidget {
  const MilestonesScreen({super.key});

  @override
  State<MilestonesScreen> createState() => _MilestonesScreenState();
}

class _MilestonesScreenState extends State<MilestonesScreen> {
  String _selectedAge = '2 Months';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final activeChild = appState.selectedChild;

    // Filter available filters based on child's age in months
    final totalMonths = activeChild != null ? activeChild.age['years']! * 12 + activeChild.age['months']! : 0;
    final totalYears = activeChild != null ? activeChild.age['years']! : 0;
    
    String targetMilestoneGroup = '2 Months';
    if (totalYears == 0) {
      if (totalMonths < 6) {
        targetMilestoneGroup = '2 Months';
      } else {
        targetMilestoneGroup = '6 Months';
      }
    } else if (totalYears == 1) {
      targetMilestoneGroup = '1 Year';
    } else {
      targetMilestoneGroup = '$totalYears Years';
    }

    final List<String> eligibleFilters = [targetMilestoneGroup];
    _selectedAge = targetMilestoneGroup;

    final allMilestones = MilestoneModel.dummyMilestones;
    final filteredMilestones = allMilestones.where((m) => m.ageRange == _selectedAge).toList();
    final completedMilestones = activeChild != null ? appState.getCompletedMilestones(activeChild.id) : <String>[];

    return ChildSelectorOverlay(
      child: activeChild == null
          ? const SizedBox()
          : Scaffold(
              appBar: AppBar(
                title: const Text('Mga Milestones sa Pag-unlad'),
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
              body: Column(
          children: [
            // Age selection bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: theme.colorScheme.surface,
              child: SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: eligibleFilters.length,
                  itemBuilder: (context, index) {
                    final age = eligibleFilters[index];
                    final isSelected = age == _selectedAge;
                    
                    String displayAge;
                    switch (age) {
                      case '2 Months':
                        displayAge = '2 Buwan';
                        break;
                      case '6 Months':
                        displayAge = '6 na Buwan';
                        break;
                      case '1 Year':
                        displayAge = '1 Taon';
                        break;
                      case '2 Years':
                        displayAge = '2 Taon';
                        break;
                      case '5 Years':
                        displayAge = '5 Taon';
                        break;
                      case '10 Years':
                        displayAge = '10 Taon';
                        break;
                      case '15 Years':
                        displayAge = '15 Taon';
                        break;
                      case '19 Years':
                        displayAge = '19 Taon';
                        break;
                      default:
                        displayAge = age;
                    }

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(displayAge),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) {
                            setState(() {
                              _selectedAge = age;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // Milestone items checklist
            Expanded(
              child: filteredMilestones.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          'Walang nakatalagang milestones para sa edad na ito.',
                          style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: filteredMilestones.length,
                      itemBuilder: (context, index) {
                        final mile = filteredMilestones[index];
                  final isDone = completedMilestones.contains(mile.id);

                  IconData catIcon;
                  Color catColor;
                  switch (mile.category) {
                    case MilestoneCategory.social:
                      catIcon = Icons.people_outline;
                      catColor = Colors.pink;
                      break;
                    case MilestoneCategory.language:
                      catIcon = Icons.chat_bubble_outline;
                      catColor = Colors.blue;
                      break;
                    case MilestoneCategory.cognitive:
                      catIcon = Icons.psychology_outlined;
                      catColor = Colors.amber;
                      break;
                    case MilestoneCategory.motor:
                      catIcon = Icons.directions_run_outlined;
                      catColor = Colors.green;
                      break;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: CheckboxListTile(
                      activeColor: theme.colorScheme.primary,
                      secondary: CircleAvatar(
                        backgroundColor: catColor.withAlpha(38),
                        child: Icon(catIcon, color: catColor),
                      ),
                      title: Text(
                        mile.categoryName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: catColor,
                          fontSize: 12,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          mile.description,
                          style: TextStyle(
                            fontSize: 14,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      value: isDone,
                      onChanged: (val) {
                        appState.toggleMilestone(activeChild.id, mile.id);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
