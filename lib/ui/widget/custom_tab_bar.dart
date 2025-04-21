import 'package:flutter/material.dart';

import '../../res/colors.dart';

class CustomTabBar extends StatefulWidget {
  final List<CustomTab> tabs;
  final List<Widget> views;
  final Color? unselectedLabelColor;
  final Color? selectedLabelColor;
  final Color? indicatorColor;
  final Color? backgroundColor;
  final double? indicatorWeight;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool? isScrollable;
  final int initialIndex;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.views,
    this.unselectedLabelColor,
    this.selectedLabelColor,
    this.indicatorColor,
    this.backgroundColor,
    this.indicatorWeight = 2.0,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.isScrollable,
    this.initialIndex = 0
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this, initialIndex: widget.initialIndex);
  }

  @override
  void didUpdateWidget(CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      _tabController.index = widget.initialIndex;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: widget.backgroundColor ?? AppColors.base_color,
          child: TabBar(
            controller: _tabController,
            tabs: widget.tabs
                .map((tab) => Tab(
                      icon: (tab.icon != null) ? Icon(tab.icon) : null,
                      text: tab.label,
                    ))
                .toList(),
            unselectedLabelColor: widget.unselectedLabelColor,
            labelColor: widget.selectedLabelColor,
            labelStyle: widget.labelStyle,
            unselectedLabelStyle: widget.unselectedLabelStyle,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: widget.indicatorColor ?? AppColors.base_color,
                width: widget.indicatorWeight ?? 10,
              ),
              insets: EdgeInsets.symmetric(horizontal: 150 / widget.tabs.length),
            ),
            isScrollable: widget.isScrollable ?? false,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.views,
          ),
        ),
      ],
    );
  }
}

// Custom Tab Item
class CustomTab {
  final IconData? icon; // Allow icon to be null
  final String label;

  const CustomTab({this.icon, required this.label});
}
