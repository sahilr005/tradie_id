import 'dart:io';

// import 'package:flutter_secure_screen/flutter_secure_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/home_page.dart';
import 'package:tradie_id/login/bloc/login_bloc.dart';
import 'package:tradie_id/login/ui/login_page.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import 'firebase_options.dart';

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
    final mediaQuery = MediaQuery.of(context);
    final textScaleFactor = mediaQuery.textScaleFactor;
    return GetMaterialApp(
      title: 'Tradie Id',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: false,
        // textTheme: Theme.of(context).textTheme.apply(
        //       // fontSizeFactor: textScaleFactor > 1 ? .8 : 2.0,
        //     ),
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: mediaQuery.size.width.isLowerThan(350)
                  ? const TextScaler.linear(.80)
                  : null,
            ),
            child: child!,
          );
        },
      ),
      home: UpgradeAlert(
        upgrader: Upgrader(
          upgraderOS: MockUpgraderOS(
            android: true,
            ios: true,
          ),
          upgraderDevice: MockUpgraderDevice(),
        ),
        showIgnore: false,
        showLater: false,
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

Future<void> showUpgradeDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: const Text('New Version Available'),
        content: const Text(
            'A new version of the app is available. Please update to continue using the app.'),
        actions: <Widget>[
          // TextButton(
          //   child: const Text('Ignore'),
          //   onPressed: () async{
          // Get.back();
          //   },
          // ),
          TextButton(
            child: const Text('Update'),
            onPressed: () async {
              var url = Platform.isAndroid
                  ? "https://play.google.com/store/apps/details?id=com.tradie.Id"
                  : 'https://apps.apple.com/app/6451134964';
              try {
                await launchUrl(Uri.parse(url),
                    mode: LaunchMode.externalApplication);
              } catch (e) {}
            },
          ),
        ],
      );
    },
  );
}
