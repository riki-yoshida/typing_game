import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:typing_game/features/typing_game/controllers/typing_controller.dart';
import 'package:typing_game/features/home/presentation/pages/start_page.dart';
import 'package:typing_game/theme/app_colors.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TypingController(),
      child: MaterialApp(
        title: 'タイピング英語塾',
        // ライトテーマの設定
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'NotoSansJP',
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: AppColors.lightPrimary,
            onPrimary: AppColors.lightOnPrimary,
            primaryContainer: AppColors.lightPrimaryContainer,
            onPrimaryContainer: AppColors.lightOnPrimaryContainer,
            secondary: AppColors.lightSecondary,
            onSecondary: AppColors.lightOnSecondary,
            secondaryContainer: AppColors.lightSecondaryContainer,
            onSecondaryContainer: AppColors.lightOnSecondaryContainer,
            surface: AppColors.lightSurface, // background から surface に変更
            onSurface:
                AppColors.lightOnSurface, // onBackground から onSurface に変更
            error: AppColors.lightError,
            onError: AppColors.lightOnError,
            // background と onBackground は surface と onSurface でカバーされるため削除
          ),
          // 他のテーマ属性（例：textTheme, appBarThemeなど）もここで定義できます
        ),
        // ダークテーマの設定
        darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: 'NotoSansJP',
          colorScheme: const ColorScheme(
            brightness: Brightness.dark,
            primary: AppColors.darkPrimary,
            onPrimary: AppColors.darkOnPrimary,
            primaryContainer: AppColors.darkPrimaryContainer,
            onPrimaryContainer: AppColors.darkOnPrimaryContainer,
            secondary: AppColors.darkSecondary,
            onSecondary: AppColors.darkOnSecondary,
            secondaryContainer: AppColors.darkSecondaryContainer,
            onSecondaryContainer: AppColors.darkOnSecondaryContainer,
            surface: AppColors.darkSurface, // background から surface に変更
            onSurface: AppColors.darkOnSurface, // onBackground から onSurface に変更
            error: AppColors.darkError,
            onError: AppColors.darkOnError,
            // background と onBackground は surface と onSurface でカバーされるため削除
          ),
        ),
        themeMode: ThemeMode.system, // システム設定に基づいてテーマを自動的に切り替える
        home: const StartPage(), // MaterialAppのhomeをStartPageに変更
      ),
    );
  }
}
