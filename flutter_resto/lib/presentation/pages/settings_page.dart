import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/providers/settings_provider.dart';
import '../../core/services/notification_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return ListTile(
                title: const Text('Theme'),
                subtitle: Text(
                  themeProvider.themeMode == ThemeMode.system
                      ? 'System'
                      : themeProvider.themeMode == ThemeMode.light
                      ? 'Light'
                      : 'Dark',
                ),
                trailing: DropdownButton<ThemeMode>(
                  value: themeProvider.themeMode,
                  onChanged: (ThemeMode? newMode) {
                    if (newMode != null) {
                      themeProvider.setThemeMode(newMode);
                    }
                  },
                  items: const [
                    DropdownMenuItem(
                      value: ThemeMode.system,
                      child: Text('System'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.light,
                      child: Text('Light'),
                    ),
                    DropdownMenuItem(
                      value: ThemeMode.dark,
                      child: Text('Dark'),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          Consumer<SettingsProvider>(
            builder: (context, settingsProvider, child) {
              return SwitchListTile(
                title: const Text('Daily Reminder'),
                subtitle: const Text(
                  'Get notified at 11:00 AM daily to find a restaurant for lunch',
                ),
                value: settingsProvider.isDailyReminderActive,
                onChanged: (bool value) async {
                  if (value) {
                    await NotificationService().scheduleDailyReminder();
                  } else {
                    await NotificationService().cancelDailyReminder();
                  }
                  settingsProvider.setDailyReminder(value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
