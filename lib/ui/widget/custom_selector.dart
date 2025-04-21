import 'package:flutter/material.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';

import '../../res/colors.dart';

class CustomSelector extends StatefulWidget {
  final List<String> items;
  final Function(int) onTap;
  final int initialSelectedIndex;

  const CustomSelector({
    Key? key,
    required this.items,
    required this.onTap,
    this.initialSelectedIndex = 0,
  }) : super(key: key);

  @override
  State<CustomSelector> createState() => _CustomSelectorState();
}

class _CustomSelectorState extends State<CustomSelector> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  widget.onTap(index);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    gradient: _selectedIndex == index
                        ? AppColors.base_gradient_1
                        : null,
                    color: _selectedIndex == index ? null : AppColors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: CustomTextLabel(
                      widget.items[index],
                      color: _selectedIndex == index ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}