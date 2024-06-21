import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String fromCurrency = 'USD';
  String toCurrency = 'EUR';
  double rate = 0.0;
  double total = 0.0;
  TextEditingController amountController = TextEditingController();
  List<String> currencies = [];

  @override
  void initState() {
    super.initState();
    _getCurrencies();
  }

  void _getCurrencies() async {
    var response = await http
        .get(Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'));
    var data = json.decode(response.body);

    setState(() {
      currencies = (data['rates'] as Map<String, dynamic>).keys.toList();
      rate = data['rates'][toCurrency];
    });
  }

  void _getRate() async {
    var response = await http.get(Uri.parse(
        'https://api.exchangerate-api.com/v4/latest/${fromCurrency}'));
    var data = json.decode(response.body);
    print(response.body.toString());

    setState(() {
      rate = data['rates'][toCurrency];
    });
  }

  void _swapCurrencies() {
    setState(() {
      String temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
      _getRate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          'Check Rate',
          style: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.02,
              fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 38, 69),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            SizedBox(
              height: size.height * 0.3,
              width: size.width,
              child: Icon(
                Icons.refresh,
                color: Colors.white,
                size: size.height * 0.3,
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    labelStyle: const TextStyle(color: Colors.grey),
                    label: const Text('Enter Amount you wish to convert'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
                onChanged: (val) {
                  if (val != '') {
                    setState(() {
                      double amount = double.parse(val);
                      total = amount * rate;
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: size.height * 0.06,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: DropdownButton<String>(
                        value: fromCurrency,
                        items: currencies
                            .map((String e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        isExpanded: true,
                        dropdownColor: const Color(0xff1d2630),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (onChanged) {
                          setState(() {
                            fromCurrency = onChanged!;
                            _getRate();
                          });
                        }),
                  ),
                  IconButton(
                      onPressed: _swapCurrencies,
                      icon: const Icon(
                        Icons.swap_horiz,
                        size: 40,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 100,
                    child: DropdownButton<String>(
                        value: toCurrency,
                        items: currencies
                            .map((String e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        isExpanded: true,
                        dropdownColor: const Color(0xff1d2630),
                        style: const TextStyle(color: Colors.white),
                        onChanged: (onChanged) {
                          setState(() {
                            toCurrency = onChanged!;
                            _getRate();
                          });
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            Text('Rate ${rate}',
                style: TextStyle(
                    fontSize: size.height * 0.02, color: Colors.white)),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(total.toStringAsFixed(3),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.06,
                    color: Colors.greenAccent))
          ],
        ),
      ),
    );
  }
}
