import 'package:flutter/material.dart';
import 'package:webview/views/web_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WebView(),
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF82B1FF),
          selectionColor: Color(0x3382B1FF),
          selectionHandleColor: Color(0xFF82B1FF),
        ),
      ),
    );
  }
}
