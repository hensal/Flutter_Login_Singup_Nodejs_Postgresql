import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:takuwa_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localization/flutter_localization.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}
class _SettingsState extends State<Settings> {
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModeFromPreferences();
  }

  void _loadDarkModeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkMode = prefs.getBool("dark_mode") ?? false;
    });
  }

  void _saveDarkModeToPreferences(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("dark_mode", value);
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Theme(
        data: _darkMode ? ThemeData.dark() : ThemeData.light(),
        child: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('Common'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  value: const Text('English'),
                ),
                SettingsTile.switchTile(
                  onToggle: (value) {
                    setState(() {
                      _darkMode = value;
                      _saveDarkModeToPreferences(value);
                    });
                    themeNotifier.setDarkTheme(value);
                  },
                  initialValue: _darkMode,
                  leading: const Icon(Icons.dark_mode),
                  title: const Text('Theme'),
                ),
              ],
            ),
            SettingsSection(
              title: const Text('Others'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                ),
                SettingsTile.navigation(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}