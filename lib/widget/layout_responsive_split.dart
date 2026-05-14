import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class ResponsiveSplitLayout extends StatelessWidget {
  final List<Widget> firstChildren;
  final List<Widget> secondChildren;
  final int firstFlex;
  final int secondFlex;
  final double breakpoint;

  const ResponsiveSplitLayout({
    super.key,
    required this.firstChildren,
    required this.secondChildren,
    this.firstFlex = 1,
    this.secondFlex = 1,
    this.breakpoint = 1024.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= breakpoint;

    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      // Stretch ensures the columns fill the available cross-axis space
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: firstFlex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: firstChildren,
          ),
        ),
        // Gap between the two sections
        kGapSmall,
        Expanded(
          flex: secondFlex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: secondChildren,
          ),
        ),
      ],
    );
  }
}
