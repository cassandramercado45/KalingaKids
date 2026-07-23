import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _carouselController = PageController();
  int _carouselIndex = 0;
  String _searchQuery = '';

  final List<Map<String, String>> _carouselItems = [
    {
      'title': 'Gabay sa Nutrisyon',
      'subtitle': 'Pagtuklas ng Masusustansyang Pagkain para sa Bata',
      'tip': 'Ihain ang makukulay na gulay at prutas araw-araw.',
    },
    {
      'title': 'Bakuna Laban sa Polio',
      'subtitle': 'Maging handa at kumpleto ang bakuna ng inyong anak',
      'tip': 'Huwag kaligtaan ang Oral Polio Vaccine drops sa unang 3.5 buwan.',
    },
    {
      'title': 'Kahalagahan ng Pag-unlad',
      'subtitle': 'Subaybayan ang unang ngiti at unang hakbang',
      'tip': 'Maglaro kasama ang bata upang maging masigla ang kaisipan.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final activeChild = appState.selectedChild;

    final shortcuts = [
      {'title': 'Pagsubaybay sa Paglaki', 'icon': Icons.show_chart, 'route': '/growth'},
      {'title': 'Gabay sa Bakuna', 'icon': Icons.vaccines, 'route': '/vaccination'},
      {'title': 'Gabay sa Pag-unlad', 'icon': Icons.emoji_emotions, 'route': '/milestones'},
      {'title': 'Gabay sa Nutrisyon', 'icon': Icons.restaurant, 'route': '/nutrition'},
      {'title': 'Mga Tanong (FAQ)', 'icon': Icons.help_outline, 'route': '/faq'},
      {'title': 'Makipag-ugnayan', 'icon': Icons.phone, 'route': '/contact'},
    ];

    final filteredShortcuts = shortcuts.where((s) {
      final titleStr = s['title'] as String;
      return titleStr.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Welcome
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withAlpha(76),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kumusta, ${appState.userName}!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Subaybayan natin ang kalusugan at pag-unlad ng inyong anak.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Maghanap ng paksa o gabay...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),

            // Carousel Section
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Mga Paalala at Tip ngayon',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _carouselController,
                  onPageChanged: (index) {
                    setState(() {
                      _carouselIndex = index;
                    });
                  },
                  itemCount: _carouselItems.length,
                  itemBuilder: (context, index) {
                    final item = _carouselItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      color: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['subtitle']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.lightbulb, color: Colors.yellowAccent, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item['tip']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _carouselItems.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _carouselIndex == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _carouselIndex == index ? theme.colorScheme.primary : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Active Child Info Widget
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: theme.colorScheme.primary.withAlpha(51), width: 1.5),
                ),
                elevation: 0,
                color: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: activeChild == null
                            ? Colors.grey.shade200
                            : (activeChild.gender == 'Lalaki'
                                ? Colors.blue.shade50
                                : Colors.pink.shade50),
                        child: Icon(
                          activeChild == null
                              ? Icons.person_outline
                              : (activeChild.gender == 'Lalaki' ? Icons.boy : Icons.girl),
                          size: 36,
                          color: activeChild == null
                              ? Colors.grey
                              : (activeChild.gender == 'Lalaki' ? Colors.blue : Colors.pink),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeChild != null ? activeChild.name : 'Pumili ng Bata',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              activeChild != null
                                  ? '${activeChild.ageString}\nBlood Type: ${activeChild.bloodType}'
                                  : 'Wala pang aktibong piniling anak. Piliin o magdagdag sa Profile.',
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // Send to Profile/Kids management screen
                          Navigator.pushNamed(context, '/profile');
                        },
                        icon: const Icon(Icons.manage_accounts_rounded),
                        color: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Navigation Shortcuts List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _searchQuery.isEmpty ? 'Mabilisang Aksyon' : 'Resulta ng Paghahanap',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),

            filteredShortcuts.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Text('Walang nahanap na mabilisang aksyon sa query na ito.'),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 180,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredShortcuts.length,
                    itemBuilder: (context, index) {
                      final item = filteredShortcuts[index];
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, item['route'] as String);
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primaryContainer.withAlpha(102),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: theme.colorScheme.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['title'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
