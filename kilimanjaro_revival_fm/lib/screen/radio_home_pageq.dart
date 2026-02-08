// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:wave/wave.dart';
// import 'package:wave/config.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';


// class RadioHomePage extends StatefulWidget {
//   const RadioHomePage({super.key});

//   @override
//   State<RadioHomePage> createState() => _RadioHomePageState();
// }

// class _RadioHomePageState extends State<RadioHomePage>
//     with SingleTickerProviderStateMixin {
//   final AudioPlayer _player = AudioPlayer();
//   bool isPlaying = false;
//   bool isLoading = false;
//   String errorMessage = '';
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
//   // Settings state
//   double _volume = 1.0;
//   bool _notificationsEnabled = true;
//   bool _autoPlay = false;
//   String _selectedTheme = 'Dark';
  
//   // Favorites state
//   final List<Map<String, dynamic>> _favorites = [];
//   final List<Map<String, dynamic>> _recentStations = [];

//   final List<String> streamUrls = [
//     "http://uk3freenew.listen2myradio.com:7235/live",
//     "http://uk3freenew.listen2myradio.com:7235/stream",
//     "http://uk3freenew.listen2myradio.com:7235/;stream.mp3",
//     "http://uk3freenew.listen2myradio.com:7235/;stream.nsv",
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _setupPlayer();
//     _loadSettings();
//   }

//   void _setupPlayer() {
//     _player.onPlayerStateChanged.listen((PlayerState state) {
//       setState(() {
//         isPlaying = state == PlayerState.playing;
//       });
//     });

//     _player.onPlayerComplete.listen((event) {
//       setState(() {
//         isPlaying = false;
//         isLoading = false;
//       });
//     });
//   }

//   // === RADIO FUNCTIONS ===
//   void _toggleRadio() {
//     if (isLoading) return;

//     if (isPlaying) {
//       _stopRadio();
//     } else {
//       _startRadio();
//     }
//   }

//   Future<void> _startRadio() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = '';
//     });

//     try {
//       bool success = false;
//       for (String url in streamUrls) {
//         try {
//           await _player.setSource(UrlSource(url));
//           await _player.resume();
//           success = true;
          
//           // Add to recent stations
//           _addToRecentStations('Reval FM', url);
//           break;
//         } catch (_) {
//           continue;
//         }
//       }

//       if (!success) {
//         setState(() {
//           errorMessage =
//               'Could not connect to any radio stream. Check your internet.';
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error: ${e.toString()}';
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _stopRadio() async {
//     try {
//       await _player.stop();
//       setState(() {
//         isPlaying = false;
//         isLoading = false;
//         errorMessage = '';
//       });
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Error stopping radio: ${e.toString()}';
//       });
//     }
//   }

//   // === FAVORITES FUNCTIONS ===
//   void _toggleFavorite() {
//     setState(() {
//       bool isFavorite = _favorites.any((fav) => fav['name'] == 'Reval FM');
//       if (isFavorite) {
//         _favorites.removeWhere((fav) => fav['name'] == 'Reval FM');
//       } else {
//         _favorites.add({
//           'name': 'Reval FM',
//           'url': streamUrls.first,
//           'image': 'assets/radio_icon.png',
//           'addedAt': DateTime.now(),
//         });
//       }
//     });
//   }

//   bool get _isFavorite {
//     return _favorites.any((fav) => fav['name'] == 'Reval FM');
//   }

//   void _addToRecentStations(String name, String url) {
//     setState(() {
//       _recentStations.removeWhere((station) => station['name'] == name);
//       _recentStations.insert(0, {
//         'name': name,
//         'url': url,
//         'playedAt': DateTime.now(),
//       });
      
//       // Keep only last 10 stations
//       if (_recentStations.length > 10) {
//         _recentStations.removeLast();
//       }
//     });
//   }

//   // === SETTINGS FUNCTIONS ===
//   void _loadSettings() {
//     // Hii inaweza kuunganishwa na SharedPreferences baadaye
//     setState(() {
//       _volume = 1.0;
//       _notificationsEnabled = true;
//       _autoPlay = false;
//       _selectedTheme = 'Dark';
//     });
//   }

//   void _saveSettings() {
//     // Hapa unaweza kusave settings kwenye SharedPreferences
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Settings saved successfully!'),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }

//   // === SHARE FUNCTIONS ===
//   void _shareApp() {
//     Share.share(
//       'Check out Reval FM - The best radio station app! Download now from mgantitech.co.tz',
//       subject: 'Reval FM Radio App',
//     );
//   }

//   void _shareStation() {
//     Share.share(
//       'Listen to Reval FM live radio! Tune in now: ${streamUrls.first}',
//       subject: 'Reval FM Live Radio',
//     );
//   }

//   Future<void> _launchWebsite() async {
//     final Uri url = Uri.parse('https://mgantitech.co.tz');
//     if (!await launchUrl(url)) {
//       throw Exception('Could not launch $url');
//     }
//   }

//   // === DRAWER ===
//   Widget _buildDrawer() {
//     return Drawer(
//       backgroundColor: Colors.deepPurple.shade900.withOpacity(0.95),
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.deepPurple, Colors.purpleAccent],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.white.withOpacity(0.2),
//                   child: const Icon(Icons.radio, size: 35, color: Colors.white),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Reval FM',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const Text(
//                   'Your Favorite Radio',
//                   style: TextStyle(fontSize: 14, color: Colors.white70),
//                 ),
//               ],
//             ),
//           ),
//           _buildDrawerItem(
//             icon: Icons.home,
//             title: 'Home',
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.favorite,
//             title: 'Favorites',
//             onTap: () {
//               Navigator.pop(context);
//               _showFavoritesPage();
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.history, 
//             title: 'Recent', 
//             onTap: () {
//               Navigator.pop(context);
//               _showRecentPage();
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.settings,
//             title: 'Settings',
//             onTap: () {
//               Navigator.pop(context);
//               _showSettingsPage();
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.info, 
//             title: 'About', 
//             onTap: () {
//               Navigator.pop(context);
//               _showAboutPage();
//             },
//           ),
//           const Divider(color: Colors.white30),
//           _buildDrawerItem(
//             icon: Icons.share, 
//             title: 'Share App', 
//             onTap: () {
//               Navigator.pop(context);
//               _shareApp();
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.star, 
//             title: 'Rate App', 
//             onTap: () {
//               Navigator.pop(context);
//               _showRateAppDialog();
//             },
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 15),
//             color: const Color.fromARGB(255, 233, 233, 236).withOpacity(0.2),
//             alignment: Alignment.center,
//             child: const Text(
//               "Patrice S Mgala - Software Engineering\nmgantitech.co.tz\nVersion 1.0.0",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.black54,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDrawerItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white70),
//       title: Text(title, style: const TextStyle(color: Colors.white)),
//       onTap: onTap,
//       hoverColor: Colors.white.withOpacity(0.1),
//     );
//   }

//   // === PAGES ===
//   void _showFavoritesPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FavoritesPage(
//           favorites: _favorites,
//           onPlayStation: (station) {
//             // Logic ya kuplay station kutoka favorites
//             _startRadio();
//           },
//           onRemoveFavorite: (station) {
//             setState(() {
//               _favorites.remove(station);
//             });
//           },
//         ),
//       ),
//     );
//   }

//   void _showRecentPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => RecentPage(
//           recentStations: _recentStations,
//           onPlayStation: (station) {
//             _startRadio();
//           },
//         ),
//       ),
//     );
//   }

//   void _showSettingsPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SettingsPage(
//           volume: _volume,
//           notificationsEnabled: _notificationsEnabled,
//           autoPlay: _autoPlay,
//           selectedTheme: _selectedTheme,
//           onSettingsChanged: (newVolume, newNotifications, newAutoPlay, newTheme) {
//             setState(() {
//               _volume = newVolume;
//               _notificationsEnabled = newNotifications;
//               _autoPlay = newAutoPlay;
//               _selectedTheme = newTheme;
//             });
//             _saveSettings();
//           },
//         ),
//       ),
//     );
//   }

//   void _showAboutPage() {
//     showDialog(
//       context: context,
//       builder: (context) => AboutDialog(
//         applicationName: 'Reval FM',
//         applicationVersion: '1.0.0',
//         applicationIcon: const CircleAvatar(
//           backgroundColor: Colors.deepPurple,
//           child: Icon(Icons.radio, color: Colors.white),
//         ),
//         children: [
//           const SizedBox(height: 10),
//           const Text(
//             'Reval FM - Your favorite radio station app',
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 15),
//           const Text(
//             'Developed by:',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const Text('Patrice S Mgala'),
//           const Text('Software Engineering'),
//           const SizedBox(height: 10),
//           GestureDetector(
//             onTap: _launchWebsite,
//             child: const Text(
//               'mgantitech.co.tz',
//               style: TextStyle(
//                 color: Colors.blue,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showRateAppDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Rate Our App'),
//         content: const Text('If you enjoy using Reval FM, please consider rating us on the app store!'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Later'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               // Add your app store link here
//               _launchWebsite();
//             },
//             child: const Text('Rate Now'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: _buildDrawer(),
//       backgroundColor: Colors.deepPurple.shade900,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // App Bar
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.menu, color: Colors.white),
//                     onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//                   ),
//                   const SizedBox(width: 8),
//                   const Text(
//                     'Reval FM',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: Icon(
//                       _isFavorite ? Icons.favorite : Icons.favorite_border,
//                       color: _isFavorite ? Colors.red : Colors.white,
//                     ),
//                     onPressed: _toggleFavorite,
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.share, color: Colors.white),
//                     onPressed: _shareStation,
//                   ),
//                 ],
//               ),
//             ),

//             // Rest of your main content remains the same...
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 20),
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 20),
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.deepPurple.shade800,
//                             Colors.purple.shade800,
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(24),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.3),
//                             blurRadius: 20,
//                             offset: const Offset(0, 10),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             width: 120,
//                             height: 120,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.purpleAccent,
//                                   Colors.deepPurpleAccent,
//                                 ],
//                                 begin: Alignment.topLeft,
//                                 end: Alignment.bottomRight,
//                               ),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.purpleAccent.withOpacity(0.4),
//                                   blurRadius: 15,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: const Icon(
//                               Icons.radio,
//                               size: 50,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           const Text(
//                             'REVAL FM',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                               letterSpacing: 2,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Live Radio Station',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.white.withOpacity(0.8),
//                             ),
//                           ),
//                           const SizedBox(height: 20),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.black.withOpacity(0.3),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               isPlaying
//                                   ? "🎵 Now Playing"
//                                   : isLoading
//                                   ? "🔄 Connecting..."
//                                   : "📻 Ready to Play",
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           if (errorMessage.isNotEmpty) ...[
//                             const SizedBox(height: 16),
//                             Container(
//                               padding: const EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: Colors.redAccent.withOpacity(0.2),
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(color: Colors.redAccent),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.error,
//                                     color: Colors.redAccent,
//                                     size: 20,
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Expanded(
//                                     child: Text(
//                                       errorMessage,
//                                       style: const TextStyle(
//                                         fontSize: 14,
//                                         color: Colors.redAccent,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                           const SizedBox(height: 32),
//                           GestureDetector(
//                             onTap: _toggleRadio,
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 400),
//                               width: 80,
//                               height: 80,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   colors: isLoading
//                                       ? [Colors.grey, Colors.grey.shade700]
//                                       : isPlaying
//                                       ? [Colors.redAccent, Colors.red.shade700]
//                                       : [
//                                           Colors.greenAccent,
//                                           Colors.green.shade700,
//                                         ],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                 ),
//                                 shape: BoxShape.circle,
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color:
//                                         (isLoading
//                                                 ? Colors.grey
//                                                 : isPlaying
//                                                 ? Colors.redAccent
//                                                 : Colors.greenAccent)
//                                             .withOpacity(0.4),
//                                     blurRadius: 15,
//                                     spreadRadius: 2,
//                                   ),
//                                 ],
//                               ),
//                               child: Stack(
//                                 children: [
//                                   if (isPlaying) ..._createRippleEffects(),
//                                   Center(
//                                     child: Icon(
//                                       isLoading
//                                           ? Icons.hourglass_top
//                                           : isPlaying
//                                           ? Icons.stop
//                                           : Icons.play_arrow,
//                                       size: 40,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 32),
//                           if (isPlaying)
//                             Container(
//                               height: 120,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(16),
//                                 color: Colors.black.withOpacity(0.3),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(16),
//                                 child: WaveWidget(
//                                   config: CustomConfig(
//                                     gradients: [
//                                       [
//                                         Colors.purpleAccent,
//                                         Colors.deepPurpleAccent,
//                                       ],
//                                       [Colors.pinkAccent, Colors.purpleAccent],
//                                     ],
//                                     durations: [35000, 19440],
//                                     heightPercentages: [0.2, 0.25],
//                                     blur: const MaskFilter.blur(
//                                       BlurStyle.solid,
//                                       8,
//                                     ),
//                                     gradientBegin: Alignment.bottomLeft,
//                                     gradientEnd: Alignment.topRight,
//                                   ),
//                                   waveAmplitude: 20,
//                                   size: const Size(
//                                     double.infinity,
//                                     double.infinity,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _createRippleEffects() {
//     return List.generate(3, (index) {
//       return Positioned.fill(
//         child: AnimatedContainer(
//           duration: Duration(milliseconds: 2000 + index * 500),
//           curve: Curves.easeOut,
//           margin: EdgeInsets.all(10 + index * 15),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(
//               color: Colors.white.withOpacity(0.3 - index * 0.1),
//               width: 2,
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }

// // === FAVORITES PAGE ===
// class FavoritesPage extends StatelessWidget {
//   final List<Map<String, dynamic>> favorites;
//   final Function(Map<String, dynamic>) onPlayStation;
//   final Function(Map<String, dynamic>) onRemoveFavorite;

//   const FavoritesPage({
//     super.key,
//     required this.favorites,
//     required this.onPlayStation,
//     required this.onRemoveFavorite,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade900,
//       appBar: AppBar(
//         title: const Text('Favorites'),
//         backgroundColor: Colors.deepPurple.shade800,
//         foregroundColor: Colors.white,
//       ),
//       body: favorites.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.favorite_border,
//                     size: 80,
//                     color: Colors.white.withOpacity(0.5),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'No favorites yet',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white.withOpacity(0.7),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Add stations to favorites to see them here',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.5),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               itemCount: favorites.length,
//               itemBuilder: (context, index) {
//                 final station = favorites[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   color: Colors.deepPurple.shade800,
//                   child: ListTile(
//                     leading: const CircleAvatar(
//                       backgroundColor: Colors.purpleAccent,
//                       child: Icon(Icons.radio, color: Colors.white),
//                     ),
//                     title: Text(
//                       station['name'],
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     subtitle: Text(
//                       'Added ${_formatDate(station['addedAt'])}',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.play_arrow, color: Colors.green),
//                           onPressed: () => onPlayStation(station),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.favorite, color: Colors.red),
//                           onPressed: () => onRemoveFavorite(station),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

// // === RECENT PAGE ===
// class RecentPage extends StatelessWidget {
//   final List<Map<String, dynamic>> recentStations;
//   final Function(Map<String, dynamic>) onPlayStation;

//   const RecentPage({
//     super.key,
//     required this.recentStations,
//     required this.onPlayStation,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade900,
//       appBar: AppBar(
//         title: const Text('Recent Stations'),
//         backgroundColor: Colors.deepPurple.shade800,
//         foregroundColor: Colors.white,
//       ),
//       body: recentStations.isEmpty
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.history,
//                     size: 80,
//                     color: Colors.white.withOpacity(0.5),
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'No recent stations',
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: Colors.white.withOpacity(0.7),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Recently played stations will appear here',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.5),
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             )
//           : ListView.builder(
//               itemCount: recentStations.length,
//               itemBuilder: (context, index) {
//                 final station = recentStations[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   color: Colors.deepPurple.shade800,
//                   child: ListTile(
//                     leading: const CircleAvatar(
//                       backgroundColor: Colors.purpleAccent,
//                       child: Icon(Icons.radio, color: Colors.white),
//                     ),
//                     title: Text(
//                       station['name'],
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                     subtitle: Text(
//                       'Played ${_formatTime(station['playedAt'])}',
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.play_arrow, color: Colors.green),
//                       onPressed: () => onPlayStation(station),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }

//   String _formatTime(DateTime date) {
//     final now = DateTime.now();
//     final difference = now.difference(date);
    
//     if (difference.inMinutes < 1) return 'Just now';
//     if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
//     if (difference.inHours < 24) return '${difference.inHours}h ago';
//     return '${difference.inDays}d ago';
//   }
// }

// // === SETTINGS PAGE ===
// class SettingsPage extends StatefulWidget {
//   final double volume;
//   final bool notificationsEnabled;
//   final bool autoPlay;
//   final String selectedTheme;
//   final Function(double, bool, bool, String) onSettingsChanged;

//   const SettingsPage({
//     super.key,
//     required this.volume,
//     required this.notificationsEnabled,
//     required this.autoPlay,
//     required this.selectedTheme,
//     required this.onSettingsChanged,
//   });

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   late double _volume;
//   late bool _notificationsEnabled;
//   late bool _autoPlay;
//   late String _selectedTheme;

//   @override
//   void initState() {
//     super.initState();
//     _volume = widget.volume;
//     _notificationsEnabled = widget.notificationsEnabled;
//     _autoPlay = widget.autoPlay;
//     _selectedTheme = widget.selectedTheme;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.deepPurple.shade900,
//       appBar: AppBar(
//         title: const Text('Settings'),
//         backgroundColor: Colors.deepPurple.shade800,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.save),
//             onPressed: () {
//               widget.onSettingsChanged(
//                 _volume,
//                 _notificationsEnabled,
//                 _autoPlay,
//                 _selectedTheme,
//               );
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _buildSectionHeader('Audio Settings'),
//           _buildSettingItem(
//             icon: Icons.volume_up,
//             title: 'Volume',
//             subtitle: 'Adjust playback volume',
//             trailing: Slider(
//               value: _volume,
//               onChanged: (value) {
//                 setState(() {
//                   _volume = value;
//                 });
//               },
//               min: 0,
//               max: 1,
//               divisions: 10,
//             ),
//           ),
//           _buildSettingItem(
//             icon: Icons.play_arrow,
//             title: 'Auto Play',
//             subtitle: 'Automatically play when app opens',
//             trailing: Switch(
//               value: _autoPlay,
//               onChanged: (value) {
//                 setState(() {
//                   _autoPlay = value;
//                 });
//               },
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildSectionHeader('App Settings'),
//           _buildSettingItem(
//             icon: Icons.notifications,
//             title: 'Notifications',
//             subtitle: 'Enable push notifications',
//             trailing: Switch(
//               value: _notificationsEnabled,
//               onChanged: (value) {
//                 setState(() {
//                   _notificationsEnabled = value;
//                 });
//               },
//             ),
//           ),
//           _buildSettingItem(
//             icon: Icons.color_lens,
//             title: 'Theme',
//             subtitle: 'Choose app theme',
//             trailing: DropdownButton<String>(
//               value: _selectedTheme,
//               dropdownColor: Colors.deepPurple.shade800,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedTheme = newValue!;
//                 });
//               },
//               items: <String>['Dark', 'Light', 'System']
//                   .map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(
//                     value,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//           const SizedBox(height: 20),
//           _buildSectionHeader('About'),
//           _buildSettingItem(
//             icon: Icons.info,
//             title: 'App Version',
//             subtitle: '1.0.0',
//             onTap: () {},
//           ),
//           _buildSettingItem(
//             icon: Icons.share,
//             title: 'Share App',
//             subtitle: 'Share with friends',
//             onTap: () {
//               Share.share('Check out Reval FM Radio App!');
//             },
//           ),
//           _buildSettingItem(
//             icon: Icons.star,
//             title: 'Rate App',
//             subtitle: 'Rate us on app store',
//             onTap: () {
//               // Add rating logic here
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildSettingItem({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     Widget? trailing,
//     VoidCallback? onTap,
//   }) {
//     return Card(
//       color: Colors.deepPurple.shade800,
//       child: ListTile(
//         leading: Icon(icon, color: Colors.white70),
//         title: Text(title, style: const TextStyle(color: Colors.white)),
//         subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
//         trailing: trailing,
//         onTap: onTap,
//       ),
//     );
//   }
// }