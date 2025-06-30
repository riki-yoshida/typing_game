import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // GoRouterをインポート
// WordListPageをインポート
import 'package:typing_game/features/home/presentation/widgets/title_with_buttons.dart';
import 'package:flutter_tts/flutter_tts.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

const double kMobileBreakpoint = 600.0; // スマートフォンレイアウトのブレークポイント

class _StartPageState extends State<StartPage> {
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initTts();
    });
  }

  // TTSの初期設定
  // TTSを使うのはtyping_pageだが、事前に初期化しないと設定が反映されないことがあるため、ここで設定する
  Future<void> _initTts() async {
    // 英語（アメリカ）に設定
    await _flutterTts.setLanguage("en-US");
    // 読み上げ速度を少し遅めに設定 (0.0 ~ 1.0)
    await _flutterTts.setSpeechRate(1.0);
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
      //           // context.go('/login'); // 例: /login ルートに遷移
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
                            context.go('/typing/lesson/shougakusei');
                          },
                        ),
                        ButtonAction(
                          text: "中学生",
                          onPressed: () {
                            context.go('/typing/lesson/chuugakusei');
                          },
                        ),
                        ButtonAction(
                          text: "高校生",
                          onPressed: () {
                            context.go('/typing/lesson/koukousei');
                          },
                        ),
                        ButtonAction(
                          text: "大学生",
                          onPressed: () {
                            context.go('/typing/lesson/daigakusei');
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
                            context.go('/typing/attack/shougakusei');
                          },
                        ),
                        ButtonAction(
                          text: "中学生",
                          onPressed: () {
                            context.go('/typing/attack/chuugakusei');
                          },
                        ),
                        ButtonAction(
                          text: "高校生",
                          onPressed: () {
                            context.go('/typing/attack/koukousei');
                          },
                        ),
                        ButtonAction(
                          text: "大学生",
                          onPressed: () {
                            context.go('/typing/attack/daigakusei');
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
                            context.go('/typing/limit/shougakusei');
                          },
                        ),
                        ButtonAction(
                          text: "中学生",
                          onPressed: () {
                            context.go('/typing/limit/chuugakusei');
                          },
                        ),
                        ButtonAction(
                          text: "高校生",
                          onPressed: () {
                            context.go('/typing/limit/koukousei');
                          },
                        ),
                        ButtonAction(
                          text: "大学生",
                          onPressed: () {
                            context.go('/typing/limit/daigakusei');
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
