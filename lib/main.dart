import 'package:antenna_auction_2021/src/view/home.view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Center(
              child: Text("Firebase Error :("),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Jua',
              primarySwatch: const MaterialColor(
                0xFFFFFFFF,
                const <int, Color>{
                  50: const Color(0xFFFFFFFF),
                  100: const Color(0xFFFFFFFF),
                  200: const Color(0xFFFFFFFF),
                  300: const Color(0xFFFFFFFF),
                  400: const Color(0xFFFFFFFF),
                  500: const Color(0xFFFFFFFF),
                  600: const Color(0xFFFFFFFF),
                  700: const Color(0xFFFFFFFF),
                  800: const Color(0xFFFFFFFF),
                  900: const Color(0xFFFFFFFF),
                },
              ),
            ),
            home: HomeView(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        // return Loading();
        return const MaterialApp(
          home: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
