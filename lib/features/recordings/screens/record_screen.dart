/// with setState
// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
// import 'package:recordings1/features/recordings/models/recording.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class RecordScreen extends StatefulWidget {
//   const RecordScreen({super.key});
//
//   @override
//   State<RecordScreen> createState() => _RecordScreenState();
// }
//
// class _RecordScreenState extends State<RecordScreen> {
//   final _record = Record();
//   bool _isRecording = false;
//   String _filePath = '';
//   Duration _elapsed = Duration.zero;
//   Timer? _timer;
//   Color? _selectedColor; // Initially null to disable submit button
//   final TextEditingController _titleController = TextEditingController(); // Controller for the title input
//
//   Future<void> _startRecording() async {
//     final status = await Permission.microphone.request();
//     if (status.isGranted) {
//       final directory = await getTemporaryDirectory();
//       final path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
//       await _record.start(
//         path: path,
//         encoder: AudioEncoder.aacLc,
//       );
//       setState(() {
//         _isRecording = true;
//         _filePath = path;
//         _elapsed = Duration.zero;
//       });
//
//       _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//         setState(() {
//           _elapsed += const Duration(seconds: 1);
//         });
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Microphone permission is denied.'),
//           action: SnackBarAction(
//             label: 'Settings',
//             onPressed: () => openAppSettings(),
//           ),
//         ),
//       );
//     }
//   }
//
//   Future<void> _stopRecording({bool save = false, String? title, Color? color}) async {
//     _timer?.cancel();
//     await _record.stop();
//
//     if (save && _filePath.isNotEmpty) {
//       final prefs = await SharedPreferences.getInstance();
//       final recordingsJson = prefs.getStringList('recordings') ?? [];
//       final recording = Recording(
//         title: title ?? 'Recording ${DateTime.now()}', // Use provided title or default
//         path: _filePath,
//         color: color ?? Colors.blue, // Use provided color or default
//       );
//       recordingsJson.add(jsonEncode(recording.toJson()));
//       await prefs.setStringList('recordings', recordingsJson);
//     }
//
//     if (mounted) Navigator.pop(context);
//   }
//
//   void _cancelRecording() async {
//     _timer?.cancel();
//     await _record.stop();
//     if (mounted) Navigator.pop(context);
//   }
//
//   void _confirmSave() {
//     // Use FutureBuilder to handle the async recordingsCount
//     showDialog(
//       context: context,
//       builder: (context) => FutureBuilder<int>(
//         future: recordingsCount,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const AlertDialog(
//               content: Center(child: CircularProgressIndicator()),
//             );
//           }
//           if (snapshot.hasError) {
//             return AlertDialog(
//               content: Text('Error: ${snapshot.error}'),
//             );
//           }
//
//           // Set the default title once the count is available
//           _selectedColor = null; // Initially null to disable the submit button
//           _titleController.text = 'Recording ${snapshot.data! + 1}';
//
//           return StatefulBuilder(
//             builder: (context, setDialogState) => AlertDialog(
//               title: const Text(
//                 "Save Recording",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Editable recording name field
//                   TextField(
//                     controller: _titleController,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                       hintText: 'Recording 1',
//                       hintStyle: const TextStyle(color: Colors.black54),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   // Color selection label
//                   const Text(
//                     "Select Card Color",
//                     style: TextStyle(fontSize: 16, color: Colors.black87),
//                   ),
//                   const SizedBox(height: 10),
//                   // Color selection row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _buildColorOption(const Color(0xFFFFE6E6), setDialogState), // Light Pink
//                       _buildColorOption(const Color(0xFFE6E6FF), setDialogState), // Light Purple
//                       _buildColorOption(const Color(0xFFFFE6F0), setDialogState), // Light Red
//                       _buildColorOption(const Color(0xFFE6FFE6), setDialogState), // Light Green
//                       _buildColorOption(const Color(0xFFE6F0FF), setDialogState), // Light Blue
//                       _buildColorOption(const Color(0xFFFFF0E6), setDialogState), // Light Orange
//                     ],
//                   ),
//                 ],
//               ),
//               actions: [
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: _selectedColor == null
//                         ? null // Disable the button if no color is selected
//                         : () async {
//                       Navigator.of(context).pop();
//                       await _stopRecording(
//                         save: true,
//                         title: _titleController.text,
//                         color: _selectedColor,
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: _selectedColor == null
//                           ? Colors.grey.shade300 // Disabled color
//                           : const Color(0xFF113C6D), // Enabled color
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child:  Text(
//                       "SUBMIT",
//                       style: TextStyle(
//                         color: _selectedColor==null?Colors.black87:Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildColorOption(Color color, StateSetter setDialogState) {
//     return GestureDetector(
//       onTap: () {
//         setDialogState(() {
//           _selectedColor = color;
//         });
//         setState(() {
//           _selectedColor = color;
//         });
//       },
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//               color: color,
//               border: Border.all(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(5),
//             ),
//           ),
//           if (_selectedColor == color)
//             const Icon(
//               Icons.check,
//               color: Colors.black54,
//               size: 20,
//             ),
//         ],
//       ),
//     );
//   }
//
//   // Helper to get the current number of recordings (for default title suggestion)
//   Future<int> get recordingsCount async {
//     final prefs = await SharedPreferences.getInstance();
//     final recordingsJson = prefs.getStringList('recordings') ?? [];
//     return recordingsJson.length;
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _record.dispose();
//     _titleController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final hour = _elapsed.inHours.toString().padLeft(2, '0');
//     final min = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
//     final sec = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Recording', style: TextStyle(color: Colors.white)),
//         backgroundColor: const Color(0xFF113C6D),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.blue.shade50,
//                     ),
//                     padding: const EdgeInsets.all(40),
//                     child: const Icon(Icons.mic, size: 60, color: Color(0xFF113C6D)),
//                   ),
//                   const SizedBox(height: 30),
//                   RichText(
//                     text: TextSpan(
//                       style: const TextStyle(
//                         fontSize: 40,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       children: [
//                         TextSpan(text: '$hour:', style: const TextStyle(color: Colors.grey)),
//                         TextSpan(text: '$min:', style: const TextStyle(color: Colors.grey)),
//                         TextSpan(
//                           text: sec,
//                           style: TextStyle(
//                             color: _isRecording ? const Color(0xFF113C6D) : Colors.grey,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildCircleButton(Icons.close, _isRecording ? Colors.red : Colors.grey, _cancelRecording),
//                 _buildRecordingControlButton(),
//                 _buildCircleButton(Icons.check, _isRecording ? Colors.green : Colors.grey, _confirmSave),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRecordingControlButton() {
//     return GestureDetector(
//       onTap: () async {
//         if (_isRecording) {
//           await _record.stop();
//           setState(() {
//             _isRecording = false;
//           });
//           _timer?.cancel();
//         } else {
//           _startRecording();
//         }
//       },
//       child: Container(
//         width: 70,
//         height: 70,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.black, width: 1),
//           shape: BoxShape.circle,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               color: Colors.red,
//               shape: _isRecording ? BoxShape.rectangle : BoxShape.circle,
//               borderRadius: _isRecording ? BorderRadius.circular(10) : null,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCircleButton(IconData icon, Color color, VoidCallback onTap, {bool isLarge = false}) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: isLarge ? 70 : 50,
//         height: isLarge ? 70 : 50,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: isLarge ? color : Colors.white,
//           border: isLarge ? Border.all(color: Colors.black, width: 1) : null,
//         ),
//         child: Icon(icon, color: isLarge ? Colors.white : color),
//       ),
//     );
//   }
// }


import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:recordings1/features/recordings/models/recording.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final _record = Record();
  bool _isRecording = false;
  String _filePath = '';
  Duration _elapsed = Duration.zero;
  Timer? _timer;
  Color? _selectedColor; // Initially null to disable submit button
  final TextEditingController _titleController = TextEditingController(); // Controller for the title input

  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _record.start(
        path: path,
        encoder: AudioEncoder.aacLc,
      );
      setState(() {
        _isRecording = true;
        _filePath = path;
        _elapsed = Duration.zero;
      });

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _elapsed += const Duration(seconds: 1);
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Microphone permission is denied.'),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
    }
  }

  Future<void> _stopRecording({bool save = false, String? title, Color? color}) async {
    _timer?.cancel();
    await _record.stop();

    if (save && _filePath.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final recordingsJson = prefs.getStringList('recordings') ?? [];
      final recording = Recording(
        title: title ?? 'Recording ${DateTime.now()}', // Use provided title or default
        path: _filePath,
        color: color ?? Colors.blue, // Use provided color or default
      );
      recordingsJson.add(jsonEncode(recording.toJson()));
      await prefs.setStringList('recordings', recordingsJson);
    }

    if (mounted) Navigator.pop(context);
  }

  void _cancelRecording() async {
    _timer?.cancel();
    await _record.stop();
    if (mounted) Navigator.pop(context);
  }

  void _confirmSave() {
    // Use FutureBuilder to handle the async recordingsCount
    showDialog(
      context: context,
      builder: (context) => FutureBuilder<int>(
        future: recordingsCount,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const AlertDialog(
              content: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError) {
            return AlertDialog(
              content: Text('Error: ${snapshot.error}'),
            );
          }

          // Set the default title once the count is available
          _selectedColor = null; // Initially null to disable the submit button
          _titleController.text = 'Recording ${snapshot.data! + 1}';

          return StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: const Text(
                "Save Recording",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Editable recording name field
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      hintText: 'Recording 1',
                      hintStyle: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Color selection label
                  const Text(
                    "Select Card Color",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  // Color selection row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildColorOption(const Color(0xFFFFE6E6), setDialogState), // Light Pink
                      _buildColorOption(const Color(0xFFE6E6FF), setDialogState), // Light Purple
                      _buildColorOption(const Color(0xFFFFE6F0), setDialogState), // Light Red
                      _buildColorOption(const Color(0xFFE6FFE6), setDialogState), // Light Green
                      _buildColorOption(const Color(0xFFE6F0FF), setDialogState), // Light Blue
                      _buildColorOption(const Color(0xFFFFF0E6), setDialogState), // Light Orange
                    ],
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _selectedColor == null
                        ? null // Disable the button if no color is selected
                        : () async {
                      Navigator.of(context).pop();
                      await _stopRecording(
                        save: true,
                        title: _titleController.text,
                        color: _selectedColor,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedColor == null
                          ? Colors.grey.shade300 // Disabled color
                          : const Color(0xFF113C6D), // Enabled color
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(
                        color: _selectedColor == null ? Colors.black87 : Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildColorOption(Color color, StateSetter setDialogState) {
    return GestureDetector(
      onTap: () {
        setDialogState(() {
          _selectedColor = color;
        });
        setState(() {
          _selectedColor = color;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          if (_selectedColor == color)
            const Icon(
              Icons.check,
              color: Colors.black54,
              size: 20,
            ),
        ],
      ),
    );
  }

  // Helper to get the current number of recordings (for default title suggestion)
  Future<int> get recordingsCount async {
    final prefs = await SharedPreferences.getInstance();
    final recordingsJson = prefs.getStringList('recordings') ?? [];
    return recordingsJson.length;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _record.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hour = _elapsed.inHours.toString().padLeft(2, '0');
    final min = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final sec = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recording', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF113C6D),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.shade50,
                    ),
                    padding: const EdgeInsets.all(40),
                    child: const Icon(Icons.mic, size: 60, color: Color(0xFF113C6D)),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(text: '$hour:', style: const TextStyle(color: Colors.grey)),
                        TextSpan(text: '$min:', style: const TextStyle(color: Colors.grey)),
                        TextSpan(
                          text: sec,
                          style: TextStyle(
                            color: _isRecording ? const Color(0xFF113C6D) : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircleButton(Icons.close, _isRecording ? Colors.red : Colors.red, _cancelRecording),
                _buildRecordingControlButton(),
                _buildCircleButton(Icons.check, _isRecording ? Colors.green : Colors.green, _confirmSave),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingControlButton() {
    return GestureDetector(
      onTap: () async {
        if (_isRecording) {
          await _record.stop();
          setState(() {
            _isRecording = false;
          });
          _timer?.cancel();
        } else {
          _startRecording();
        }
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedOpacity(
                opacity: _isRecording ? 0 : 1,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _isRecording ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, Color color, VoidCallback onTap, {bool isLarge = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isLarge ? 70 : 50,
        height: isLarge ? 70 : 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isLarge ? color : Colors.white,
          border: isLarge ? Border.all(color: Colors.black, width: 1) : null,
        ),
        child: Icon(icon, color: isLarge ? Colors.white : color),
      ),
    );
  }
}

