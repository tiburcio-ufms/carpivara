import 'package:flutter/material.dart';

class DefaultScroll extends StatelessWidget {
  final Widget child;

  const DefaultScroll({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            child: child,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ],
    );
  }
}
