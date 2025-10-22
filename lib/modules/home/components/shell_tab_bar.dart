import 'package:flutter/material.dart';

import '../../../support/styles/app_colors.dart';

class ShellTabBar extends StatelessWidget {
  final void Function(int index) onTap;

  const ShellTabBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gray30),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: TabBar(
        dividerHeight: 0,
        onTap: onTap,
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: AppColors.lightGray,
        indicator: const BoxDecoration(
          color: AppColors.gray30,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        tabs: const [
          Tab(child: Text('Vou dirigir')),
          Tab(child: Text('Quero carona')),
        ],
      ),
    );
  }
}
