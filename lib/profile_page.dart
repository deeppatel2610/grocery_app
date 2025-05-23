import 'package:flutter/material.dart';
import 'package:grocery_app/home_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(
                'assets/profile.jpg',
              ), // Replace with NetworkImage if needed
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              'Deep Patel',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            // Email
            Text(
              'deeppatel@example.com',
              style: TextStyle(color: Colors.grey[600]),
            ),

            const SizedBox(height: 30),

            // Info Tiles
            ListTile(
              leading: Icon(Icons.edit, color: Colors.teal),
              title: Text('Edit Profile'),
              onTap: () {},
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.settings, color: Colors.teal),
              title: Text('Settings'),
              onTap: () {},
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.language, color: Colors.teal),
              title: Text('Change Language'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Select Language'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('English'),
                            onTap: () {
                              context.read<HomeProvider>().changeLanguage(
                                "english",
                              );
                              Navigator.of(context).pop();
                              // TODO: Set language to English
                            },
                          ),
                          ListTile(
                            title: Text('Hindi (हिंदी)'),
                            onTap: () {
                              context.read<HomeProvider>().changeLanguage(
                                "hindi",
                              );
                              Navigator.of(context).pop();
                              // TODO: Set language to Hindi
                            },
                          ),
                          ListTile(
                            title: Text('Gujarati (ગુજરાતી)'),
                            onTap: () {
                              context.read<HomeProvider>().changeLanguage(
                                "gujarati",
                              );
                              Navigator.of(context).pop();
                              // TODO: Set language to Gujarati
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.notifications, color: Colors.teal),
              title: Text('Notifications'),
              onTap: () {},
            ),
            Divider(),

            ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
