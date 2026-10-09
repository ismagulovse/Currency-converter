import 'package:currency_converter/widgets/converter_screen.dart';
import 'package:flutter/material.dart';

import 'repositories/currency_repository.dart';
import 'services/currency_api.dart';
import 'state/converter_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final converterState = ConverterState(CurrencyRepository(CurrencyApi()));

  @override
  void dispose() {
    converterState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Конвертер валют',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: ConverterScreen(state: converterState),
    );
  }
}
