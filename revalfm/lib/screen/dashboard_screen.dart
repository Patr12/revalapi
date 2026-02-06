// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revalfm/screen/ad_form_screen.dart';
import '../providers/auth_provider.dart';
import '../providers/ads_provider.dart';
import '../widgets/statistics_card.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      const HomeTab(),
      const AdsTab(),
      const StatisticsTab(),
    ]);
    
    // Load data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adsProvider = Provider.of<AdsProvider>(context, listen: false);
      adsProvider.loadAds();
      adsProvider.loadStatistics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RevalFM Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final adsProvider = Provider.of<AdsProvider>(context, listen: false);
              adsProvider.loadAds();
              adsProvider.loadStatistics();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data refreshed')),
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                ),
              ),
            ],
            onSelected: (value) async {
              if (value == 'logout') {
                await authProvider.logout();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/login');
                }
              }
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdFormScreen(),
                  ),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ad_units),
            label: 'Ads',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }
}

// Home Tab
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final adsProvider = Provider.of<AdsProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          _buildWelcomeCard(authProvider),
          const SizedBox(height: 16),
          
          // Statistics Cards
          _buildStatisticsCards(adsProvider),
          const SizedBox(height: 16),
          
          // Quick Actions
          _buildQuickActions(),
          const SizedBox(height: 16),
          
          // Recent Ads
          _buildRecentAds(adsProvider),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(AuthProvider authProvider) {
    final user = authProvider.currentUser;
    final username = user?['username'] ?? 'Admin';
    final firstName = user?['first_name'] ?? '';
    final lastName = user?['last_name'] ?? '';
    final displayName = '$firstName $lastName'.trim().isNotEmpty 
        ? '$firstName $lastName' 
        : username;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $displayName!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manage your advertisements and track performance',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last login: ${DateTime.now().toString().substring(0, 10)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCards(AdsProvider adsProvider) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        StatisticsCard(
          title: 'Total Ads',
          value: '${adsProvider.totalAds}',
          icon: Icons.ad_units,
          color: Colors.blue,
        ),
        StatisticsCard(
          title: 'Active Ads',
          value: '${adsProvider.activeAdsCount}',
          icon: Icons.play_circle_filled,
          color: Colors.green,
        ),
        StatisticsCard(
          title: 'Impressions',
          value: adsProvider.statistics?['total_impressions']?.toString() ?? '0',
          icon: Icons.remove_red_eye,
          color: Colors.orange,
        ),
        StatisticsCard(
          title: 'Clicks',
          value: adsProvider.statistics?['total_clicks']?.toString() ?? '0',
          icon: Icons.touch_app,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionButton(
                  icon: Icons.add,
                  label: 'New Ad',
                  onTap: () {
                    // Navigate to ad form
                  },
                ),
                _buildActionButton(
                  icon: Icons.refresh,
                  label: 'Refresh',
                  onTap: () {
                    // Refresh data
                  },
                ),
                _buildActionButton(
                  icon: Icons.download,
                  label: 'Export',
                  onTap: () {
                    // Export data
                  },
                ),
                _buildActionButton(
                  icon: Icons.settings,
                  label: 'Settings',
                  onTap: () {
                    // Open settings
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAds(AdsProvider adsProvider) {
    final recentAds = adsProvider.ads.take(5).toList();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Ads',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (recentAds.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No ads created yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...recentAds.map((ad) => ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.image,
                        color: Colors.grey[400],
                      ),
                    ),
                    title: Text(ad.title),
                    subtitle: Text(
                      'Status: ${ad.status} • ${ad.targetProgram}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Chip(
                      label: Text('${ad.clicks} clicks'),
                      backgroundColor: Colors.blue[50],
                    ),
                    onTap: () {
                      // Navigate to ad detail
                    },
                  )),
          ],
        ),
      ),
    );
  }
}

// Ads Tab
class AdsTab extends StatelessWidget {
  const AdsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final adsProvider = Provider.of<AdsProvider>(context);

    return Column(
      children: [
        // Search and Filter
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search ads...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    // Implement search
                  },
                ),
              ),
              const SizedBox(width: 12),
              PopupMenuButton(
                icon: const Icon(Icons.filter_list),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'all',
                    child: Text('All Ads'),
                  ),
                  const PopupMenuItem(
                    value: 'active',
                    child: Text('Active Only'),
                  ),
                  const PopupMenuItem(
                    value: 'inactive',
                    child: Text('Inactive'),
                  ),
                  const PopupMenuItem(
                    value: 'scheduled',
                    child: Text('Scheduled'),
                  ),
                ],
                onSelected: (value) {
                  // Implement filter
                },
              ),
            ],
          ),
        ),
        
        // Ads List
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              await adsProvider.loadAds();
            },
            child: _buildAdsList(adsProvider),
          ),
        ),
      ],
    );
  }

  Widget _buildAdsList(AdsProvider adsProvider) {
    if (adsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (adsProvider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              adsProvider.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => adsProvider.loadAds(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (adsProvider.ads.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.ad_units, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No ads created yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click the + button to create your first ad',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: adsProvider.ads.length,
      itemBuilder: (context, index) {
        final ad = adsProvider.ads[index];
        return AdCard(
          advertisement: ad,
          onEdit: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdFormScreen(advertisement: ad),
              ),
            );
          },
          onDelete: () async {
            final confirmed = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Ad'),
                content: const Text('Are you sure you want to delete this ad?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );

            if (confirmed == true) {
              await adsProvider.deleteAd(ad.id as int);
            }
          },
        );
      },
    );
  }
}

// Statistics Tab
class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final adsProvider = Provider.of<AdsProvider>(context);
    final stats = adsProvider.statistics;

    if (stats == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overview Cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              StatisticsCard(
                title: 'Total Ads',
                value: stats['total_ads'].toString(),
                icon: Icons.ad_units,
                color: Colors.blue,
              ),
              StatisticsCard(
                title: 'Active Ads',
                value: stats['active_ads'].toString(),
                icon: Icons.play_circle_filled,
                color: Colors.green,
              ),
              StatisticsCard(
                title: 'Impressions',
                value: stats['total_impressions'].toString(),
                icon: Icons.remove_red_eye,
                color: Colors.orange,
              ),
              StatisticsCard(
                title: 'Clicks',
                value: stats['total_clicks'].toString(),
                icon: Icons.touch_app,
                color: Colors.purple,
              ),
              StatisticsCard(
                title: 'CTR',
                value: '${stats['click_through_rate']?.toStringAsFixed(1)}%',
                icon: Icons.trending_up,
                color: Colors.teal,
              ),
              StatisticsCard(
                title: 'Today Clicks',
                value: stats['today_clicks']?.toString() ?? '0',
                icon: Icons.today,
                color: Colors.amber,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Program Stats
          _buildProgramStats(stats),
          const SizedBox(height: 24),
          
          // Performance Chart
          _buildPerformanceChart(),
        ],
      ),
    );
  }

  Widget _buildProgramStats(Map<String, dynamic> stats) {
    final programStats = stats['program_stats'] as List? ?? [];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ads by Program',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...programStats.map((stat) {
              final program = stat['program'];
              final count = stat['count'];
              return ListTile(
                title: Text(program),
                trailing: Chip(
                  label: Text(count.toString()),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Performance chart would go here',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}