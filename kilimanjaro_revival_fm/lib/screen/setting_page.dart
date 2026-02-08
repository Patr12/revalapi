// === SETTINGS PAGE ===
import 'package:flutter/material.dart';


class SettingsPage extends StatefulWidget {
  final double volume;
  final bool notificationsEnabled;
  final bool autoPlay;
  final String selectedTheme;
  final Function(double, bool, bool, String) onSettingsChanged;

  const SettingsPage({
    super.key,
    required this.volume,
    required this.notificationsEnabled,
    required this.autoPlay,
    required this.selectedTheme,
    required this.onSettingsChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _volume;
  late bool _notificationsEnabled;
  late bool _autoPlay;
  late String _selectedTheme;

  @override
  void initState() {
    super.initState();
    _volume = widget.volume;
    _notificationsEnabled = widget.notificationsEnabled;
    _autoPlay = widget.autoPlay;
    _selectedTheme = widget.selectedTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade900,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepPurple.shade800,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              widget.onSettingsChanged(
                _volume,
                _notificationsEnabled,
                _autoPlay,
                _selectedTheme,
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Audio Settings'),
          _buildSettingItem(
            icon: Icons.volume_up,
            title: 'Volume',
            subtitle: 'Adjust playback volume',
            trailing: Slider(
              value: _volume,
              onChanged: (value) {
                setState(() {
                  _volume = value;
                });
              },
              min: 0,
              max: 1,
              divisions: 10,
            ),
          ),
          _buildSettingItem(
            icon: Icons.play_arrow,
            title: 'Auto Play',
            subtitle: 'Automatically play when app opens',
            trailing: Switch(
              value: _autoPlay,
              onChanged: (value) {
                setState(() {
                  _autoPlay = value;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('App Settings'),
          _buildSettingItem(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Enable push notifications',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
          ),
          _buildSettingItem(
            icon: Icons.color_lens,
            title: 'Theme',
            subtitle: 'Choose app theme',
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              dropdownColor: Colors.deepPurple.shade800,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTheme = newValue!;
                });
              },
              items: <String>['Dark', 'Light', 'System']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          _buildSectionHeader('About'),
          _buildSettingItem(
            icon: Icons.info,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Icons.share,
            title: 'Share App',
            subtitle: 'Share with friends',
            onTap: () {
            
            },
          ),
          _buildSettingItem(
            icon: Icons.star,
            title: 'Rate App',
            subtitle: 'Rate us on app store',
            onTap: () {
              // Add rating logic here
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

Widget _buildSettingItem({
  required IconData icon,
  required String title,
  required String subtitle,
  Widget? trailing,
  VoidCallback? onTap,
}) {
  return Card(
    color: Colors.deepPurple.shade800,
    margin: const EdgeInsets.symmetric(vertical: 6),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      isThreeLine: true, // hii inaipa nafasi nzuri layout
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(color: Colors.white70),
      ),
      trailing: trailing != null
          ? ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: trailing,
            )
          : null,
      onTap: onTap,
    ),
  );
}

}