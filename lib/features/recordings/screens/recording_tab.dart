/// with setState
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:recordings1/features/recordings/models/recording.dart';
// import 'package:recordings1/features/recordings/screens/record_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class RecordingTab extends StatefulWidget {
//   const RecordingTab({super.key});
//
//   @override
//   State<RecordingTab> createState() => _RecordingTabState();
// }
//
// class _RecordingTabState extends State<RecordingTab> {
//   List<Recording> recordings = [];
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   int? _currentlyPlayingIndex; // Track the currently playing recording
//
//   @override
//   void initState() {
//     super.initState();
//     _loadRecordings();
//     // Listen to audio player state changes to update UI
//     _audioPlayer.playerStateStream.listen((state) {
//       if (state.processingState == ProcessingState.completed ||
//           !state.playing) {
//         setState(() {
//           _currentlyPlayingIndex = null; // Reset when audio finishes
//         });
//       }
//     });
//   }
//
//   Future<void> _loadRecordings() async {
//     final prefs = await SharedPreferences.getInstance();
//     final recordingsJson = prefs.getStringList('recordings') ?? [];
//     setState(() {
//       recordings = recordingsJson
//           .map((json) => Recording.fromJson(jsonDecode(json)))
//           .toList();
//     });
//   }
//
//   Future<void> _saveRecordings() async {
//     final prefs = await SharedPreferences.getInstance();
//     final recordingsJson = recordings.map((r) => jsonEncode(r.toJson())).toList();
//     await prefs.setStringList('recordings', recordingsJson);
//   }
//
//   Future<void> _deleteRecording(int index) async {
//     final recording = recordings[index];
//     // Stop audio if the deleted recording is playing
//     if (_currentlyPlayingIndex == index) {
//       await _audioPlayer.stop();
//       setState(() {
//         _currentlyPlayingIndex = null;
//       });
//     }
//     await File(recording.path).delete();
//     setState(() {
//       recordings.removeAt(index);
//     });
//     await _saveRecordings();
//   }
//
//   Future<void> _togglePlay(int index) async {
//     final recording = recordings[index];
//
//     // If the same recording is tapped while playing, pause it
//     if (_currentlyPlayingIndex == index && _audioPlayer.playing) {
//       await _audioPlayer.pause();
//       setState(() {
//         _currentlyPlayingIndex = null;
//       });
//     } else {
//       // Stop any currently playing audio
//       if (_currentlyPlayingIndex != null) {
//         await _audioPlayer.stop();
//       }
//       // Play the new recording
//       await _audioPlayer.setFilePath(recording.path);
//       await _audioPlayer.play();
//       setState(() {
//         _currentlyPlayingIndex = index;
//       });
//     }
//   }
//
//   // Helper function to darken a color
//   Color _darkenColor(Color color, [double amount = 0.2]) {
//     assert(amount >= 0 && amount <= 1);
//     final red = (color.red * (1 - amount)).round().clamp(0, 255);
//     final green = (color.green * (1 - amount)).round().clamp(0, 255);
//     final blue = (color.blue * (1 - amount)).round().clamp(0, 255);
//     return Color.fromRGBO(red, green, blue, 1.0);
//   }
//
//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: recordings.isEmpty
//           ?  Center(child: Image.asset("assets/images/emptyState.png"))
//           : GridView.builder(
//         padding: const EdgeInsets.all(8.0),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 8.0,
//           mainAxisSpacing: 8.0,
//         ),
//         itemCount: recordings.length,
//         itemBuilder: (context, index) {
//           final recording = recordings[index];
//           final isPlaying = _currentlyPlayingIndex == index && _audioPlayer.playing;
//
//           return Card(
//             color: recording.color,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//               side: BorderSide(
//                 color: _darkenColor(recording.color), // Darker version of the recording color
//                 width: 1.5,
//               ),
//             ),
//             elevation: 2,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     recording.title,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const Spacer(),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       // Play/Pause Button
//                       GestureDetector(
//                         onTap: () => _togglePlay(index),
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                           ),
//                           child: Icon(
//                             isPlaying ? Icons.pause : Icons.play_arrow,
//                             color: const Color(0xFF113C6D),
//                             size: 24,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 20),
//                       // Delete Button
//                       GestureDetector(
//                         onTap: () => _deleteRecording(index),
//                         child: Container(
//                           width: 40,
//                           height: 40,
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white,
//                           ),
//                           child: const Icon(
//                             Icons.delete,
//                             color: Colors.red,
//                             size: 24,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF113C6D),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const RecordScreen()),
//           ).then((_) => _loadRecordings());
//         },
//         child: const Icon(Icons.mic, color: Colors.white),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:recordings1/features/recordings/models/recording.dart';
import 'package:recordings1/features/recordings/screens/record_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordingTab extends StatefulWidget {
  const RecordingTab({super.key});

  @override
  State<RecordingTab> createState() => _RecordingTabState();
}

class _RecordingTabState extends State<RecordingTab> {
  List<Recording> recordings = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  int? _currentlyPlayingIndex; // Track the currently playing recording
  bool _isPlaying = false; // Explicitly track playing state

  @override
  void initState() {
    super.initState();
    _loadRecordings();
    // Listen to audio player state changes for pause and completion events
    _audioPlayer.playerStateStream.listen((state) {
      print('Player state changed: playing=${state.playing}, processingState=${state.processingState}, _currentlyPlayingIndex=$_currentlyPlayingIndex');
      if (state.processingState == ProcessingState.completed || !state.playing) {
        print('Audio completed or paused, resetting state');
        setState(() {
          _currentlyPlayingIndex = null;
          _isPlaying = false;
        });
      }
    });
  }

  Future<void> _loadRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    final recordingsJson = prefs.getStringList('recordings') ?? [];
    setState(() {
      recordings = recordingsJson
          .map((json) => Recording.fromJson(jsonDecode(json)))
          .toList();
      print('Loaded recordings: $recordings');
    });
  }

  Future<void> _saveRecordings() async {
    final prefs = await SharedPreferences.getInstance();
    final recordingsJson = recordings.map((r) => jsonEncode(r.toJson())).toList();
    await prefs.setStringList('recordings', recordingsJson);
    print('Saved recordings: $recordingsJson');
  }

  Future<void> _deleteRecording(int index) async {
    final recording = recordings[index];
    // Stop audio if the deleted recording is playing
    if (_currentlyPlayingIndex == index) {
      await _audioPlayer.stop();
      setState(() {
        _currentlyPlayingIndex = null;
        _isPlaying = false;
      });
    }
    await File(recording.path).delete();
    setState(() {
      recordings.removeAt(index);
    });
    await _saveRecordings();
  }

  Future<void> _togglePlay(int index) async {
    final recording = recordings[index];

    try {
      // If the same recording is tapped while playing, pause it
      if (_currentlyPlayingIndex == index && _isPlaying) {
        print('Pausing audio at index: $index');
        await _audioPlayer.pause();
        // The playerStateStream listener will handle the state update
      } else {
        // Stop any currently playing audio
        if (_currentlyPlayingIndex != null) {
          print('Stopping previous audio at index: $_currentlyPlayingIndex');
          await _audioPlayer.stop();
        }
        // Play the new recording
        print('Playing audio at index: $index, path: ${recording.path}');
        // Verify the file exists
        final file = File(recording.path);
        if (!await file.exists()) {
          throw Exception('Audio file does not exist at ${recording.path}');
        }
        await _audioPlayer.setFilePath(recording.path);
        setState(() {
          _currentlyPlayingIndex = index;
          _isPlaying = true;
        });
        await _audioPlayer.play();
      }
    } catch (e) {
      print('Error in _togglePlay: $e');
      setState(() {
        _currentlyPlayingIndex = null;
        _isPlaying = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play audio: $e')),
      );
    }
  }

  // Helper function to darken a color
  Color _darkenColor(Color color, [double amount = 0.2]) {
    assert(amount >= 0 && amount <= 1);
    final red = (color.red * (1 - amount)).round().clamp(0, 255);
    final green = (color.green * (1 - amount)).round().clamp(0, 255);
    final blue = (color.blue * (1 - amount)).round().clamp(0, 255);
    return Color.fromRGBO(red, green, blue, 1.0);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building RecordingTab, recordings: ${recordings.length}, _currentlyPlayingIndex: $_currentlyPlayingIndex, _isPlaying: $_isPlaying');
    return Scaffold(
      body: recordings.isEmpty
          ? Center(child: Image.asset("assets/images/emptyState.png"))
          : GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: recordings.length,
        itemBuilder: (context, index) {
          final recording = recordings[index];
          final isPlaying = _currentlyPlayingIndex == index && _isPlaying;
          print('Item $index: isPlaying=$isPlaying, _isPlaying=$_isPlaying, _audioPlayer.playing=${_audioPlayer.playing}');

          return Card(
            color: recording.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: _darkenColor(recording.color), // Darker version of the recording color
                width: 1.5,
              ),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recording.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Play/Pause Button
                      GestureDetector(
                        onTap: () => _togglePlay(index),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: const Color(0xFF113C6D),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Delete Button
                      GestureDetector(
                        onTap: () => _deleteRecording(index),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 24,
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF113C6D),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RecordScreen()),
          ).then((_) => _loadRecordings());
        },
        child: const Icon(Icons.mic, color: Colors.white),
      ),
    );
  }
}

