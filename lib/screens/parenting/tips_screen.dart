import 'package:flutter/material.dart';
import '../../models/tip_model.dart';
import '../../widgets/child_selector_overlay.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tips = TipModel.dummyTips.where((t) => t.type == TipType.parenting).toList();

    return ChildSelectorOverlay(
      child: Scaffold(
        body: ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemCount: tips.length,
          itemBuilder: (context, index) {
            final tip = tips[index];
            IconData tipIcon;
            switch (tip.iconName) {
              case 'favorite':
                tipIcon = Icons.favorite;
                break;
              case 'sports_esports':
                tipIcon = Icons.sports_esports;
                break;
              case 'bedtime':
                tipIcon = Icons.bedtime;
                break;
              default:
                tipIcon = Icons.lightbulb;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(tipIcon, color: theme.colorScheme.primary),
                ),
                title: Text(
                  tip.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Para sa: ${tip.ageGroup}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary),
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
