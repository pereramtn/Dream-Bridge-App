import 'package:dream_bridge_app/Pages/wrapper.dart';
import 'package:dream_bridge_app/providers/theam_provider.dart';
import 'package:dream_bridge_app/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().initialize();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => TheamProvider())],
      child: const DreamBridge(),
    ),
  );
}

class DreamBridge extends StatelessWidget {
  const DreamBridge({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<TheamProvider>(context).getThemeData,
      home: const Wrapper(),
    );
  }
}
