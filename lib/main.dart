import 'package:flutter/material.dart';
import 'package:flutter_dapp/contractLinking.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dapp/hello_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContractLinking>(
      create: (context) => ContractLinking(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter Dapp",
        home: HelloPage(),
      ),
    );
  }
}
