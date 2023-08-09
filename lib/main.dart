import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradie_id/config/config.dart';
import 'package:tradie_id/home/ui/card_list.dart';
import 'package:tradie_id/home/ui/home_page.dart';
import 'package:tradie_id/login/bloc/login_bloc.dart';
import 'package:tradie_id/login/ui/login_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  box = await Hive.openBox('tradieId');
  Hive.registerAdapter(RListAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tradie Id',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: false,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(),
          )
        ],
        child: box!.containsKey("name") ? const HomePage() : LoginPage(),
      ),
    );
  }
}
