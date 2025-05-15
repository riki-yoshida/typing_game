import 'package:flutter/material.dart';
import 'package:typing_game/features/typing_game/presentation/pages/typing_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final List<String> _levels = ['小学生', '中学生', '高校生', '大学生', '社会人'];
  final List<String> _modes = ['練習モード', '本番モード'];
  String? _selectedLevel;
  String? _selectedMode;

  @override
  void initState() {
    super.initState();
    // 初期選択レベルを設定
    _selectedLevel = _levels[0];
    _selectedMode = _modes[0]; // 初期選択モードを設定
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(...) // Drawerプロパティは削除
      body: Row(
        // bodyをRowに変更してサイドバーとメインコンテンツを並べる
        children: [
          // サイドバー部分
          Container(
            // サイドバーの幅を固定するためのコンテナ
            width: 250, // サイドバーの幅
            color:
                Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest, // サイドバーの背景色 (deprecated_member_use)
            child: ListView(
              // このListViewの中に全てのサイドバー項目を入れる
              // Drawerの中身をListViewとして再利用
              padding: EdgeInsets.zero,
              children: [
                // DrawerHeaderの代わり
                Container(
                  height: 100, // ヘッダーの高さ
                  color: Theme.of(context).colorScheme.primary,
                  alignment: Alignment.centerLeft, // テキストの配置
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ), // パディング
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    // 将来的に設定画面への遷移などをここに書く
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  onTap: () {
                    // 将来的にAbout画面への遷移などをここに書く
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'レベル選択',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                ..._levels.map((level) {
                  return ListTile(
                    leading: Icon(
                      _selectedLevel == level
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          _selectedLevel == level
                              ? Theme.of(context).colorScheme.primary
                              : null,
                    ),
                    title: Text(level),
                    selected: _selectedLevel == level,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withAlpha((0.3 * 255).round()), // withOpacityを修正
                    onTap: () {
                      setState(() {
                        _selectedLevel = level;
                      });
                    },
                  );
                }), // Removed .toList() here
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'モード選択',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                ..._modes.map((mode) {
                  return ListTile(
                    leading: Icon(
                      _selectedMode == mode
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          _selectedMode == mode
                              ? Theme.of(context).colorScheme.primary
                              : null,
                    ),
                    title: Text(mode),
                    selected: _selectedMode == mode,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withAlpha((0.3 * 255).round()),
                    onTap: () {
                      setState(() {
                        _selectedMode = mode;
                      });
                    },
                  );
                }),
              ], // ListView children closing bracket
            ), // ListView closing bracket
          ), // サイドバーのContainerの閉じカッコ
          Expanded(
            // 残りの領域をメインコンテンツに割り当てる
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Welcome to Typing Game!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                if (_selectedLevel != null)
                  Text(
                    '選択中のレベル: $_selectedLevel',
                    style: const TextStyle(fontSize: 18),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 20,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    if (_selectedLevel == null) {
                      // レベルが選択されていない場合
                      // initStateで初期値が設定されるため、基本的にはここには来ないはずですが念のため
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('レベルを選択してください。')),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => TypingPage(
                              title:
                                  '$_selectedLevel $_selectedMode', // タイトルにレベルとモードを表示
                              // levelとmodeパラメータを渡す
                              mode: _selectedMode!,
                              level: _selectedLevel!,
                            ),
                      ),
                    );
                  },
                  child: const Text('Start Game'),
                ),
              ],
            ),
          ), // Expandedの閉じカッコ
        ], // Rowのchildrenリストの閉じカッコ
      ), // Rowの閉じカッコ
    );
  }
}

// TODO: TypingControllerも、受け取ったレベルとモードに応じて問題文の生成やゲームロジックを切り替える必要があります。
