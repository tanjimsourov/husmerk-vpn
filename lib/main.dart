import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:husmerk_vpn/appPreferences/appPreferences.dart';
import 'package:husmerk_vpn/screens/home_screen.dart';
import 'package:husmerk_vpn/screens/splash_screen.dart';

late Size sizeScreen;

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await appPreferences.initHive();
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Husmerk VPN',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true, elevation: 3
        ),
      ),
      themeMode: appPreferences.isModeDark ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          centerTitle: true, elevation: 3
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const  mySplashScreen(),
    );
  }
}

extension AppTheme on ThemeData{

  Color get lightTextColor => appPreferences.isModeDark ? Colors.white70 : Colors.black54;
  Color get bottomNavigationColor => appPreferences.isModeDark ? Colors.white12 : Colors.redAccent;

}