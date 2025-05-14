import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typing_game/features/typing_game/controllers/typing_controller.dart';

class TypingPage extends StatefulWidget {
  const TypingPage({super.key, required this.title});

  final String title;

  @override
  State<TypingPage> createState() => _TypingPageState();
}

class _TypingPageState extends State<TypingPage> {
  // State内のロジックはControllerに移動

  @override
  void initState() {
    super.initState();
    // 初期化処理が必要な場合はControllerで行うか、ここでControllerのメソッドを呼ぶ
    // 例: Provider.of<TypingController>(context, listen: false).initialize();
  }

  @override
  void dispose() {
    // TextEditingControllerのdisposeはController側で行う
    super.dispose();
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
      ).colorScheme.background.withOpacity(0.95), // alphaをopacityに変更
      body: Padding(
        // 全体にパディングを追加
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                // 問題文を少し装飾
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // alphaをopacityに変更
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  controller.problemText, // Controllerから問題文を取得
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
                onChanged: controller.onInputChanged, // Controllerのメソッドを呼び出し
                controller:
                    controller
                        .textEditingController, // ControllerのTextEditingControllerを使用
                enabled: !controller.isGameClear, // ゲームクリア後は入力を無効化
                decoration: InputDecoration(
                  hintText: 'ここに入力してください',
                  filled: true, // TextFieldに背景色を適用
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0), // 角を丸くする
                    borderSide: BorderSide.none, // 枠線を消す (filled: true の場合)
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
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
