import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'widgets/app_colors.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const DivideGastosApp());
}

class DivideGastosApp extends StatelessWidget {
  const DivideGastosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Divide Gastos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: AppColors.teal,
          scaffoldBackgroundColor: AppColors.scaffoldBg,
          fontFamily: 'sans-serif',
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
