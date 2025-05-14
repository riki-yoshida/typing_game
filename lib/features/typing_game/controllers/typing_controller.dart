import 'package:flutter/material.dart';
import 'package:typing_game/features/typing_game/models/typing_game_model.dart';

class TypingController with ChangeNotifier {
  final TypingGameModel _model = TypingGameModel();
  late TextEditingController textEditingController;

  TypingController() {
    textEditingController = TextEditingController();
  }

  String get problemText => _model.currentProblemText;
  String get typedText => _model.typedText;
  bool get isGameClear => _model.isGameClear;

  void onInputChanged(String value) {
    if (isGameClear) return;

    _model.setTypedText(value);

    if (_model.typedText == _model.currentProblemText) {
      _model.nextProblem();
      textEditingController.clear();
    }
    notifyListeners();
  }

  void resetGame() {
    // 必要であればゲームをリセットするロジックをここに追加
    // _model = TypingGameModel(); // 例えば新しいモデルインスタンスを作成
    // textEditingController.clear();
    // notifyListeners();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}
