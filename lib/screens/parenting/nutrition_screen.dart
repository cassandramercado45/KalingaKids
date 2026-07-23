import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../models/tip_model.dart';
import '../../widgets/child_selector_overlay.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final activeChild = appState.selectedChild;

    final List<TipModel> nutritionTips;
    if (activeChild == null) {
      nutritionTips = [];
    } else {
      final totalMonths = activeChild.age['years']! * 12 + activeChild.age['months']!;
      final allTips = TipModel.dummyTips.where((t) => t.type == TipType.nutrition).toList();
      nutritionTips = allTips.where((t) {
        if (t.ageGroup == 'Lahat ng Edad') return true;
        if (t.ageGroup == 'Sanggol (0-6 Buwan)' && totalMonths <= 6) return true;
        if (t.ageGroup == 'Sanggol (6-12 Buwan)' && totalMonths > 6 && totalMonths <= 12) return true;
        if (t.ageGroup == 'Sanggol (0-12 Buwan)' && totalMonths <= 12) return true;
        if (t.ageGroup == 'Toddler (1-3 Taon)' && totalMonths >= 12 && totalMonths <= 36) return true;
        if (totalMonths > 36 && t.ageGroup == 'Toddler (1-3 Taon)') return true;
        return false;
      }).toList();
    }

    return ChildSelectorOverlay(
      child: activeChild == null
          ? const SizedBox()
          : Scaffold(
              appBar: AppBar(
                title: const Text('Gabay sa Nutrisyon'),
              ),
              body: ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: nutritionTips.length,
          itemBuilder: (context, index) {
            final tip = nutritionTips[index];
            IconData tipIcon;
            switch (tip.iconName) {
              case 'child_care':
                tipIcon = Icons.child_care;
                break;
              case 'restaurant':
                tipIcon = Icons.restaurant;
                break;
              case 'rice_bowl':
                tipIcon = Icons.rice_bowl;
                break;
              default:
                tipIcon = Icons.restaurant_menu;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.secondary.withAlpha(38),
                  child: Icon(tipIcon, color: theme.colorScheme.secondary),
                ),
                title: Text(
                  tip.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Edad: ${tip.ageGroup}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          tip.description,
                          style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          tip.content,
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
