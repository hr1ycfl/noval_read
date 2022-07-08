import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:novel_read/global.dart';
import 'package:novel_read/home/home_view.dart';
import 'package:novel_read/theme.dart';

void main() {
  initApp();
}

void initApp() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Global.init();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    defaultTransition: Transition.fade,
    home: const HomePage(),
  ));

  FlutterNativeSplash.remove();
}
