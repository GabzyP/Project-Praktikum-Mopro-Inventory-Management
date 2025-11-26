import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> notifications = [];

    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: notifications.isEmpty
          ? const Center(child: Text("Belum ada notifikasi baru"))
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(notifications[index]));
              },
            ),
    );
  }
}
