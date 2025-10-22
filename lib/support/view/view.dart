import 'dart:async';

import 'package:flutter/material.dart';

import '../dependencies/dependency_container.dart';
import 'view_model.dart';

export 'package:flutter/material.dart';

abstract class View<T extends ViewModel> extends StatefulWidget {
  final T viewModel;

  const View({super.key, required this.viewModel});

  void initState() {
    /* override in subclass */
  }

  void dispose() {
    /* override in subclass */
  }

  Widget build(BuildContext context);

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.setContext(context);
    widget.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.dispose();
    unawaited(container.unregister(widget.viewModel));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.viewModel,
      builder: (_, _) {
        return widget.build(context);
      },
    );
  }
}
