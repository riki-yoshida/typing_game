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
  final double? screenWidth; // オプションで画面幅を受け取る

  const TitleWithButtons({
    super.key,
    required this.title,
    required this.buttonActions,
    this.screenWidth,
  }) : assert(
         buttonActions.length > 0,
         'At least one button action is required.',
       ); // ボタンが1つ以上あることを保証

  @override
  Widget build(BuildContext context) {
    // screenWidthに基づいてフォントサイズを計算、指定がなければデフォルト値48.0
    // 例: 画面幅の15分の1を基本サイズとし、最小24、最大48とする
    final double titleFontSize =
        screenWidth != null ? (screenWidth! / 15).clamp(24.0, 48.0) : 48.0;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal:
            screenWidth != null ? (screenWidth! / 30).clamp(12.0, 24.0) : 24.0,
        vertical: 16.0,
      ),
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
                FittedBox(
                  fit: BoxFit.scaleDown, // 親ウィジェットのサイズに合わせて縮小
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    // softWrap と overflow は FittedBox を使う場合、通常は不要
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: titleFontSize, // 最大フォントサイズとして機能
                      fontFamily: 'OunenMouhitsu',
                    ),
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
              padding: EdgeInsets.symmetric(
                vertical: 6.0,
                horizontal:
                    screenWidth != null
                        ? (screenWidth! / 40).clamp(8.0, 16.0)
                        : 16.0,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  padding: EdgeInsets.zero,
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    // 画面幅に応じてボタンのフォントサイズを調整
                    // 例: 画面幅の25分の1を基本サイズとし、最小16、最大24とする
                    fontSize:
                        screenWidth != null
                            ? (screenWidth! / 25).clamp(16.0, 24.0)
                            : 24.0,
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
