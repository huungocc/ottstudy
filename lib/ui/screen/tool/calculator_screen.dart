import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';

import '../../../res/colors.dart';
import '../../widget/custom_text_label.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  double? _currentValue = 0;

  @override
  Widget build(BuildContext context) {
    final calc = SimpleCalculator(
      value: _currentValue ?? 0,
      hideExpression: false,
      hideSurroundingBorder: true,
      onChanged: (key, value, expression) {
        setState(() {
          _currentValue = value;
        });
      },
      theme: const CalculatorThemeData(
        operatorColor: Colors.black54,
        displayColor: AppColors.white,
        displayStyle: TextStyle(fontSize: 24, color: AppColors.black),
        expressionColor: Colors.grey,
        expressionStyle: TextStyle(fontSize: 18, color: Colors.white54),
      ),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.background_white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CustomTextLabel(
                'Máy tính cầm tay',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: calc
            ),
          ),
        ],
      ),
    );
  }
}