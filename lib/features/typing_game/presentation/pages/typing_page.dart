import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  // State内のロジックはControllerに移動

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // async を追加
      // initializeGame が Future を返すようになったため await で待つ
      await Provider.of<TypingController>(
        context,
        listen: false,
      ).initializeGame(
        level: widget.level,
        mode: widget.mode,
        wordCount: widget.wordCount, // Controllerにワード数を渡す
      );
      // 必要であれば、ロード完了後に何かUI更新以外の処理を行う
    });
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
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(
        0.95,
      ), // withValuesからwithOpacityに戻す (またはwithValuesを正しく使う)
      body: Padding(
        // 全体にパディングを追加
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
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
                      if (controller.finalElapsedTime != null) // 最終経過時間があれば表示
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Text(
                            'クリアタイム: ${controller.finalElapsedTime!.inSeconds} 秒', // 秒単位で表示
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.secondary,
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
                      // ワード数と経過時間を横並びに表示
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ワード数表示
                          Text(
                            controller.currentWordIndex > 0
                                ? '${controller.currentWordIndex - 1} / ${controller.targetWordCount} ワード'
                                : '目標: ${controller.targetWordCount} ワード', // 最初の問題表示前は目標ワード数のみ
                            style: TextStyle(
                              fontSize: 18, // サイズ調整
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ), // ワード数表示のText終了
                          // 経過時間表示
                          Text(
                            controller
                                .currentElapsedTimeFormatted, // リアルタイム経過時間を表示
                            style: TextStyle(
                              fontSize: 18, // サイズ調整
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ], // Rowのchildren終了
                      ), // Row終了
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ), // EdgeInsets.symmetric終了
                        decoration: BoxDecoration(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.1,
                              ), // withValuesをwithOpacityに戻す (またはwithValuesを正しく使う)
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          controller.problemText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 24.0,
                        ), // EdgeInsets.symmetric終了
                        decoration: BoxDecoration(
                          color:
                              Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                0.1,
                              ), // withValuesをwithOpacityに戻す (またはwithValuesを正しく使う)
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          controller.problemTextToJa,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        autofocus: true,
                        onChanged: controller.onInputChanged,
                        controller: controller.textEditingController,
                        enabled: !controller.isGameClear,
                        decoration: InputDecoration(
                          hintText: 'ここに入力してください',
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0,
                            horizontal: 20.0,
                          ),
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ],
          ),
        ),
      ),
    );
  }
}
