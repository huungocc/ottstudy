import 'package:flutter/material.dart';
import 'package:ottstudy/ui/widget/custom_text_label.dart';

import '../../res/colors.dart';

class SelectorItem {
  final String id;
  final String name;

  SelectorItem({required this.id, required this.name});
}

class CustomSelector extends StatefulWidget {
  final List<SelectorItem> items;
  final Function(String id, int index) onTap;
  final int initialSelectedIndex;
  final Gradient? selectedColor;
  final int maxItemsForStretch;

  const CustomSelector({
    Key? key,
    required this.items,
    required this.onTap,
    this.initialSelectedIndex = 0,
    this.selectedColor = AppColors.base_gradient_1,
    this.maxItemsForStretch = 2,
  }) : super(key: key);

  @override
  State<CustomSelector> createState() => _CustomSelectorState();
}

class _CustomSelectorState extends State<CustomSelector> {
  late int _selectedIndex;
  late List<SelectorItem> _displayItems;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
    _setupDisplayItems();
  }

  void _setupDisplayItems() {
    _displayItems = [];
    _displayItems.addAll(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 50,
        child: _displayItems.length <= widget.maxItemsForStretch
            ? _buildExpandedRow()
            : _buildScrollableList(),
      ),
    );
  }

  // Build Row với Expanded widgets để kéo căng đều
  Widget _buildExpandedRow() {
    return Row(
      children: List.generate(_displayItems.length, (index) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: index < _displayItems.length - 1 ? 12.0 : 0,
            ),
            child: _buildSelectorItem(index),
          ),
        );
      }),
    );
  }

  // Build ListView cho trường hợp cần cuộn
  Widget _buildScrollableList() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _displayItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: _buildSelectorItem(index),
        );
      },
    );
  }

  // Build item selector chung
  Widget _buildSelectorItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onTap(_displayItems[index].id, index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          gradient: _selectedIndex == index ? widget.selectedColor : null,
          color: _selectedIndex == index ? null : AppColors.white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: CustomTextLabel(
            _displayItems[index].name,
            color: _selectedIndex == index ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}