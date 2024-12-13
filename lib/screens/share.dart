import 'package:flutter/material.dart';
import 'dart:async';
import '../data/http_helper.dart';
import '../screens/movieselect.dart';
import 'package:device_info/device_info.dart';

class ShareCodePage extends StatefulWidget {
  const ShareCodePage({super.key});

  @override
  _ShareCodeState createState() => _ShareCodeState();
}

class _ShareCodeState extends State<ShareCodePage> {
  late Future<Map<String, dynamic>>? codeBody;
  String _deviceId = '';

  @override
  void initState() {
    super.initState();
    _initializeDeviceId();
    setState(() {
      codeBody = HttpHelper().startSession(_deviceId);
    });
  }

  Future<void> _initializeDeviceId() async {
    try {
      final deviceInfoPlugin = DeviceInfoPlugin();
      if (Theme.of(context).platform == TargetPlatform.android) {
        final androidInfo = await deviceInfoPlugin.androidInfo;
        _deviceId = androidInfo.id ?? '';
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfoPlugin.iosInfo;
        _deviceId = iosInfo.identifierForVendor ?? '';
      } else {
        _deviceId = 'Unknown Device';
      }
    } catch (e) {
      setState(() {
        _deviceId = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Share Code"),
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: codeBody,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No code available.'));
            } else {
              final String code = snapshot.data!['code'] ?? 'Unknown Code';
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      code,
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 70),
                    const Text(
                      "Share Your Code With A Friend",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 70),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor:
                              const Color.fromRGBO(11, 202, 231, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 27.0, vertical: 10.0)),
                      onPressed: () {
                        final String sessionId =
                            snapshot.data!['session_id'] ?? 'Unknown Code';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieSelectPage(session: sessionId),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Find A Movie',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          SizedBox(width: 20),
                          Icon(Icons.movie, size: 40),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
