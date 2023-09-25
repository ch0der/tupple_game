import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tupple_game/gameBloc.dart';
import 'library.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      title: 'wordygame', // PulseSphere, SnapZeitgeist
      home: BlocProvider(
        create: (context) => GameBloc(),
        child: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    TestWordGame(),
  ];

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],

    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Page'));
  }
}

