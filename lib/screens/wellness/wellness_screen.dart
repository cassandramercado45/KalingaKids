import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';
import '../../widgets/child_selector_overlay.dart';

class WellnessScreen extends StatelessWidget {
  const WellnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final activeChild = appState.selectedChild;
    String bmiInterpretation = '';
    if (activeChild != null && activeChild.latestRecord != null) {
      final latestRec = activeChild.latestRecord!;
      final ageMap = activeChild.getAgeAt(latestRec.date);
      final ageInYears = ageMap['years']! + (ageMap['months']! / 12.0);
      bmiInterpretation = latestRec.getBmiInterpretation(ageInYears);
    }

    return ChildSelectorOverlay(
      child: activeChild == null
          ? const SizedBox()
          : Scaffold(
              body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Short Greeting Card with active child details
              Card(
                color: theme.colorScheme.primaryContainer.withAlpha(102),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'Pangkalahatang Kalusugan ni',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activeChild.name,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Edad', activeChild.age['years'] == 0 
                              ? '${activeChild.age['months']} buwan' 
                              : '${activeChild.age['years']} taon'),
                          _buildStatItem('Timbang', activeChild.latestRecord != null 
                              ? '${activeChild.latestRecord!.weight} kg' 
                              : '--'),
                          _buildStatItem('Taas', activeChild.latestRecord != null 
                              ? '${activeChild.latestRecord!.height} cm' 
                              : '--'),
                        ],
                      ),
                      if (activeChild.latestRecord != null) ...[
                        const Divider(height: 24),
                        Text(
                          'BMI: ${activeChild.latestRecord!.bmi.toStringAsFixed(2)}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...bmiInterpretation.split(' | ').map((status) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            status,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        )),
                      ]
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Mga Serbisyo sa Kalusugan',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Growth monitoring card
              _buildMenuCard(
                context,
                title: 'Pagsubaybay sa Paglaki',
                description: 'Kalkulahin ang BMI at subaybayan ang pagbabago sa timbang at taas sa interactive na tsart.',
                icon: Icons.show_chart_rounded,
                color: theme.colorScheme.primary,
                route: '/growth',
              ),
              const SizedBox(height: 16),

              // Vaccination Card
              _buildMenuCard(
                context,
                title: 'Gabay sa Bakuna',
                description: 'Tingnan ang kumpletong timeline at lagyan ng tsek ang mga natapos nang bakuna ng inyong anak.',
                icon: Icons.vaccines_rounded,
                color: theme.colorScheme.secondary,
                route: '/vaccination',
              ),
              const SizedBox(height: 16),

              // Milestones Card
              _buildMenuCard(
                context,
                title: 'Mga Milestones sa Pag-unlad',
                description: 'Gabay sa mga kakayahan ng bata tulad ng paghuni, paggulong, pagtayo, at pagsasalita.',
                icon: Icons.emoji_emotions_rounded,
                color: theme.colorScheme.tertiary,
                route: '/milestones',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withAlpha(38),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
