# revalfm

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reval FM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RadioHomePage(),
    );
  }
}

class RadioHomePage extends StatefulWidget {
  const RadioHomePage({super.key});

  @override
  State<RadioHomePage> createState() => _RadioHomePageState();
}

class _RadioHomePageState extends State<RadioHomePage> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;

  final String streamUrl =
      "https://stream.live.vc.bbcmedia.co.uk/bbc_radio_one"; // badilisha na link ya Reval-FM

  void _toggleRadio() async {
    if (isPlaying) {
      await _player.stop();
    } else {
      await _player.play(UrlSource(streamUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text("Reval FM Radio"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo ya radio
          CircleAvatar(
            radius: 80,
            backgroundColor: Colors.deepPurple.shade200,
            child: const Icon(Icons.radio, size: 90, color: Colors.white),
          ),
          const SizedBox(height: 20),

          // Status ya player
          Text(
            isPlaying ? "🔊 Now Playing Reval FM" : "▶ Tap Play to Listen",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 30),

          // Button kubwa ya Play / Stop
          GestureDetector(
            onTap: _toggleRadio,
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: isPlaying ? Colors.redAccent : Colors.greenAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Icon(
                isPlaying ? Icons.stop : Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Waves zikionekana zikicheza wakati iko live
          if (isPlaying)
            SizedBox(
              height: 120,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.deepPurple, Colors.purpleAccent],
                    [Colors.pink, Colors.deepPurpleAccent],
                  ],
                  durations: [35000, 19440],
                  heightPercentages: [0.25, 0.30],
                  blur: const MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 30,
                size: const Size(double.infinity, double.infinity),
              ),
            ),
        ],
      ),
    );
  }
}

kr-morning  01:00 - 04:35
Javiletu    04:00 - 06:45
Ghub        01:00 - 10:00 
