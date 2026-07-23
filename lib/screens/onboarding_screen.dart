import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _slides = [
    {
      'title': 'Subaybayan ang Timbang at Taas',
      'description': 'Madaling i-record ang paglaki ng inyong anak at awtomatikong kalkulahin ang BMI batay sa WHO growth standards.',
      'icon': Icons.show_chart_rounded,
      'color': Color(0xFFE3F2FD),
    },
    {
      'title': 'Iskedyul ng mga Bakuna',
      'description': 'Maging laging handa at ligtas! Sundin ang kumpletong timeline at gabay ng bakuna para sa proteksyon ng inyong anak.',
      'icon': Icons.vaccines_rounded,
      'color': Color(0xFFE8F5E9),
    },
    {
      'title': 'Gabay sa Pag-unlad (Milestones)',
      'description': 'Subaybayan ang bawat ngiti, hakbang, at salita ng inyong anak gamit ang aming interactive milestone tracker.',
      'icon': Icons.emoji_emotions_rounded,
      'color': Color(0xFFFFFDE7),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Container(
                color: slide['color'],
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 180,
                      width: 180,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        slide['icon'],
                        size: 90,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      slide['title'],
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      slide['description'],
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
          // Actions bar
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Laktawan'),
                ),
                // Indicator dots
                Row(
                  children: List.generate(
                    _slides.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? theme.colorScheme.primary
                            : Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                // Next/Start Button
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _slides.length - 1) {
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    _currentPage == _slides.length - 1 ? 'Magsimula' : 'Susunod',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
