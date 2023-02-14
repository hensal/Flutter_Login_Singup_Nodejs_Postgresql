import 'package:flutter/material.dart';
import 'package:takuwa_project/screens/settings.dart';
import 'package:takuwa_project/main.dart';
import 'package:takuwa_project/screens/about_us.dart';
//import 'package:takuwa_project/screens/product.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(),
            accountEmail: Text('e-info@takuwa.co.jp'),
            accountName: Text('TAKUWA CORPORATION'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text("About Us"),
            onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUs(),
                    ),
                  );
                },
          ),
          ListTile(
            leading: const Icon(Icons.grid_3x3_outlined),
            title: const Text("Products"),
            onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(),
                    ),
                  );
                },
          ),
          ListTile(
            leading: const Icon(Icons.contact_mail),
            title: const Text("Contact"),
            onTap: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
          ),
        ],
      ),
    );
  }
}
