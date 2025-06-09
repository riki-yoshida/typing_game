import 'package:flutter/material.dart';

/// ボタンのテキストと押下時のアクションを保持するクラス
class ButtonAction {
  final String text;
  final VoidCallback onPressed;

  ButtonAction({required this.text, required this.onPressed});
}

/// タイトルと複数のボタンを縦に表示するウィジェット
class TitleWithButtons extends StatelessWidget {
  final String title;
  final List<ButtonAction> buttonActions;

  const TitleWithButtons({
    super.key,
    required this.title,
    required this.buttonActions,
  }) : assert(
         buttonActions.length > 0,
         'At least one button action is required.',
       ); // ボタンが1つ以上あることを保証

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Columnが必要な高さだけを占めるようにする
        children: <Widget>[
          IntrinsicWidth(
            // テキストのコンテンツ幅に合わせる
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // ContainerをIntrinsicWidthの幅に広げる
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center, // テキストを中央揃えにする場合
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 48,
                    fontFamily: 'OunenMouhitsu',
                    // decorationプロパティはここでは使用しません
                  ),
                ),
                const SizedBox(height: 4.0), // テキストとアンダーラインの間のスペース（調整可能）
                Container(
                  height: 2.0, // アンダーラインの太さ（調整可能）
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(
                    0.5,
                  ), // アンダーラインの色（テーマに合わせて調整可能）
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0), // タイトルとボタンの間のスペース
          ...buttonActions.map((action) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0), // ボタン間の縦のスペース
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 24,
                    fontFamily: 'OunenMouhitsu',
                  ),
                ),
                onPressed: action.onPressed,
                child: Text(action.text),
              ),
            );
          }),
        ],
      ),
    );
  }
}
