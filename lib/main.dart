import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/card_list.dart';
import 'package:tradie_id/home/ui/home_page.dart';
import 'package:tradie_id/login/bloc/login_bloc.dart';
import 'package:tradie_id/login/ui/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_secure_screen/flutter  _secure_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:upgrader/upgrader.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';

PackageInfo? packageInfo;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  packageInfo = await PackageInfo.fromPlatform();
  // Hive.registerAdapter(RListAdapter());
  box = await Hive.openBox('tradieId2');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await FlutterSecureScreen.singleton.setAndroidScreenSecure(true);
  await ScreenProtector.preventScreenshotOn();
  await ScreenProtector.protectDataLeakageOn();
  ScreenCaptureBlocker.blockScreenCapture();
  runApp(const MyApp());
}

class ScreenCaptureBlocker {
  static const platform = MethodChannel('com.example.screenshot/block');

  static blockScreenCapture() async {
    if (Platform.isIOS) {
      try {
        await platform.invokeMethod('blockScreenCapture');
      } on PlatformException catch (e) {
        print('Error blocking screen capture: ${e.message}');
      }
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Staff Id',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
     builder: EasyLoading.init(),
      home: UpgradeAlert(
        upgrader: Upgrader(
          // debugDisplayAlways: true,
          showIgnore: false,
          showLater: false,
        ),
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(),
            )
          ],
          child: box!.containsKey("phone") ? const HomePage() : LoginPage(),
        ),
      ),
    );
  }
}
