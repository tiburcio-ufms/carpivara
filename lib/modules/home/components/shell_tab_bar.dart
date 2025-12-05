import 'package:flutter/material.dart';

import '../../../support/styles/app_colors.dart';

class ShellTabBar extends StatelessWidget {
  const ShellTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray30),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: const TabBar(
        dividerHeight: 0,
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: AppColors.lightGray,
        indicator: BoxDecoration(
          color: AppColors.gray30,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        tabs: [
          Tab(child: Text('Vou dirigir')),
          Tab(child: Text('Quero carona')),
        ],
      ),
    );
  }
}
