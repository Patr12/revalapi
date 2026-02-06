import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:revalfm/providers/ads_provider.dart';
import 'package:revalfm/providers/auth_provider.dart';
import 'package:revalfm/screen/redio_home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kilimanjaro Revival FM 95.9',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      home: const RadioHomePage(),
    );
  }
}

// // ===== ENHANCED RADIO PROGRAM CLASS =====
// class EnhancedRadioProgram {
//   final String title;
//   final TimeOfDay start;
//   final TimeOfDay end;
//   final String description;
//   final String host;
//   final IconData icon;

//   EnhancedRadioProgram({
//     required this.title,
//     required this.start,
//     required this.end,
//     this.description = '',
//     this.host = '',
//     required this.icon,
//   });
// }

// // ===== ADVERTISEMENT MODEL =====
// class Advertisement {
//   final String id;
//   final String title;
//   final String description;
//   final String imageUrl;
//   final String targetProgram;
//   final DateTime startDate;
//   final DateTime endDate;
//   final int displayDuration;
//   final String advertiser;
//   final String? advertiserContact;
//   final String? advertiserEmail;
//   final String? callToAction;
//   final String? externalLink;
//   final String status;
//   final int impressions;
//   final int clicks;
//   final bool isActive;

//   Advertisement({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//     required this.targetProgram,
//     required this.startDate,
//     required this.endDate,
//     required this.displayDuration,
//     required this.advertiser,
//     this.advertiserContact,
//     this.advertiserEmail,
//     this.callToAction,
//     this.externalLink,
//     required this.status,
//     required this.impressions,
//     required this.clicks,
//     required this.isActive,
//   });

//   factory Advertisement.fromJson(Map<String, dynamic> json) {
//     return Advertisement(
//       id: json['id'].toString(),
//       title: json['title'] ?? '',
//       description: json['description'] ?? '',
//       imageUrl: json['image_url'] ?? 'https://via.placeholder.com/400',
//       targetProgram: json['target_program'] ?? 'General',
//       startDate: DateTime.parse(json['start_date'] ?? DateTime.now().toString()),
//       endDate: DateTime.parse(json['end_date'] ?? DateTime.now().add(const Duration(days: 30)).toString()),
//       displayDuration: json['display_duration'] ?? 30,
//       advertiser: json['advertiser'] ?? '',
//       advertiserContact: json['advertiser_contact'],
//       advertiserEmail: json['advertiser_email'],
//       callToAction: json['call_to_action'],
//       externalLink: json['external_link'],
//       status: json['status'] ?? 'active',
//       impressions: json['impressions'] ?? 0,
//       clicks: json['clicks'] ?? 0,
//       isActive: json['is_active'] ?? false,
//     );
//   }

//   bool matchesProgram(String programTitle) {
//     return targetProgram == programTitle || targetProgram == 'General';
//   }
// }

// // ===== API SERVICE =====
// class ApiService {
//   // Change this to your Django API base URL
//   static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android emulator
//   // static const String baseUrl = 'http://localhost:8000/api'; // iOS simulator
//   // static const String baseUrl = 'https://your-django-api.com/api'; // Production
  
//   static Future<Map<String, dynamic>> fetchActiveAds() async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/ads/active/'),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return {
//           'success': true,
//           'data': data,
//         };
//       } else {
//         return {
//           'success': false,
//           'error': 'API Error: ${response.statusCode}',
//           'data': {'ads': []},
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'error': 'Network Error: $e',
//         'data': {'ads': []},
//       };
//     }
//   }

//   static Future<Map<String, dynamic>> fetchProgramAds(String programName) async {
//     try {
//       final response = await http.get(
//         Uri.parse('$baseUrl/ads/program/$programName/'),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 10));

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return {
//           'success': true,
//           'data': data,
//         };
//       } else {
//         return {
//           'success': false,
//           'error': 'API Error: ${response.statusCode}',
//           'data': {'ads': []},
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'error': 'Network Error: $e',
//         'data': {'ads': []},
//       };
//     }
//   }

//   static Future<Map<String, dynamic>> trackClick(String adId) async {
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/ads/track-click/$adId/'),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//       ).timeout(const Duration(seconds: 5));

//       if (response.statusCode == 200) {
//         return {
//           'success': true,
//           'message': 'Click tracked successfully',
//         };
//       } else {
//         return {
//           'success': false,
//           'error': 'Failed to track click',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'error': 'Network Error: $e',
//       };
//     }
//   }
// }

// // ===== MAIN RADIO PAGE =====
// class RadioHomePage extends StatefulWidget {
//   const RadioHomePage({super.key});

//   @override
//   State<RadioHomePage> createState() => _RadioHomePageState();
// }

// class _RadioHomePageState extends State<RadioHomePage> {
//   final AudioPlayer _player = AudioPlayer();
//   bool isPlaying = false;
//   bool isLoading = false;
//   bool isLoadingAds = false;
//   String errorMessage = '';
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
//   // Settings state
//   double _volume = 1.0;
//   bool _notificationsEnabled = true;
//   bool _autoPlay = false;
//   String _selectedTheme = 'Dark';

//   // Favorites state
//   final List<Map<String, dynamic>> _favorites = [];

//   // Streaming URLs
//   final List<String> streamUrls = [
//     "http://uk3freenew.listen2myradio.com:7235/live",
//     "http://uk3freenew.listen2myradio.com:7235/stream",
//     "http://uk3freenew.listen2myradio.com:7235/;stream.mp3",
//     "http://uk3freenew.listen2myradio.com:7235/;stream.nsv",
//   ];

//   // ===== RADIO SCHEDULE =====
//   final List<EnhancedRadioProgram> todayPrograms = [
//     EnhancedRadioProgram(
//       title: "Morning Show",
//       start: const TimeOfDay(hour: 6, minute: 0),
//       end: const TimeOfDay(hour: 9, minute: 0),
//       description: "Habari, burudani na nyimbo bora za asubuhi",
//       host: "John Matata",
//       icon: Icons.wb_sunny,
//     ),
//     EnhancedRadioProgram(
//       title: "Mid-Morning Mix",
//       start: const TimeOfDay(hour: 9, minute: 0),
//       end: const TimeOfDay(hour: 12, minute: 0),
//       description: "Muziki mseto wa kisasa na wa zamani",
//       host: "Sarah Mwema",
//       icon: Icons.music_note,
//     ),
//     EnhancedRadioProgram(
//       title: "Habari za Mchana",
//       start: const TimeOfDay(hour: 12, minute: 0),
//       end: const TimeOfDay(hour: 13, minute: 0),
//       description: "Habari za mchana na matangazo muhimu",
//       host: "News Team",
//       icon: Icons.newspaper,
//     ),
//     EnhancedRadioProgram(
//       title: "Afternoon Gospel",
//       start: const TimeOfDay(hour: 13, minute: 0),
//       end: const TimeOfDay(hour: 16, minute: 0),
//       description: "Nyimbo za injili na mahubiri",
//       host: "Pastor James",
//       icon: Icons.church,
//     ),
//     EnhancedRadioProgram(
//       title: "Drive Time",
//       start: const TimeOfDay(hour: 16, minute: 0),
//       end: const TimeOfDay(hour: 18, minute: 0),
//       description: "Burudani ya safari ya nyumbani",
//       host: "DJ Flex",
//       icon: Icons.drive_eta,
//     ),
//     EnhancedRadioProgram(
//       title: "Evening Gospel",
//       start: const TimeOfDay(hour: 18, minute: 0),
//       end: const TimeOfDay(hour: 20, minute: 0),
//       description: "Nyimbo za injili jioni na maombi",
//       host: "Sister Grace",
//       icon: Icons.nightlight,
//     ),
//     EnhancedRadioProgram(
//       title: "Late Night Mix",
//       start: const TimeOfDay(hour: 20, minute: 0),
//       end: const TimeOfDay(hour: 22, minute: 0),
//       description: "Muziki wa usiku kwa wasomaji wako",
//       host: "DJ Midnight",
//       icon: Icons.nights_stay,
//     ),
//   ];

//   // Track schedule state
//   EnhancedRadioProgram? _currentProgram;
//   List<EnhancedRadioProgram> _upcomingPrograms = [];
//   List<EnhancedRadioProgram> _pastPrograms = [];

//   // Ads state
//   List<Advertisement> _allAds = [];
//   List<Advertisement> _currentAds = [];
//   int _currentAdIndex = 0;
//   Timer? _adRotationTimer;
//   bool _showAdsSection = false;

//   @override
//   void initState() {
//     super.initState();
//     _setupPlayer();
//     _updateScheduleState();
//     _loadAdsFromAPI();
//     _startScheduleTimer();
//     _startAdRotationTimer();
//   }

//   @override
//   void dispose() {
//     _adRotationTimer?.cancel();
//     _player.dispose();
//     super.dispose();
//   }

//   void _startScheduleTimer() {
//     Timer.periodic(const Duration(minutes: 1), (timer) {
//       if (mounted) {
//         setState(() {
//           _updateScheduleState();
//         });
//       }
//     });
//   }

//   void _startAdRotationTimer() {
//     _adRotationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
//       if (mounted && _currentAds.isNotEmpty) {
//         setState(() {
//           _currentAdIndex = (_currentAdIndex + 1) % _currentAds.length;
//         });
//       }
//     });
//   }

//   void _updateScheduleState() {
//     final now = DateTime.now();
//     final currentTime = TimeOfDay.fromDateTime(now);
    
//     _currentProgram = null;
//     _upcomingPrograms = [];
//     _pastPrograms = [];

//     for (var program in todayPrograms) {
//       final programStartMinutes = program.start.hour * 60 + program.start.minute;
//       final programEndMinutes = program.end.hour * 60 + program.end.minute;
//       final currentMinutes = currentTime.hour * 60 + currentTime.minute;

//       if (currentMinutes >= programStartMinutes && currentMinutes < programEndMinutes) {
//         _currentProgram = program;
//       } else if (currentMinutes < programStartMinutes) {
//         _upcomingPrograms.add(program);
//       } else {
//         _pastPrograms.add(program);
//       }
//     }

//     _upcomingPrograms.sort((a, b) {
//       final aStart = a.start.hour * 60 + a.start.minute;
//       final bStart = b.start.hour * 60 + b.start.minute;
//       return aStart.compareTo(bStart);
//     });

//     // Update ads when program changes
//     _updateCurrentAds();
//   }

//   void _updateCurrentAds() {
//     if (_currentProgram == null) {
//       _currentAds = _allAds.where((ad) => ad.targetProgram == 'General').toList();
//     } else {
//       _currentAds = _allAds
//           .where((ad) => ad.matchesProgram(_currentProgram!.title))
//           .toList();
//     }
    
//     _showAdsSection = _currentAds.isNotEmpty;
//     _currentAdIndex = _currentAds.isNotEmpty ? 0 : 0;
//   }

//   // === LOAD ADS FROM DJANGO API ===
//   Future<void> _loadAdsFromAPI() async {
//     setState(() {
//       isLoadingAds = true;
//     });

//     try {
//       final result = await ApiService.fetchActiveAds();
      
//       if (result['success'] == true) {
//         final data = result['data'];
//         if (data['success'] == true && data['ads'] is List) {
//           setState(() {
//             _allAds = (data['ads'] as List)
//                 .map((adData) => Advertisement.fromJson(adData))
//                 .where((ad) => ad.isActive)
//                 .toList();
//           });
          
//           _updateCurrentAds();
          
//           if (_allAds.isEmpty) {
//             // Show demo ads if API returns empty
//             _loadDemoAds();
//           }
//         } else {
//           _loadDemoAds();
//         }
//       } else {
//         _loadDemoAds();
//         // Show error message if needed
//         if (result['error'] != null) {
//           print('API Error: ${result['error']}');
//         }
//       }
//     } catch (e) {
//       print('Error loading ads: $e');
//       _loadDemoAds();
//     } finally {
//       setState(() {
//         isLoadingAds = false;
//       });
//     }
//   }

//   void _loadDemoAds() {
//     setState(() {
//       _allAds = [
//         Advertisement(
//           id: 'demo1',
//           title: '🎵 Demo: Tangazo la Redio',
//           description: 'Huu ni matangazo ya demo. Unaweza kuongeza matangazo yako halisi kwenye admin panel ya Django.',
//           imageUrl: 'https://images.unsplash.com/photo-1584820927498-cfe5211fd8bf?w=400&h=200&fit=crop',
//           targetProgram: 'General',
//           startDate: DateTime.now().subtract(const Duration(days: 1)),
//           endDate: DateTime.now().add(const Duration(days: 365)),
//           displayDuration: 30,
//           advertiser: 'Demo System',
//           status: 'active',
//           impressions: 0,
//           clicks: 0,
//           isActive: true,
//         ),
//         Advertisement(
//           id: 'demo2',
//           title: '📢 Set up Your Ads',
//           description: 'Ingia kwenye admin panel ya Django na uongeze matangazo yako halisi.',
//           imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=400&h=200&fit=crop',
//           targetProgram: 'Morning Show',
//           startDate: DateTime.now().subtract(const Duration(days: 1)),
//           endDate: DateTime.now().add(const Duration(days: 365)),
//           displayDuration: 45,
//           advertiser: 'System Admin',
//           status: 'active',
//           impressions: 0,
//           clicks: 0,
//           isActive: true,
//         ),
//       ];
      
//       _updateCurrentAds();
//     });
//   }

//   // === TRACK AD CLICK ===
//   Future<void> _trackAdClick(String adId) async {
//     try {
//       await ApiService.trackClick(adId);
//       // Optional: Show feedback or update UI
//     } catch (e) {
//       print('Failed to track click: $e');
//     }
//   }

//   String _getTimeUntilStart(EnhancedRadioProgram program) {
//     final now = DateTime.now();
//     final programStart = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       program.start.hour,
//       program.start.minute,
//     );
    
//     final difference = programStart.difference(now);
    
//     if (difference.inMinutes < 60) {
//       return 'Inaanza baada ya ${difference.inMinutes} dakika';
//     } else if (difference.inHours < 24) {
//       final hours = difference.inHours;
//       final minutes = difference.inMinutes % 60;
//       return 'Inaanza baada ya $hours saa ${minutes > 0 ? 'na $minutes dakika' : ''}';
//     } else {
//       return 'Inaanza ${program.start.format(context)}';
//     }
//   }

//   String _getProgressPercentage(EnhancedRadioProgram program) {
//     if (_currentProgram != program) return '';
    
//     final now = DateTime.now();
//     final programStart = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       program.start.hour,
//       program.start.minute,
//     );
//     final programEnd = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       program.end.hour,
//       program.end.minute,
//     );
    
//     final totalDuration = programEnd.difference(programStart).inMinutes;
//     final elapsed = now.difference(programStart).inMinutes;
    
//     if (totalDuration > 0) {
//       final percentage = (elapsed / totalDuration * 100).toInt();
//       return '$percentage% imekwisha';
//     }
    
//     return '';
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
//           break;
//         } catch (_) {
//           continue;
//         }
//       }

//       if (!success) {
//         setState(() {
//           errorMessage = 'Haikuweza kushikamana na redio. Angalia mtandao wako.';
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Hitilafu: ${e.toString()}';
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
//         errorMessage = 'Hitilafu ya kusitisha redio: ${e.toString()}';
//       });
//     }
//   }

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
//                   'Kilimanjaro Revival FM 95.9',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const Text(
//                   'Redio Yako Inayopendwa',
//                   style: TextStyle(fontSize: 14, color: Colors.white70),
//                 ),
//               ],
//             ),
//           ),
//           _buildDrawerItem(
//             icon: Icons.home,
//             title: 'Nyumbani',
//             onTap: () {
//               Navigator.pop(context);
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.favorite,
//             title: 'Vipendwa',
//             onTap: () {
//               Navigator.pop(context);
//               _showFavoritesPage();
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.refresh,
//             title: 'Sasisha Matangazo',
//             onTap: () {
//               Navigator.pop(context);
//               _loadAdsFromAPI();
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Inasasisha matangazo...'),
//                   backgroundColor: Colors.green.shade700,
//                 ),
//               );
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.settings,
//             title: 'Mipangilio',
//             onTap: () {
//               Navigator.pop(context);
//               _showSettingsPage();
//             },
//           ),
//           _buildDrawerItem(
//             icon: Icons.info,
//             title: 'Kuhusu',
//             onTap: () {
//               Navigator.pop(context);
//               _showAboutPage();
//             },
//           ),
//           const Divider(color: Colors.white30),
//           _buildDrawerItem(
//             icon: Icons.share,
//             title: 'Sambaza App',
//             onTap: () {},
//           ),
//           _buildDrawerItem(
//             icon: Icons.star,
//             title: 'Tathmini App',
//             onTap: () {},
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 15),
//             alignment: Alignment.center,
//             child: const Text(
//               "Patrice S Mgala - Software Engineering\nmgantitech.co.tz\nToleo 1.0.0",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.white70,
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

//   void _showSettingsPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SettingsPage(
//           volume: _volume,
//           notificationsEnabled: _notificationsEnabled,
//           autoPlay: _autoPlay,
//           selectedTheme: _selectedTheme,
//           onSettingsChanged:
//               (newVolume, newNotifications, newAutoPlay, newTheme) {
//                 setState(() {
//                   _volume = newVolume;
//                   _notificationsEnabled = newNotifications;
//                   _autoPlay = newAutoPlay;
//                   _selectedTheme = newTheme;
//                 });
//                 _saveSettings();
//               },
//         ),
//       ),
//     );
//   }

//   void _showAboutPage() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.deepPurple.shade900,
//         title: const Row(
//           children: [
//             Icon(Icons.radio, color: Colors.white),
//             SizedBox(width: 10),
//             Text('Kuhusu App', style: TextStyle(color: Colors.white)),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Kilimanjaro Revival FM 95.9',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Redio bora ya Kikristo na Habari',
//               style: TextStyle(color: Colors.white70),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Imetengenezwa na:',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const Text('Patrice S Mgala', style: TextStyle(color: Colors.white70)),
//             const Text('Software Engineering', style: TextStyle(color: Colors.white70)),
//             const SizedBox(height: 10),
//             GestureDetector(
//               onTap: () {},
//               child: const Text(
//                 'mgantitech.co.tz',
//                 style: TextStyle(
//                   color: Colors.blue,
//                   decoration: TextDecoration.underline,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               'Toleo 1.0.0',
//               style: TextStyle(color: Colors.white54, fontSize: 12),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Sawa'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showFavoritesPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FavoritesPage(
//           favorites: _favorites,
//           onPlayStation: (station) {
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

//   void _toggleFavorite() {
//     setState(() {
//       bool isFavorite = _favorites.any(
//         (fav) => fav['name'] == 'Kilimanjaro Revival FM 95.9',
//       );
//       if (isFavorite) {
//         _favorites.removeWhere(
//           (fav) => fav['name'] == 'Kilimanjaro Revival FM 95.9',
//         );
//       } else {
//         _favorites.add({
//           'name': 'Kilimanjaro Revival FM 95.9',
//           'url': streamUrls.first,
//           'image': 'assets/radio_icon.png',
//           'addedAt': DateTime.now(),
//         });
//       }
//     });
//   }

//   bool get _isFavorite {
//     return _favorites.any(
//       (fav) => fav['name'] == 'Kilimanjaro Revival FM 95.9',
//     );
//   }

//   void _saveSettings() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Mipangilio imehifadhiwa!'),
//         backgroundColor: Colors.green.shade700,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final now = TimeOfDay.now();
//     final currentTimeStr = now.format(context);

//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: _buildDrawer(),
//       backgroundColor: Colors.deepPurple.shade900,
//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: isPlaying ? Colors.red.shade700 : Colors.green.shade700,
//         onPressed: _toggleRadio,
//         icon: isLoading
//             ? const SizedBox(
//                 width: 20,
//                 height: 20,
//                 child: CircularProgressIndicator(
//                   color: Colors.white,
//                   strokeWidth: 2,
//                 ),
//               )
//             : Icon(isPlaying ? Icons.stop : Icons.play_arrow),
//         label: isLoading
//             ? const Text('INAANGAZA...')
//             : Text(isPlaying ? 'SIMAMISHA' : 'CHEZA'),
//         elevation: 8,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(30),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Simple App Bar
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Colors.deepPurple.shade800,
//                     Colors.purple.shade800,
//                   ],
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.menu, color: Colors.white),
//                     onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//                   ),
//                   const SizedBox(width: 8),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Kilimanjaro Revival',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                       Text(
//                         currentTimeStr,
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.white.withOpacity(0.8),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: Icon(
//                       _isFavorite ? Icons.favorite : Icons.favorite_border,
//                       color: _isFavorite ? Colors.red : Colors.white,
//                     ),
//                     onPressed: _toggleFavorite,
//                   ),
//                 ],
//               ),
//             ),

//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.only(bottom: 80),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 20),

//                     // Current Program Card
//                     if (_currentProgram != null)
//                       Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 20),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Colors.green.shade800.withOpacity(0.8),
//                               Colors.green.shade600.withOpacity(0.8),
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.green.withOpacity(0.3),
//                               blurRadius: 15,
//                               offset: const Offset(0, 5),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white.withOpacity(0.2),
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Icon(
//                                     _currentProgram!.icon,
//                                     color: Colors.white,
//                                     size: 24,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.circle,
//                                             color: Colors.white,
//                                             size: 10,
//                                           ),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             'KIPINDI KINACHOCHEZA',
//                                             style: TextStyle(
//                                               color: Colors.white.withOpacity(0.9),
//                                               fontSize: 11,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         _currentProgram!.title,
//                                         style: const TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                       Text(
//                                         '${_currentProgram!.start.format(context)} - ${_currentProgram!.end.format(context)}',
//                                         style: TextStyle(
//                                           fontSize: 14,
//                                           color: Colors.white.withOpacity(0.8),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 12),
//                             if (_currentProgram!.description.isNotEmpty)
//                               Text(
//                                 _currentProgram!.description,
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white.withOpacity(0.9),
//                                 ),
//                               ),
//                             const SizedBox(height: 8),
//                             if (_currentProgram!.host.isNotEmpty)
//                               Row(
//                                 children: [
//                                   const Icon(
//                                     Icons.person,
//                                     size: 14,
//                                     color: Colors.white70,
//                                   ),
//                                   const SizedBox(width: 6),
//                                   Text(
//                                     'Mwenye kipindi: ${_currentProgram!.host}',
//                                     style: TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.white.withOpacity(0.8),
//                                       fontStyle: FontStyle.italic,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             const SizedBox(height: 12),
//                             // Progress indicator
//                             LinearProgressIndicator(
//                               value: _getProgressPercentage(_currentProgram!)
//                                   .replaceAll('% imekwisha', '')
//                                   .isEmpty
//                                   ? 0.5
//                                   : int.parse(_getProgressPercentage(_currentProgram!)
//                                       .replaceAll('% imekwisha', '')) / 100,
//                               backgroundColor: Colors.white.withOpacity(0.2),
//                               color: Colors.white,
//                               minHeight: 4,
//                             ),
//                             const SizedBox(height: 8),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   _currentProgram!.start.format(context),
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white.withOpacity(0.7),
//                                   ),
//                                 ),
//                                 Text(
//                                   _getProgressPercentage(_currentProgram!),
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white.withOpacity(0.7),
//                                   ),
//                                 ),
//                                 Text(
//                                   _currentProgram!.end.format(context),
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.white.withOpacity(0.7),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),

//                     const SizedBox(height: 20),

//                     // Radio Player Card
//                     Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 20),
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.deepPurple.shade800,
//                             Colors.purple.shade800,
//                           ],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
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
//                             width: 100,
//                             height: 100,
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
//                           const SizedBox(height: 20),

//                           const Text(
//                             'Kilimanjaro Revival FM 95.9',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           const Text(
//                             'Redio ya Kikristo na Habari',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.white70,
//                             ),
//                           ),
//                           const SizedBox(height: 20),

//                           if (errorMessage.isNotEmpty)
//                             Container(
//                               margin: const EdgeInsets.only(bottom: 16),
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

//                           if (isPlaying)
//                             Container(
//                               height: 100,
//                               margin: const EdgeInsets.only(bottom: 20),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 color: Colors.black.withOpacity(0.3),
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
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
//                                   waveAmplitude: isPlaying ? 20 : 0,
//                                   size: const Size(double.infinity, double.infinity),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 30),

//                     // ===== ADS SECTION =====
//                     if (_showAdsSection)
//                       Container(
//                         margin: const EdgeInsets.symmetric(horizontal: 20),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 const Icon(Icons.ads_click, color: Colors.white),
//                                 const SizedBox(width: 8),
//                                 const Text(
//                                   "Matangazo",
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 const Spacer(),
//                                 if (isLoadingAds)
//                                   const SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       strokeWidth: 2,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 if (_currentProgram != null)
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 4,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.green.withOpacity(0.2),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: Text(
//                                       'Kipindi: ${_currentProgram!.title}',
//                                       style: const TextStyle(
//                                         color: Colors.green,
//                                         fontSize: 12,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),

//                             // Current Ad Display
//                             if (_currentAds.isNotEmpty && _currentAds.length > _currentAdIndex)
//                               _buildAdCard(_currentAds[_currentAdIndex]),
                            
//                             // Ad Counter
//                             if (_currentAds.length > 1)
//                               Padding(
//                                 padding: const EdgeInsets.only(top: 10),
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     for (int i = 0; i < _currentAds.length; i++)
//                                       Container(
//                                         width: 8,
//                                         height: 8,
//                                         margin: const EdgeInsets.symmetric(horizontal: 4),
//                                         decoration: BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: i == _currentAdIndex
//                                               ? Colors.purpleAccent
//                                               : Colors.white.withOpacity(0.3),
//                                         ),
//                                       ),
//                                   ],
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),

//                     const SizedBox(height: 30),

//                     // Schedule Section
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.schedule, color: Colors.white),
//                               const SizedBox(width: 8),
//                               const Text(
//                                 "Ratiba ya Leo",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               const Spacer(),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 12,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   '${todayPrograms.length} vipindi',
//                                   style: const TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 16),

//                           // Upcoming Programs
//                           if (_upcomingPrograms.isNotEmpty)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   "Vijavyo",
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 ..._upcomingPrograms.map((program) {
//                                   return _buildProgramCard(program, false, true);
//                                 }),
//                                 const SizedBox(height: 20),
//                               ],
//                             ),

//                           // Past Programs
//                           if (_pastPrograms.isNotEmpty)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Text(
//                                   "Vilivyopita",
//                                   style: TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 ..._pastPrograms.map((program) {
//                                   return _buildProgramCard(program, false, false);
//                                 }),
//                               ],
//                             ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProgramCard(EnhancedRadioProgram program, bool isCurrent, bool isUpcoming) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: isCurrent
//             ? Colors.greenAccent.withOpacity(0.3)
//             : isUpcoming
//                 ? Colors.blueAccent.withOpacity(0.1)
//                 : Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isCurrent
//               ? Colors.greenAccent
//               : isUpcoming
//                   ? Colors.blueAccent.withOpacity(0.3)
//                   : Colors.transparent,
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: isCurrent
//                   ? Colors.greenAccent.withOpacity(0.2)
//                   : isUpcoming
//                       ? Colors.blueAccent.withOpacity(0.2)
//                       : Colors.white.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Icon(
//               program.icon,
//               color: isCurrent
//                   ? Colors.greenAccent
//                   : isUpcoming
//                       ? Colors.blueAccent
//                       : Colors.white70,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   program.title,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${program.start.format(context)} - ${program.end.format(context)}',
//                   style: TextStyle(
//                     color: Colors.white70,
//                     fontSize: 13,
//                   ),
//                 ),
//                 if (isUpcoming && !isCurrent)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 4),
//                     child: Text(
//                       _getTimeUntilStart(program),
//                       style: const TextStyle(
//                         color: Colors.blueAccent,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdCard(Advertisement ad) {
//     return GestureDetector(
//       onTap: () {
//         _trackAdClick(ad.id);
//         if (ad.externalLink != null && ad.externalLink!.isNotEmpty) {
//           // Open external link if available
//           // You can use url_launcher package here
//           print('Opening: ${ad.externalLink}');
//         }
//       },
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         decoration: BoxDecoration(
//           color: Colors.deepPurple.shade800,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: Colors.purpleAccent.withOpacity(0.3),
//             width: 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.purpleAccent.withOpacity(0.2),
//               blurRadius: 10,
//               offset: const Offset(0, 5),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Ad Image
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//               child: Image.network(
//                 ad.imageUrl,
//                 height: 180,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 loadingBuilder: (context, child, loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Container(
//                     height: 180,
//                     color: Colors.grey[800],
//                     child: Center(
//                       child: CircularProgressIndicator(
//                         value: loadingProgress.expectedTotalBytes != null
//                             ? loadingProgress.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                             : null,
//                       ),
//                     ),
//                   );
//                 },
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     height: 180,
//                     color: Colors.grey[800],
//                     child: const Center(
//                       child: Icon(
//                         Icons.photo,
//                         color: Colors.white54,
//                         size: 50,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
            
//             // Ad Content
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           ad.title,
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       if (ad.targetProgram != 'General')
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.green.withOpacity(0.2),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             ad.targetProgram,
//                             style: const TextStyle(
//                               color: Colors.green,
//                               fontSize: 10,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 8),
                  
//                   // Advertiser
//                   Text(
//                     'Mtangazaji: ${ad.advertiser}',
//                     style: TextStyle(
//                       color: Colors.white70,
//                       fontSize: 14,
//                       fontStyle: FontStyle.italic,
//                     ),
//                   ),
                  
//                   const SizedBox(height: 12),
                  
//                   // Description
//                   if (ad.description.isNotEmpty)
//                     Text(
//                       ad.description,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                       ),
//                     ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Call to Action and Stats
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       if (ad.callToAction != null)
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 16,
//                             vertical: 8,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.purpleAccent,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             children: [
//                               Text(
//                                 ad.callToAction!,
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               const Icon(Icons.touch_app, size: 16, color: Colors.white),
//                             ],
//                           ),
//                         ),
                      
//                       // Stats
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             'Muda: ${ad.displayDuration}s',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 12,
//                             ),
//                           ),
//                           Text(
//                             'Onesho: ${ad.impressions}',
//                             style: TextStyle(
//                               color: Colors.white70,
//                               fontSize: 10,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }