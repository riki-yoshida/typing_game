class TypingGameModel {
  final List<String> _problems = [
    "hello world",
    "flutter is fun",
    "dart language",
  ];

  int _currentProblemIndex = 0;
  String _typedText = "";

  String get currentProblemText =>
      _currentProblemIndex < _problems.length
          ? _problems[_currentProblemIndex]
          : "Congratulations! All done!";

  String get typedText => _typedText;

  bool get isGameClear =>
      _currentProblemIndex >= _problems.length &&
      currentProblemText.startsWith("Congratulations");

  void setTypedText(String text) {
    _typedText = text;
  }

  void nextProblem() {
    _currentProblemIndex++;
    _typedText = "";
  }
}
