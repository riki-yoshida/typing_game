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

const double kMobileBreakpoint = 600.0; // スマートフォンレイアウトのブレークポイント

class _StartPageState extends State<StartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.only(right: 8.0), // 右側に8ピクセルのパディングを追加
      //       child: IconButton(
      //         iconSize: 30.0, // アイコンのサイズを30に設定
      //         icon: const Icon(Icons.login), // ログインアイコン
      //         tooltip: 'ログイン', // アイコンにマウスオーバーした際に表示されるテキスト
      //         onPressed: () {
      //           // TODO: ログイン処理またはログイン画面への遷移を実装
      //           ScaffoldMessenger.of(
      //             context,
      //           ).showSnackBar(const SnackBar(content: Text('ログインボタンが押されました')));
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        // コンテンツ全体をスクロール可能にする
        child: Center(
          child: Padding(
            // 上下に少しパディングを追加して見栄えを調整
            padding: const EdgeInsets.symmetric(vertical: 64.0),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Columnの子を垂直方向の中央に配置
              children: <Widget>[
                LayoutBuilder(
                  builder: (context, constraints) {
                    // 画面幅に応じてフォントサイズを調整
                    // 例えば、画面幅の10分の1を基本サイズとし、最小30、最大96とする
                    double titleFontSize = (constraints.maxWidth / 10).clamp(
                      30.0,
                      96.0,
                    );
                    return Column(
                      children: [
                        Text(
                          'タイピング',
                          style: TextStyle(
                            fontFamily: 'OunenMouhitsu',
                            fontSize: titleFontSize,
                          ),
                        ),
                        Text(
                          '英語塾',
                          style: TextStyle(
                            fontFamily: 'OunenMouhitsu',
                            fontSize: titleFontSize,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 48),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isMobile = constraints.maxWidth < kMobileBreakpoint;
                    final lessonSection = TitleWithButtons(
                      title: "Lesson",
                      screenWidth: constraints.maxWidth, // 画面幅を渡す
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
                    );

                    final timeAttackSection = TitleWithButtons(
                      title: "Time Attack",
                      screenWidth: constraints.maxWidth, // 画面幅を渡す
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
                    );

                    final timeLimitSection = TitleWithButtons(
                      title: "Time Limit",
                      screenWidth: constraints.maxWidth, // 画面幅を渡す
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
                                        mode: 'limit', // モードをlimitに
                                        wordCount: 999, // 時間制限なのでワード数は大きな値
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
                                        mode: 'limit',
                                        wordCount: 999,
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
                                        mode: 'limit',
                                        wordCount: 999,
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
                                        mode: 'limit',
                                        wordCount: 999,
                                      ),
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                    );

                    if (isMobile) {
                      // スマートフォン向けの縦並びレイアウト
                      return Column(
                        children: [
                          lessonSection,
                          const SizedBox(height: 24),
                          timeAttackSection,
                          const SizedBox(height: 24),
                          timeLimitSection,
                        ],
                      );
                    } else {
                      // タブレットやデスクトップ向けの横並びレイアウト
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: lessonSection),
                          Expanded(child: timeAttackSection),
                          Expanded(child: timeLimitSection),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
