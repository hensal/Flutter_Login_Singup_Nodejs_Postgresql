import 'package:flutter/material.dart';
import 'package:takuwa_project/Widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takuwa_project/authentication_screen/login_screen.dart';
import 'package:takuwa_project/authentication_screen/register_screen.dart';
import 'package:takuwa_project/screens/home_screen.dart';
import 'package:takuwa_project/screens/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool darkTheme = prefs.getBool('theme') ?? false;
  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(darkTheme),
      child: const MyApp(),
    ),
  );
}

class ThemeNotifier with ChangeNotifier {
  final String key = "theme";
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier(this._darkTheme);

  setDarkTheme(bool value) async {
    _darkTheme = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  ThemeData getTheme() {
    if (_darkTheme == true) {
      return ThemeData.dark();
    }
    return ThemeData.light();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeNotifier.getTheme(),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Takuwa Project'),
        backgroundColor: Colors.grey,
        actions: [        
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/takuwa.png'),
            const SizedBox(height: 15),
            const Text(
              'Welcome!, Are you ready to join us?',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 18, right: 18),
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            const Text('Already have an account?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100)),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text('Don`t have an account?',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w100,
                  color: Colors.black,
                )),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
              ),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'TAKUWA CORPORATION',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '1-4-15 Uchikanda, Chiyoda-ku, Tokyo 101-0047, JAPAN\n'
              '       TEL: +81-3-3291-5380 / FAX: +81-3-3291-5226\n'
              '                      E-mail: e-info@takuwa.co.jp\n'
              'Copyright © TAKUWA CORPORATION. All Rights Reserved.',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
