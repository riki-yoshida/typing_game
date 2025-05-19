import 'package:flutter/material.dart';

class WordListPage extends StatelessWidget {
  final String levelName;
  final List<Map<String, String>> wordList;

  const WordListPage({
    super.key,
    required this.levelName,
    required this.wordList,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$levelName の単語一覧')),
      body:
          wordList.isEmpty
              ? const Center(
                child: Text('このレベルの単語はありません。', style: TextStyle(fontSize: 18)),
              )
              : SingleChildScrollView(
                // DataTableが画面幅を超える場合があるのでスクロール可能にする
                child: Center(
                  // DataTableをCenterウィジェットでラップ
                  child: Padding(
                    // DataTableの周囲に余白を追加
                    padding: const EdgeInsets.all(16.0),
                    child: DataTable(
                      columnSpacing: 50.0, // 列間のスペース
                      headingRowColor: WidgetStateColor.resolveWith(
                        // ヘッダー行の背景色
                        (states) => Theme.of(
                          context,
                        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
                      ),
                      columns: const [
                        DataColumn(
                          label: Text(
                            '英語',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            '日本語',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                      rows:
                          wordList.map((wordPair) {
                            final englishWord = wordPair['en'] ?? 'N/A';
                            final japaneseWord = wordPair['ja'] ?? 'N/A';
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    englishWord,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    japaneseWord,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
    );
  }
}
