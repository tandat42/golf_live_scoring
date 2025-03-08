import 'package:flutter/material.dart';

class ContentContainer extends StatelessWidget {
  const ContentContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 494),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    );
  }
}
