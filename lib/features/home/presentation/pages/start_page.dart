import 'package:flutter/material.dart';
import 'package:typing_game/features/typing_game/presentation/pages/typing_page.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Drawer(...) // Drawerプロパティは削除
      body: Row(
        // bodyをRowに変更してサイドバーとメインコンテンツを並べる
        children: [
          // サイドバー部分
          Container(
            // サイドバーの幅を固定するためのコンテナ
            width: 250, // サイドバーの幅
            color: Theme.of(context).colorScheme.surfaceVariant, // サイドバーの背景色
            child: ListView(
              // Drawerの中身をListViewとして再利用
              padding: EdgeInsets.zero,
              children: [
                // DrawerHeaderの代わり
                Container(
                  height: 100, // ヘッダーの高さ
                  color: Theme.of(context).colorScheme.primary,
                  alignment: Alignment.centerLeft, // テキストの配置
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ), // パディング
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 24,
                    ),
                  ),
                ),
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
              ],
            ),
          ), // サイドバーのContainerの閉じカッコ
          Expanded(
            // 残りの領域をメインコンテンツに割り当てる
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Welcome to Typing Game!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const TypingPage(title: 'Play Typing Game'),
                      ),
                    );
                  },
                  child: const Text('Start Game'),
                ),
              ],
            ),
          ), // Expandedの閉じカッコ
        ], // Rowのchildrenリストの閉じカッコ
      ), // Rowの閉じカッコ
    );
  }
}
