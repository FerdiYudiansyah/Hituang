import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hituang/app/modules/login/bindings/login_binding.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      theme: ThemeData(
        primaryColorLight: Colors.blue,
      ),
      initialBinding: LoginBinding(),
      getPages: AppPages.routes,
    ),
  );
}
