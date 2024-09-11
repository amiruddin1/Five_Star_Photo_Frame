import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import './Screens/SplashScreen.dart';
import './models/theme_provider.dart';

void main() {
  // Initialize the database factory for desktop platforms
  if (isDesktop()) {
    sqfliteFfiInit(); // Initialize FFI
    databaseFactory = databaseFactoryFfi; // Set the database factory to FFI
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

// Helper function to check if the platform is desktop
bool isDesktop() {
  return [
    TargetPlatform.windows,
    TargetPlatform.macOS,
    TargetPlatform.linux
  ].contains(defaultTargetPlatform);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) {
        return MaterialApp(
          home: SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
