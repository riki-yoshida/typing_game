import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typing_game/features/typing_game/controllers/typing_controller.dart';
import 'package:typing_game/features/home/presentation/pages/start_page.dart'; // 新しく作成したStartPageをインポート

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TypingController(),
      child: MaterialApp(
        title: 'Typing Game',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
          ), // テーマカラーを変更
          useMaterial3: true,
          fontFamily: 'NotoSansJP',
        ),
        home: const StartPage(), // MaterialAppのhomeをStartPageに変更
      ),
    );
  }
}
