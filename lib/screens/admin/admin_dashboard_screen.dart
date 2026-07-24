import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/app_state.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = Provider.of<AppState>(context);
    final children = appState.children;
    
    // Calculate total unique parents dynamically
    final totalParents = children.map((c) => c.parentEmail).toSet().length;

    // Filter barangays based on search query
    final filteredBarangays = kBarangays.where((b) {
      return b.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats Row
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      theme,
                      title: 'Total na Bata',
                      value: children.length.toString(),
                      subtitle: 'Sa buong lungsod/bayan',
                      icon: Icons.child_care_rounded,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      theme,
                      title: 'Total na Magulang',
                      value: totalParents.toString(),
                      subtitle: 'Mga rehistradong pamilya',
                      icon: Icons.people_alt_rounded,
                      color: Colors.teal.shade600,
                    ),
                  ),
                ],
              ),
            ),
  
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: SearchBar(
                controller: _searchController,
                hintText: 'Maghanap ng Barangay...',
                leading: const Icon(Icons.search),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                trailing: [
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                ],
              ),
            ),
  
            const SizedBox(height: 12),
  
            // Barangay Grid Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Text(
                'Mga Barangay (${filteredBarangays.length})',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
  
            // Grid of Barangays
            filteredBarangays.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text(
                        'Walang nahanap na Barangay.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 220,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: filteredBarangays.length,
                    itemBuilder: (context, index) {
                       final barangay = filteredBarangays[index];
                       // Calculate registered children and parents in this Barangay
                       final barangayChildren = children.where((c) => c.barangay == barangay);
                       final childCount = barangayChildren.length;
                       final parentCount = barangayChildren.map((c) => c.parentEmail).toSet().length;
   
                       return Card(
                         elevation: 1,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                           side: BorderSide(
                             color: childCount > 0
                                 ? theme.colorScheme.primary.withAlpha(51)
                                 : Colors.grey.shade200,
                             width: 1.5,
                           ),
                         ),
                         child: InkWell(
                           borderRadius: BorderRadius.circular(20),
                           onTap: () {
                             Navigator.pushNamed(
                               context,
                               '/barangay_detail',
                               arguments: barangay,
                             );
                           },
                           child: Padding(
                             padding: const EdgeInsets.all(16.0),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Expanded(
                                       child: Text(
                                         barangay,
                                         style: const TextStyle(
                                           fontWeight: FontWeight.bold,
                                           fontSize: 15,
                                         ),
                                         maxLines: 1,
                                         overflow: TextOverflow.ellipsis,
                                       ),
                                     ),
                                     Icon(
                                       Icons.location_city_outlined,
                                       size: 18,
                                       color: childCount > 0
                                           ? theme.colorScheme.primary
                                           : Colors.grey,
                                     ),
                                   ],
                                 ),
                                 const SizedBox(height: 12),
                                 Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                   decoration: BoxDecoration(
                                     color: childCount > 0
                                         ? theme.colorScheme.primaryContainer
                                         : Colors.grey.shade100,
                                     borderRadius: BorderRadius.circular(8),
                                   ),
                                   child: Text(
                                     childCount == 0
                                         ? '0 Bata | 0 Magulang'
                                         : '${childCount == 1 ? '1 Bata' : '$childCount na Bata'} | ${parentCount == 1 ? '1 Magulang' : '$parentCount na Magulang'}',
                                     style: TextStyle(
                                       fontSize: 11,
                                       fontWeight: FontWeight.bold,
                                       color: childCount > 0
                                           ? theme.colorScheme.onPrimaryContainer
                                           : Colors.grey.shade600,
                                     ),
                                   ),
                                 ),
                              ],
                            ),
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
}
