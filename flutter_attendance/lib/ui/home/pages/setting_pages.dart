import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Setting',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 20),
          _buildSectionHeader('Account'),
          _buildListTile('Edit Profile'),
          _buildListTile('Password'),
          _buildListTile('Language'),
          const SizedBox(height: 30),
          _buildSectionHeader('Preferences'),
          _buildListTile('Theme'),
          _buildListTile('Notifications'),
          _buildListTile('Attendance'),
          const SizedBox(height: 30),
          _buildSectionHeader('Support'),
          _buildListTile('Terms of Service & Privacy'),
          _buildListTile('Clear Cache'),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildListTile(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          onTap: () {
            // Handle navigation or other actions here
          },
        ),
        const Divider(height: 1, color: Colors.grey),
      ],
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: SettingsPage(),
  ));
}
