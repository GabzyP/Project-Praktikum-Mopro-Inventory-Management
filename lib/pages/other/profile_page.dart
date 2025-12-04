import 'package:flutter/material.dart';
import '../../utils/theme_config.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const String userName = "Gabzy";
    const String userEmail = "gabrielstudyacc@gmail.com";

    bool isDarkMode = themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              userName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(userEmail, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 40),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(isDarkMode ? "Mode Gelap" : "Mode Terang"),
                    secondary: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: isDarkMode ? Colors.white : Colors.orange,
                    ),
                    value: isDarkMode,
                    onChanged: (bool value) {
                      themeNotifier.value = value
                          ? ThemeMode.dark
                          : ThemeMode.light;
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text("Bahasa"),
                    trailing: const Text(
                      "Indonesia",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Keluar",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
