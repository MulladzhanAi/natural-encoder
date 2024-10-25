import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natural_encoder/presentation/hill/hill_bloc.dart';
import 'package:natural_encoder/presentation/hill/hill_screen.dart';
import 'package:natural_encoder/presentation/main/main_bloc.dart';
import 'package:natural_encoder/presentation/main/main_screen.dart';
import 'package:natural_encoder/widgets/custom_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const StartScreen());
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_introText()}",
              style: _textStyle(),
            ),
            const SizedBox(
              height: 30,
            ),
            CustomButton(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                },
                title: 'Начать'),
            const SizedBox(height: 16,),
            CustomButton(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HillScreen()));
                },
                title: "Метод Хилла"),
          ],
        ),
      ),
    );
  }

  String _introText() {
    return "\tПрограмма для шифрования текста методом Цезаря,Двумя массивами и методом Тритемиуса\n"
        "\tМетод Цезаря принимает ключ - число\n"
        "\tМетод двумя массивами принимает ключ - русский алфавит(в рандомном порядке)\n"
        "\tМетод Тритемиуса принимает ключ - слово\n"
        "\tСтроятся графики частотного анализа и сама таблица частотного анализа";
  }

  TextStyle _textStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  }
}
