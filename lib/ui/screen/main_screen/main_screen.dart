import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/ui/screen/main_screen/account_screen.dart';
import 'package:ottstudy/ui/screen/main_screen/explore_screen.dart';
import 'package:ottstudy/ui/screen/main_screen/chart_screen.dart';
import 'package:ottstudy/ui/widget/base_screen.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import '../../../blocs/base_bloc/navigation_tab_state.dart';
import '../../../blocs/navigation_tab_cubit.dart';
import '../../../res/colors.dart';
import 'home_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationTabCubit(),
      child: MainBody(),
    );
  }
}

class MainBody extends StatefulWidget {
  @override
  State<MainBody> createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  final List<IconData> _iconList = [
    Icons.home_rounded,
    Icons.explore_rounded,
    Icons.bar_chart_rounded,
    Icons.account_circle_rounded,
  ];

  final List<Widget> _pages = [
    HomeScreen(),
    ExploreScreen(),
    ChartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationTabCubit, NavigationTabState>(
      builder: (context, state) {
        return BaseScreen(
          hideAppBar: true,
          body: _pages[state.index],
          bottomBar: AnimatedBottomNavigationBar.builder(
            itemCount: _iconList.length,
            tabBuilder: (int index, bool isActive) {
              return Icon(
                _iconList[index],
                size: isActive ? 35 : 24,
                color: isActive ? AppColors.black : Colors.grey,
              );
            },
            activeIndex: state.index,
            gapLocation: GapLocation.none,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            onTap: (index) => context.read<NavigationTabCubit>().changeIndex(index),
            shadow: BoxShadow(
              offset: Offset(0, -2),
              blurRadius: 8,
              color: Colors.black.withOpacity(0.1),
            ),
            backgroundColor: Colors.white,
          ),
        );
      },
    );
  }
}