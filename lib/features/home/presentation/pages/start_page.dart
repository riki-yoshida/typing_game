import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typing_game/features/typing_game/presentation/pages/typing_page.dart';
import 'package:typing_game/features/typing_game/controllers/typing_controller.dart'; // コントローラーをインポート
import 'package:typing_game/features/word_list/presentation/pages/word_list_page.dart'; // WordListPageをインポート
import 'package:typing_game/features/home/presentation/widgets/title_with_buttons.dart';
import 'package:flutter/services.dart' show rootBundle; // JSONファイル読み込みに必要
import 'dart:convert'; // JSONデコードに必要

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0), // 右側に8ピクセルのパディングを追加
            child: IconButton(
              iconSize: 30.0, // アイコンのサイズを30に設定
              icon: const Icon(Icons.login), // ログインアイコン
              tooltip: 'ログイン', // アイコンにマウスオーバーした際に表示されるテキスト
              onPressed: () {
                // TODO: ログイン処理またはログイン画面への遷移を実装
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('ログインボタンが押されました')));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // コンテンツ全体をスクロール可能にする
        child: Center(
          child: Padding(
            // 上下に少しパディングを追加して見栄えを調整
            padding: const EdgeInsets.symmetric(vertical: 64.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Columnの子を垂直方向の中央に配置
              children: [
                Text(
                  'タイピング',
                  style: TextStyle(fontFamily: 'OunenMouhitsu', fontSize: 96),
                ),
                Text(
                  '英語塾',
                  style: TextStyle(fontFamily: 'OunenMouhitsu', fontSize: 96),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TitleWithButtons(
                        title: "Lesson",
                        buttonActions: [
                          ButtonAction(
                            text: "小学生",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChangeNotifierProvider(
                                        create: (_) => TypingController(),
                                        child: TypingPage(
                                          level: 'shougakusei',
                                          mode: 'lesson',
                                          wordCount: 100,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                          ButtonAction(
                            text: "中学生",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChangeNotifierProvider(
                                        create: (_) => TypingController(),
                                        child: TypingPage(
                                          level: 'chuugakusei',
                                          mode: 'lesson',
                                          wordCount: 100,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                          ButtonAction(
                            text: "高校生",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChangeNotifierProvider(
                                        create: (_) => TypingController(),
                                        child: TypingPage(
                                          level: 'koukousei',
                                          mode: 'lesson',
                                          wordCount: 100,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                          ButtonAction(
                            text: "大学生",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChangeNotifierProvider(
                                        create: (_) => TypingController(),
                                        child: TypingPage(
                                          level: 'daigakusei',
                                          mode: 'lesson',
                                          wordCount: 100,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TitleWithButtons(
                        title: "Time Attack",
                        buttonActions: [
                          ButtonAction(
                            text: "小学生",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChangeNotifierProvider(
                                        create: (_) => TypingController(),
                                        child: TypingPage(
                                          level: 'shougakusei',
                                          mode: 'attack',
                                          wordCount: 100,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                          ButtonAction(
                            text: "中学生",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChangeNotifierProvider(
                                        create: (_) => TypingController(),
                                        child: TypingPage(
                                          level: 'chuugakusei',
                                          mode: 'attack',
                                          wordCount: 100,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                          ButtonAction(
                            text: "高校生",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChangeNotifierProvider(
                                        create: (_) => TypingController(),
                                        child: TypingPage(
                                          level: 'koukousei',
                                          mode: 'attack',
                                          wordCount: 100,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                          ButtonAction(
                            text: "大学生",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => ChangeNotifierProvider(
                                        create: (_) => TypingController(),
                                        child: TypingPage(
                                          level: 'daigakusei',
                                          mode: 'attack',
                                          wordCount: 100,
                                        ),
                                      ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TitleWithButtons(
                        title: "Time Limit",
                        buttonActions: [
                          ButtonAction(text: "小学生", onPressed: () {}),
                          ButtonAction(text: "中学生", onPressed: () {}),
                          ButtonAction(text: "高校生", onPressed: () {}),
                          ButtonAction(text: "大学生", onPressed: () {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
