import 'package:flutter/material.dart';
import 'package:flutter_finalapp/screens/entercode.dart';
import 'package:flutter_finalapp/screens/share.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 25, 152, 255)),
          useMaterial3: true,
          textTheme: const TextTheme(
              labelLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
            color: Color.fromARGB(255, 255, 255, 255),
          ))),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Movie Night App",
            style: Theme.of(context).textTheme.labelLarge,
          ),
          backgroundColor: Color.fromRGBO(0, 189, 189, 1),
        ),
        body: SafeArea(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: const Color.fromRGBO(11, 202, 231, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.only(
                      left: 47.0,
                      right: 47.0,
                      top: 15.0,
                      bottom: 15.0,
                    )),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShareCodePage(),
                    ),
                  );
                  print('Finding Movie Boss!');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Get Code',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.mail_rounded, size: 40),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 5,
                    backgroundColor: const Color.fromRGBO(11, 202, 231, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    padding: const EdgeInsets.only(
                      left: 37.0,
                      right: 37.0,
                      top: 15.0,
                      bottom: 15.0,
                    )),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EnterCodePage(), // Replace with your target widget
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter Code',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: 20),
                    const Icon(Icons.password, size: 40),
                  ],
                ),
              )
            ]))));
  }
}
