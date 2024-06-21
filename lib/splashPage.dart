import 'package:currency_exchange/homePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Future.delayed(const Duration(milliseconds: 3000)).then((val) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => const HomePage()));
    });
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SizedBox(
          height: size.height * 0.15,
          child: Column(
            children: [
              Text(
                'Currency Converter',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.02,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
