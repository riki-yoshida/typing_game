import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Required for LengthLimitingTextInputFormatter
import 'package:typing_game/features/typing_game/controllers/typing_controller.dart';

class TypingPage extends StatefulWidget {
  const TypingPage({
    super.key,
    required this.title,
    required this.level,
    required this.mode,
    this.wordCount = 10, // wordCountパラメータを追加し、デフォルト値を設定
  });

  final String title;
  final String level;
  final String mode; // modeパラメータを追加
  // levelパラメータを追加
  final int wordCount; // wordCountパラメータを追加
  @override
  State<TypingPage> createState() => _TypingPageState();
}

class _TypingPageState extends State<TypingPage> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = Provider.of<TypingController>(context, listen: false);
      // initializeGame が Future を返すようになったため await で待つ
      await controller.initializeGame(
        level: widget.level,
        mode: widget.mode,
        wordCount: widget.wordCount, // Controllerにワード数を渡す
      );
      // ゲームが初期化され、問題が準備できていればフォーカスをリクエスト
      if (mounted &&
          controller.problemText.isNotEmpty &&
          controller.problemText != "読み込み中...") {
        // 短い遅延を入れてからフォーカスを要求
        // これにより、UIの描画や他の初期化処理が完了するのを待つ
        Future.delayed(const Duration(milliseconds: 100), () {
          // 遅延時間は環境に応じて調整
          if (mounted && !_focusNode.hasFocus) {
            // 再度 mounted と hasFocus を確認
            FocusScope.of(context).requestFocus(_focusNode);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    // TextEditingControllerのdisposeはController側で行う
    super.dispose();
  }

  // 入力マス表示を構築するウィジェット関数
  Widget buildInputDisplay(TypingController controller) {
    if (controller.isGameClear) {
      return const SizedBox.shrink(); // ゲームクリア時は何も表示しない
    }

    // 問題が準備できていない場合はプレースホルダーを表示
    if (controller.problemText.isEmpty ||
        controller.problemText == "読み込み中...") {
      return Container(
        height: 48, // マスの高さに合わせる
        alignment: Alignment.center,
        child: Text(
          controller.problemText == "読み込み中..." ? "読み込み中..." : "問題待機中...",
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      );
    }

    int problemLength = controller.problemText.length;
    String currentInput = controller.textEditingController.text;

    List<Widget> inputCells = List.generate(problemLength, (index) {
      String charToShow = "";
      if (index < currentInput.length) {
        charToShow = currentInput[index];
      }
      // 現在入力中のマス（次に文字が入る位置）を判定
      bool isActive = _focusNode.hasFocus && index == currentInput.length;

      // 文字の正誤を判定
      bool isCorrect = true;
      if (index < currentInput.length) {
        // 問題文が十分に長ければ比較
        if (index < controller.problemText.length) {
          isCorrect =
              currentInput[index].toLowerCase() ==
              controller.problemText[index].toLowerCase();
        } else {
          // 入力が問題文より長い場合は、その部分は不正解とする
          isCorrect = false;
        }
      }

      return Container(
        width: 38, // マスの幅
        height: 48, // マスの高さ
        margin: const EdgeInsets.symmetric(horizontal: 3), // マス間の余白
        decoration: BoxDecoration(
          color:
              isCorrect
                  ? Theme.of(context).colorScheme.surfaceVariant
                  : Theme.of(
                    context,
                  ).colorScheme.errorContainer.withOpacity(0.5), // 正誤に応じて背景色を変更
          border: Border.all(
            color:
                !isCorrect
                    ? Theme.of(context).colorScheme.error
                    : // 間違っている場合はエラー色
                    (isActive
                        ? Theme.of(context)
                            .colorScheme
                            .primary // アクティブなマスの枠線色
                        : Theme.of(context).colorScheme.outline.withOpacity(
                          0.5,
                        )), // 非アクティブなマスの枠線色
            width: isActive ? 2.0 : 1.0, // アクティブなマスの枠線太さ
          ),
          borderRadius: BorderRadius.circular(8), // 角丸
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            charToShow, // 入力された文字をそのまま表示
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    });

    // 入力マス全体をタップ可能にして、タップされたらTextFieldにフォーカスを当てる
    return GestureDetector(
      onTap: () {
        if (!_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // マスを中央に配置
        mainAxisSize: MainAxisSize.min, // Rowのサイズを子ウィジェットに合わせる
        children: inputCells,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Provider経由でControllerのインスタンスを取得
    // context.watch<T>() は build メソッド内で呼び出し、変更を監視します
    final controller = context.watch<TypingController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.primaryContainer, // AppBarの色を変更
        title: Text(widget.title),
      ),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.surface.withOpacity(0.95), // 背景色と透明度
      body: Padding(
        // 全体にパディングを追加
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Stack(
            // Column全体をStackでラップ
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    controller.allWordsCompleted
                        ? <Widget>[
                          // 全問完了時の表示
                          Icon(
                            Icons.check_circle_outline,
                            color: Theme.of(context).colorScheme.primary,
                            size: 80,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '全 ${controller.targetWordCount} ワードのタイピング完了！',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (controller.finalElapsedTime !=
                              null) // 最終経過時間があれば表示
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Text(
                                'クリアタイム: ${controller.finalElapsedTime!.inSeconds} 秒', // 秒単位で表示
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('スタート画面に戻る'),
                          ),
                        ]
                        : <Widget>[
                          // 通常のゲーム中の表示
                          // 元のコンテンツはColumn内に
                          // ワード数表示はPositionedウィジェット内に移動
                          Container(
                            // 日本語文字を表示しているコンテナ
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ), // EdgeInsets.symmetric終了
                            child: Text(
                              controller.problemTextToJp,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 120, // 日本語のフォントサイズ
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Container(
                            // 英語文字を表示しているコンテナ
                            padding: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ), // EdgeInsets.symmetric終了
                            child: Text(
                              controller.revealedProblemText, // 修正：加工された問題文を表示
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28, // 英語のフォントサイズ
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40), // 英語と入力マスの間のスペース
                          buildInputDisplay(controller), // 入力マス表示を呼び出し
                          // 実際の入力キャプチャ用の隠しTextField
                          Opacity(
                            // SizedBox(width: 0, height: 0) の代わりに Opacity を使用
                            opacity: 0.0, // 透明にして見えなくする
                            child: TextField(
                              focusNode: _focusNode, // フォーカスノードを設定
                              // autofocus: true, // initStateでプログラム的にフォーカスを制御するため削除
                              controller:
                                  controller
                                      .textEditingController, // コントローラーを設定
                              onChanged: controller.onInputChanged, // 入力変更時の処理
                              // 問題文の長さに合わせて最大文字数を設定
                              maxLength:
                                  controller.problemText.isNotEmpty &&
                                          controller.problemText != "読み込み中..."
                                      ? controller.problemText.length
                                      : null, // 問題が準備できていない場合は制限なし
                              // 入力フォーマッターで文字数を制限
                              inputFormatters:
                                  controller.problemText.isNotEmpty &&
                                          controller.problemText != "読み込み中..."
                                      ? [
                                        LengthLimitingTextInputFormatter(
                                          controller.problemText.length,
                                        ),
                                      ]
                                      : [], // 問題が準備できていない場合は制限なし
                              enabled:
                                  !controller.isGameClear && // ゲームクリア時は無効
                                  controller
                                      .problemText
                                      .isNotEmpty && // 問題が空でない
                                  controller.problemText !=
                                      "読み込み中...", // 読み込み中でない
                              keyboardType:
                                  TextInputType.visiblePassword, // 予測変換などを防ぐ
                              autocorrect: false, // 自動修正を無効
                              enableSuggestions: false, // 予測変換候補を無効
                              // 見た目を完全に隠すためのスタイル
                              cursorColor: Colors.transparent, // カーソルを透明に
                              showCursor: false, // カーソル非表示 (プラットフォームによる)
                              style: const TextStyle(
                                color: Colors.transparent,
                                fontSize: 1,
                              ), // 文字色を透明に、フォントサイズを極小(1)に
                              decoration: const InputDecoration.collapsed(
                                hintText: '',
                              ), // ヒントテキストや枠線をなくす
                            ),
                          ),
                        ],
              ),
              // 経過時間とワード数を右上に表示
              if (!controller.allWordsCompleted &&
                  !controller.isGameClear) // ゲーム中のみ表示
                Positioned(
                  top: 0,
                  right: 0,
                  child: Column(
                    // 経過時間とワード数をColumnで縦に並べる
                    crossAxisAlignment: CrossAxisAlignment.end, // 右寄せにする
                    children: [
                      Text(
                        controller.currentElapsedTimeFormatted,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 4), // 時間とワード数の間に少し余白
                      Text(
                        // 現在の出題数 / 目標ワード数 を表示
                        controller.currentWordIndex > 0
                            ? '${controller.currentWordIndex} / ${controller.targetWordCount} ワード'
                            : '目標: ${controller.targetWordCount} ワード',
                        style: TextStyle(
                          fontSize: 16, // 少し小さく
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
