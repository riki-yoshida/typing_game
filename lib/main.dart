import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal), // テーマカラーを変更
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _problemText = "type this text"; // 表示する問題文
  String _typedText = ""; // ユーザーが入力したテキスト
  int _currentProblemIndex = 0; // 現在の問題文のインデックス（複数の問題に対応する場合）
  List<String> _problems = ["hello world", "flutter is fun", "dart language"]; // 問題文のリスト
  late TextEditingController _inputController; // TextEditingControllerをStateで管理

  @override
  void initState() {
    super.initState();
    _problemText = _problems[_currentProblemIndex]; // 最初の問題を設定
    _inputController = TextEditingController(); // コントローラーを初期化
  }

  @override
  void dispose() {
    _inputController.dispose(); // コントローラーを破棄
    super.dispose();
  }

  void _onInputChanged(String value) {
    setState(() {
      _typedText = value;
      // ここで入力された文字と問題文を比較するロジックを追加します
      // 例えば、全て正しく入力されたら次の問題へ進むなど
      if (_typedText == _problemText) {
        // 次の問題へ（もしあれば）
        _currentProblemIndex++;
        if (_currentProblemIndex < _problems.length) {
          _problemText = _problems[_currentProblemIndex];
          _typedText = ""; // 入力フィールドをクリア
          _inputController.clear(); // コントローラーを使ってTextFieldをクリア
        } else {
          // 全問クリア！
          _problemText = "Congratulations! All done!";
          _inputController.clear(); // コントローラーを使ってTextFieldをクリア
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer, // AppBarの色を変更
        title: Text(widget.title),
      ),
      backgroundColor: Theme.of(context).colorScheme.background.withValues(alpha: 0.95), // alphaに0.0-1.0のdouble値を直接指定
      body: Padding( // 全体にパディングを追加
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container( // 問題文を少し装飾
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1), // alphaに0.0-1.0のdouble値を直接指定
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  _problemText, // 問題文を表示
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28, // フォントサイズを少し大きく
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 30), // 間隔を調整
              TextField(
                autofocus: true,
                onChanged: _onInputChanged,
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: 'ここに入力してください',
                  filled: true, // TextFieldに背景色を適用
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // 角を丸くする
                    borderSide: BorderSide.none, // 枠線を消す (filled: true の場合)
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22), // 入力文字のサイズ調整
              ),
            ],
          ),
        ),
      ),
    );
  }
}
