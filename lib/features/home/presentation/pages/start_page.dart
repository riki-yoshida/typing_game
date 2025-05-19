import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typing_game/features/typing_game/presentation/pages/typing_page.dart';
import 'package:typing_game/features/typing_game/controllers/typing_controller.dart'; // コントローラーをインポート
import 'package:typing_game/features/word_list/presentation/pages/word_list_page.dart'; // WordListPageをインポート
import 'package:flutter/services.dart' show rootBundle; // JSONファイル読み込みに必要
import 'dart:convert'; // JSONデコードに必要

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  // レベルの選択肢 (IDと表示名)
  final List<Map<String, String>> _levelOptions = [
    {'id': 'shougakusei', 'name': '小学生'},
    {'id': 'chuugakusei', 'name': '中学生'},
    {'id': 'koukousei', 'name': '高校生'},
    {'id': 'daigakusei', 'name': '大学生'},
    {'id': 'shakaijin', 'name': '社会人'},
  ];

  // モードの選択肢 (IDと表示名)
  final List<Map<String, String>> _modeOptions = [
    {'id': 'practice', 'name': '練習モード'},
    {'id': 'real', 'name': '本番モード'},
  ];

  String? _selectedLevelId;
  String? _selectedModeId;
  int _selectedWordCount = 10; // 初期ワード数を10に設定

  // ワード数の選択肢
  final List<int> _wordCountOptions = [10, 50, 100];

  // TODO: TypingControllerも、受け取ったレベルとモード、ワード数に応じて問題文の生成やゲームロジックを切り替える必要があります。

  @override
  void initState() {
    super.initState();
    // 初期選択レベルを設定
    if (_levelOptions.isNotEmpty) {
      _selectedLevelId = _levelOptions[0]['id'];
    }
    if (_modeOptions.isNotEmpty) {
      _selectedModeId = _modeOptions[0]['id'];
    }
  }

  // 選択されたレベルの単語リストを非同期で読み込む関数
  Future<List<Map<String, String>>> _loadWordListForLevel(
    String levelId,
  ) async {
    // TypingControllerのlevelToFileMapと同様のマッピングを使用
    final Map<String, String> levelToFileMap = {
      'shougakusei': 'shougakusei.json',
      'chuugakusei': 'chuugakusei.json',
      'koukousei': 'koukousei.json',
      'daigakusei': 'daigakusei.json',
      'shakaijin': 'shakaijin.json',
    };

    final fileName = levelToFileMap[levelId];
    if (fileName == null) {
      print("Error: No file mapping found for level ID $levelId");
      return []; // ファイル名が見つからない場合は空のリストを返す
    }

    try {
      final String jsonString = await rootBundle.loadString(
        'assets/word_lists/$fileName',
      );
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) => Map<String, String>.from(item)).toList();
    } catch (e) {
      print("Error loading word list for $levelId: $e");
      return []; // エラー時も空のリストを返す
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // サイドバー部分
          Container(
            width: 250, // サイドバーの幅
            color:
                Theme.of(
                  context,
                ).colorScheme.surfaceContainerHighest, // サイドバーの背景色
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // DrawerHeaderの代わり (AppBarの下に配置されるため不要になる)
                // Container( ... ),
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
                ..._levelOptions.map((option) {
                  final levelId = option['id']!;
                  final levelName = option['name']!;
                  return ListTile(
                    leading: Icon(
                      _selectedLevelId == levelId
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          _selectedLevelId == levelId
                              ? Theme.of(context).colorScheme.primary
                              : null,
                    ),
                    title: Text(levelName),
                    selected: _selectedLevelId == levelId,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withAlpha((0.3 * 255).round()), // withOpacityを修正
                    onTap: () {
                      setState(() {
                        _selectedLevelId = levelId;
                      });
                    },
                  );
                }),
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
                ..._modeOptions.map((option) {
                  final modeId = option['id']!;
                  final modeName = option['name']!;
                  return ListTile(
                    leading: Icon(
                      _selectedModeId == modeId
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          _selectedModeId == modeId
                              ? Theme.of(context).colorScheme.primary
                              : null,
                    ),
                    title: Text(modeName),
                    selected: _selectedModeId == modeId,
                    selectedTileColor: Theme.of(context)
                        .colorScheme
                        .primaryContainer
                        .withAlpha((0.3 * 255).round()),
                    onTap: () {
                      setState(() {
                        _selectedModeId = modeId;
                        if (_selectedModeId == 'real') {
                          _selectedWordCount = 100;
                        }
                      });
                    },
                  );
                }),
              ],
            ),
          ), // サイドバーのContainerの閉じカッコ
          Expanded(
            // 残りの領域をメインコンテンツに割り当てる
            child: Column(
              children: [
                // メインコンテンツエリア専用のAppBar
                AppBar(
                  backgroundColor:
                      Theme.of(context).colorScheme.surface, // 背景色を調整
                  elevation: 1.0, // 影を少し薄く
                  automaticallyImplyLeading:
                      false, // ScaffoldのAppBarではないので戻るボタンは表示しない
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.list_alt),
                        label: const Text('ワード一覧'),
                        onPressed: () async {
                          if (_selectedLevelId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('まずレベルを選択してください。')),
                            );
                            return;
                          }
                          final selectedLevelName =
                              _levelOptions.firstWhere(
                                (opt) => opt['id'] == _selectedLevelId,
                              )['name']!;
                          // 選択されたレベルの単語リストを読み込む
                          final List<Map<String, String>> words =
                              await _loadWordListForLevel(_selectedLevelId!);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => WordListPage(
                                    levelName: selectedLevelName,
                                    wordList: words,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // メインコンテンツの本体
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Welcome to Typing Game!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_selectedLevelId != null)
                        Text(
                          '選択中のレベル: ${_levelOptions.firstWhere((opt) => opt['id'] == _selectedLevelId, orElse: () => {'name': '未選択'})['name']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      const SizedBox(height: 10), // モード表示との間隔調整
                      if (_selectedModeId != null)
                        Text(
                          '選択中のモード: ${_modeOptions.firstWhere((opt) => opt['id'] == _selectedModeId, orElse: () => {'name': '未選択'})['name']}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      const SizedBox(height: 20),
                      // ワード数選択
                      Container(
                        alignment: Alignment.center, // 子ウィジェットを中央に配置
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40.0,
                        ), // 左右に少し余白
                        child: IntrinsicWidth(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // Column内の要素は左寄せのまま
                            children: [
                              Text(
                                'タイピングするワード数',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ..._wordCountOptions.map((count) {
                                final bool isRealMode =
                                    _selectedModeId ==
                                    'real'; // レベルIDではなくモードIDで判定
                                return ListTile(
                                  title: Text('$count ワード'),
                                  leading: Radio<int>(
                                    value: count,
                                    groupValue: _selectedWordCount,
                                    onChanged:
                                        isRealMode
                                            ? null
                                            : (int? value) {
                                              setState(
                                                () =>
                                                    _selectedWordCount = value!,
                                              );
                                            },
                                  ),
                                  onTap:
                                      isRealMode
                                          ? null
                                          : () => setState(
                                            () => _selectedWordCount = count,
                                          ),
                                );
                              }).toList(),
                            ],
                          ),
                        ), // IntrinsicWidth
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
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
                          if (_selectedLevelId == null ||
                              _selectedModeId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('レベルを選択してください。')),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChangeNotifierProvider(
                                    create: (_) => TypingController(),
                                    child: TypingPage(
                                      title:
                                          '${_levelOptions.firstWhere((opt) => opt['id'] == _selectedLevelId)['name']} ${_modeOptions.firstWhere((opt) => opt['id'] == _selectedModeId)['name']} ($_selectedWordCount words)',
                                      level: _selectedLevelId!,
                                      mode: _selectedModeId!,
                                      wordCount:
                                          _selectedWordCount, // 選択されたワード数を渡す
                                    ),
                                  ),
                            ),
                          );
                        },
                        child: const Text('Start Game'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ), // Expandedの閉じカッコ
        ], // Rowのchildrenリストの閉じカッコ
      ), // Rowの閉じカッコ
    );
  }
}
