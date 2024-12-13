import 'package:flutter/material.dart';
import 'package:device_info/device_info.dart';
import 'movieselect.dart';
import '../data/http_helper.dart';

class EnterCodePage extends StatefulWidget {
  const EnterCodePage({super.key});

  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCodePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _code = 0;
  late String _deviceId = '';

  @override
  void initState() {
    super.initState();
    _initializeDeviceId();
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

  Future<void> joiningSession(_code) async {
    try {
      final response = await HttpHelper().joinSession(_deviceId, _code);
      print('$response');
      if (response.containsKey('data')) {
        final sessionId = response['data']['session_id'];
        if (sessionId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieSelectPage(session: sessionId),
            ),
          );
        } else {
          throw Exception('Session ID not found in response');
        }
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('$e');
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join session: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Code"),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Enter Your 4-Digit Code",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: 'Enter Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      maxLength: 4,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a code.';
                        }
                        if (value.length != 4) {
                          return 'Code must be 4 digits.';
                        }
                        return null;
                      },
                      onSaved: (String? value) {
                        _code = int.parse(value!);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        print('Code submitted: $_code');
                        joiningSession(_code);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: const Color.fromRGBO(11, 202, 231, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 27.0,
                        vertical: 10.0,
                      ),
                    ),
                    child: Text(
                      'Submit Code',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
