import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'core/security/encryption_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/coach_ai_service.dart';
import 'features/splash/splash_screen.dart';

/// التطبيق: ميزان - Zero Knowledge + تشفير ثلاثي + كوتش أوفلاين
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await EncryptionService.init();

  final appDir = await getApplicationDocumentsDirectory();
  Hive.init(appDir.path);

  await Hive.openBox(
    'secure_vault',
    encryptionCipher: EncryptionService.getHiveCipher(),
  );

  await NotificationService.init();
  await CoachAIService.init();

  runApp(const MizanApp());
}

class MizanApp extends StatelessWidget {
  const MizanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ميزان',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Cairo',
      ),
      home: const SplashScreen(),
    );
  }
}
