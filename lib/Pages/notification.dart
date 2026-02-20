import 'package:dream_bridge_app/constants/colors.dart';
import 'package:dream_bridge_app/wigets/custom_appbar.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool pushNotifications = true;
  bool emailAlerts = false;
  bool soundEffects = true;

  final List<Map<String, String>> notifications = [
    {"title": "New Message", "body": "You received a new message from Admin."},
    {"title": "Reminder", "body": "Your next session starts tomorrow at 9 AM."},
    {"title": "Update", "body": "Version 1.2.0 is now available!"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbar_title: "NOTIFICATIONS"),

      body: Column(
        children: [
          // Notifications List
          Expanded(
            child: notifications.isEmpty
                ? const Center(
                    child: Text(
                      "No notifications yet.",
                      style: TextStyle(color:kMainTeal2),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        shadowColor: const Color(0xFF250A30),
                        child: ListTile(
                          leading: const Icon(
                            Icons.notifications,
                            color: kMainTeal2,
                          ),
                          title: Text(
                            notifications[index]["title"]!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kMainGTeal1,
                            ),
                          ),
                          subtitle: Text(
                            notifications[index]["body"]!,
                            style: const TextStyle(color:kletdarkgray),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Notification Settings Panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F7FC),
              border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Notification Settings",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: kMainTeal2,
                  ),
                ),
                const SizedBox(height: 8),
                _buildSwitchTile(
                  title: "Push Notifications",
                  value: pushNotifications,
                  onChanged: (val) {
                    setState(() => pushNotifications = val);
                  },
                ),
                _buildSwitchTile(
                  title: "Email Alerts",
                  value: emailAlerts,
                  onChanged: (val) {
                    setState(() => emailAlerts = val);
                  },
                ),
                _buildSwitchTile(
                  title: "Sound Effects",
                  value: soundEffects,
                  onChanged: (val) {
                    setState(() => soundEffects = val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, ),
      value: value,
      activeThumbColor: kMainGTeal1,
      onChanged: onChanged,
    );
  }
}
