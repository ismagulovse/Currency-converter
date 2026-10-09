import 'package:flutter/material.dart';

import '../state/converter_state.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key, required this.state});

  final ConverterState state;

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final amountController = TextEditingController(text: '100');
  final currencies = ['EUR', 'USD', 'RUB', 'GBP', 'KZT'];

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF168A70);
    const lightGreen = Color(0xFFEAF4F0);
    const grey = Color(0xFF7D8984);

    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, child) {
        final state = widget.state;
        String resultText = '— —';

        if (state.isLoading) {
          resultText = 'Загрузка...';
        } else if (state.error != null) {
          resultText = state.error!;
        } else if (state.exchangeRate != null) {
          resultText =
              '${state.convertedAmount!.toStringAsFixed(2)} '
              '${state.toCurrency}\n'
              '1 ${state.fromCurrency} = ${state.exchangeRate!.rate} '
              '${state.toCurrency}\n'
              'Дата курса: ${state.exchangeRate!.date}';
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          appBar: AppBar(
            title: const Text('Конвертер'),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    suffixText: state.fromCurrency,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(width: 20, color: grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Валюты'),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButton<String>(
                        value: state.fromCurrency,
                        isExpanded: true,
                        items: currencies.map((currency) {
                          return DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: state.isLoading
                            ? null
                            : (value) {
                                if (value != null) {
                                  state.setFromCurrency(value);
                                }
                              },
                      ),
                    ),
                    IconButton(
                      onPressed: state.isLoading ? null : state.swapCurrencies,
                      icon: const Icon(Icons.swap_horiz),
                      color: green,
                    ),
                    Expanded(
                      child: DropdownButton<String>(
                        value: state.toCurrency,
                        isExpanded: true,
                        items: currencies.map((currency) {
                          return DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: state.isLoading
                            ? null
                            : (value) {
                                if (value != null) {
                                  state.setToCurrency(value);
                                }
                              },
                      ),
                    ),
                  ],
                ),

                //кнопка
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FilledButton(
                    onPressed: state.isLoading
                        ? null
                        : () => state.convert(amountController.text),
                    style: FilledButton.styleFrom(backgroundColor: green),
                    child: const Text(
                      'Перевести',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                //вывод
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Результат', style: TextStyle(color: grey)),
                      const SizedBox(height: 10),
                      Text(
                        resultText,
                        style: TextStyle(
                        color: state.error != null? Colors.red: const Color.fromARGB(255, 0, 0, 0),                          
                          fontSize: 18,
                        ),
                      ),
                      Text('${state.fromCurrency} → ${state.toCurrency}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.currency_exchange),
                label: 'Обмен',
              ),
              NavigationDestination(
                icon: Icon(Icons.show_chart),
                label: 'Курсы',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_border),
                label: 'Избранное',
              ),
              NavigationDestination(
                icon: Icon(Icons.history),
                label: 'История',
              ),
            ],
            selectedIndex: 0,
            onDestinationSelected: (index) {
              if (index != 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Страница отстутствует')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
