import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // JSONファイル読み込みに必要
import 'dart:async'; // Timerに必要
import 'dart:convert'; // JSONデコードに必要

class TypingController with ChangeNotifier {
  String _problemText = "読み込み中..."; // 初期値を日本語に変更
  String _problemTextToJp = "読込中...";
  String get problemText => _problemText;
  String get problemTextToJp => _problemTextToJp;

  final TextEditingController textEditingController = TextEditingController();
  bool _isGameClear = false;
  bool get isGameClear => _isGameClear;
  bool _allWordsCompleted = false;
  bool get allWordsCompleted => _allWordsCompleted;

  String? _currentLevel;
  String? _currentMode; // _currentModeはonInputChangedで使用されています
  int _targetWordCount = 10; // デフォルトの目標ワード数
  int get targetWordCount => _targetWordCount; // _targetWordCountのゲッターを追加
  int get currentWordIndex => _currentWordIndex; // _currentWordIndexのゲッターを追加
  int _currentWordIndex = 0; // 現在の出題数 (0からスタート)

  DateTime? _gameStartTime; // ゲーム開始時刻 (最初の問題が出題された時)
  Duration? _finalElapsedTime; // 全問完了/ゲームクリア時の最終経過時間
  Duration? get finalElapsedTime => _finalElapsedTime; // 最終経過時間のゲッター

  Timer? _timer; // 経過時間更新用タイマー
  Duration _currentElapsedTime = Duration.zero; // リアルタイムの経過時間

  Timer? _hintTimer; // 本番モードでのヒント表示用タイマー
  int _hintCharsVisibleCount = 0; // 本番モードで表示されているヒントの文字数

  // 読み込んだ単語リストをキャッシュするためのMap
  final Map<String, List<Map<String, String>>> _loadedWordListsCache = {};

  // レベル名とJSONファイル名のマッピング
  final Map<String, String> _levelToFileMap = {
    'shougakusei': 'shougakusei.json',
    'chuugakusei': 'chuugakusei.json',
    'koukousei': 'koukousei.json',
    'daigakusei': 'daigakusei.json',
    'shakaijin': 'shakaijin.json',
  };

  List<Map<String, String>> _currentWordList = [];
  final Random _random = Random();

  TypingController() {
    // テキスト入力の変更を監視するリスナー
    textEditingController.addListener(_onInput);
  }

  // initializeGameを非同期に変更
  Future<void> initializeGame({
    required String level,
    required String mode,
    int wordCount = 10, // StartPageからワード数を受け取る
  }) async {
    _currentLevel = level;
    _currentMode = mode;
    _targetWordCount = wordCount; // 目標ワード数を設定
    _currentWordIndex = 0; // 出題数をリセット
    _isGameClear = false;
    _allWordsCompleted = false; // 全問完了状態をリセット
    _gameStartTime = null; // 開始時刻をリセット
    _finalElapsedTime = null; // 最終経過時間をリセット
    _currentElapsedTime = Duration.zero; // リアルタイム経過時間をリセット
    _stopTimer(); // 既存のタイマーがあれば停止
    _stopHintTimer(); // 既存のヒントタイマーがあれば停止
    _hintCharsVisibleCount = 0; // ヒント表示数をリセット
    _problemText = "読み込み中..."; // ロード中に表示するテキスト
    _problemTextToJp = "読込中...";
    textEditingController.clear(); // 前回の入力をクリア
    notifyListeners(); // UIを更新して「読み込み中...」を表示

    // キャッシュを確認
    if (_loadedWordListsCache.containsKey(level)) {
      _currentWordList = _loadedWordListsCache[level]!;
    } else {
      // ファイルから読み込み
      final fileName = _levelToFileMap[level];
      if (fileName == null) {
        _problemText = "レベルに対応するファイルが見つかりません。";
        _problemTextToJp = "レベルに対応するファイルが見つかりません。";
        _currentWordList = [];
        notifyListeners();
        return;
      }

      try {
        final String jsonString = await rootBundle.loadString(
          'assets/word_lists/$fileName',
        );
        final List<dynamic> jsonList = jsonDecode(jsonString);
        // JSONの各要素を Map<String, String> に変換
        _currentWordList =
            jsonList.map((item) => Map<String, String>.from(item)).toList();
        _loadedWordListsCache[level] = _currentWordList; // 読み込んだリストをキャッシュに保存
      } catch (e) {
        // ignore: avoid_print
        print("単語リストの読み込みエラー ($level): $e");
        _problemText = "単語リストの読み込みに失敗しました。";
        _problemTextToJp = "単語リストの読み込みに失敗しました。";
        _currentWordList = [];
        notifyListeners();
        return;
      }
    }

    // 最初の問題を設定
    _setNewProblem();
    _startTimer(); // 最初の問題設定後にタイマーを開始
    notifyListeners(); // UIに変更を通知
  }

  void _setNewProblem() {
    _currentWordIndex++; // 出題数をインクリメント
    if (_currentWordIndex == 1 && _gameStartTime == null) {
      // 最初の問題が出題された時（かつまだ開始時刻が記録されていなければ）
      _gameStartTime = DateTime.now(); // ゲーム開始時刻を記録
    }
    if (_currentWordList.isNotEmpty) {
      final wordPair =
          _currentWordList[_random.nextInt(_currentWordList.length)];
      _problemText = wordPair['en']!; // 英語の単語を問題文として設定
      _problemTextToJp = wordPair['ja']!; // 日本語の単語を問題文として設定
    } else {
      // initializeGameでエラーメッセージが設定されているはずなので、
      // ここでは problemText が "読み込み中..." の場合のみ更新する
      if (_problemText == "読み込み中...") {
        _problemText = "このレベルの単語がありません！";
        _problemTextToJp = "このレベルの単語がありません！";
      }
    }
    if (_currentMode == 'real') {
      _hintCharsVisibleCount = 0; // 新しい問題になったらヒント表示をリセット
      _stopHintTimer(); // 古いヒントタイマーを止めて
      _startHintTimer(); // 新しいヒントタイマーを開始
    }
    // より複雑なゲームでは、最近使用した単語を避ける処理などを追加できます。
  }

  // ゲーム開始時にタイマーを開始
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameStartTime != null && !_isGameClear) {
        _currentElapsedTime = DateTime.now().difference(_gameStartTime!);
        notifyListeners(); // 経過時間更新をUIに通知
      }
    });
  }

  // タイマーを停止
  void _stopTimer() {
    _timer?.cancel();
  }

  // 本番モードでヒントタイマーを開始
  void _startHintTimer() {
    if (_currentMode != 'real' ||
        _problemText.isEmpty ||
        _problemText == "読み込み中...") {
      return;
    }
    // ヒント表示間隔を3秒に設定
    _hintTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_hintCharsVisibleCount < _problemText.length) {
        _hintCharsVisibleCount++;
        notifyListeners();
      } else {
        _stopHintTimer(); // 全文字表示されたらタイマー停止
      }
    });
  }

  void _stopHintTimer() {
    _hintTimer?.cancel();
  }

  // TextFieldのonChangedから呼び出されるメソッド
  void onInputChanged(String value) {
    // ignore: avoid_print
    print(
      'Input: "$value", Problem: "$_problemText", Mode: "$_currentMode"',
    ); // デバッグ用
    // 入力されたテキストと問題文（小文字に変換して比較）が一致した場合
    if (value.toLowerCase() == _problemText.toLowerCase()) {
      // ignore: avoid_print
      print('Match found! Mode: $_currentMode'); // デバッグ用

      // 目標ワード数に達したかどうかの判定 (練習モード・本番モード共通のクリア条件)
      if (_currentWordIndex >= _targetWordCount) {
        _allWordsCompleted = true;
        _isGameClear = true; // 入力不可にするため（ゲームクリア状態も兼ねる）
        _stopTimer(); // メインタイマー停止
        _stopHintTimer(); // ヒントタイマーも停止
        if (_gameStartTime != null) {
          _finalElapsedTime = DateTime.now().difference(
            _gameStartTime!,
          ); // 経過時間を計算
        }
        // ignore: avoid_print
        print('All words completed! Mode: $_currentMode');
      } else {
        // まだ目標に達していなければ次の問題へ
        print(
          'Setting new problem. ($_currentWordIndex/$_targetWordCount) Mode: $_currentMode',
        );
        _setNewProblem(); // この中で本番モードの場合はヒントタイマーもリセット・再開される
        textEditingController.clear();
      }
    } else {
      // ignore: avoid_print
      print('No match.'); // デバッグ用
    }
    notifyListeners(); // UIに変更を通知
  }

  // 表示用の問題文（本番モードではヒントに応じて加工）
  String get revealedProblemText {
    if (_currentMode != 'real' ||
        _problemText.isEmpty ||
        _problemText == "読み込み中...") {
      return _problemText; // 練習モードまたはロード中はそのまま表示
    }
    if (_hintCharsVisibleCount == 0) {
      // 最初はすべて隠す（例として'*'を使用）
      return '*' * _problemText.length;
    }
    // 表示する部分と隠す部分を結合
    final revealedPart = _problemText.substring(0, _hintCharsVisibleCount);
    final hiddenPart = '*' * (_problemText.length - _hintCharsVisibleCount);
    return revealedPart + hiddenPart;
  }

  // リアルタイム経過時間のゲッター
  String get currentElapsedTimeFormatted {
    final minutes = _currentElapsedTime.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = _currentElapsedTime.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // textEditingControllerのリスナーメソッド
  void _onInput() {
    // このメソッドはTextEditingControllerのテキストが変更されるたびに呼び出されます。
    // 特定のシナリオでonChangedコールバックよりもリスナーを優先する場合にロジックをここに配置できます。
    // 現在のセットアップでは、TextFieldの`onChanged`から呼び出される`onInputChanged`がより直接的です。
    // `onInputChanged`が既にロジックを処理している場合、このリスナーは必要に応じて他のリアクティブな更新に使用できます。
    // ただし、リアルタイムの経過時間表示のためにnotifyListeners()を頻繁に呼び出すのは、
    // onInputChangedではなくタイマーで行う方が効率的です。
    // 重複処理を避けるため、主要なロジックは`onInputChanged`にあることを確認してください。
    // ここでは特に何もしません。
  }

  @override
  void dispose() {
    textEditingController.removeListener(_onInput);
    textEditingController.dispose();
    super.dispose();
    _stopTimer();
    _stopHintTimer(); // コントローラー破棄時にもヒントタイマーを停止
  }
}
