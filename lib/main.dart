import 'package:cryptogen/controllers/provider/crypto_provider.dart';
import 'package:cryptogen/controllers/provider/graph_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:cryptogen/view/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CryptoDataProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, _, __){
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<CryptoDataProvider>(create: (context)=>CryptoDataProvider()),
            ChangeNotifierProvider<GraphProvider>(create: (context)=>GraphProvider()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(),
            home: HomeScreen(),
          ),
        );
      },
    );
  }
}
