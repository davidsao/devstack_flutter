import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

class ResponsiveSplitLayout extends StatelessWidget {
  final List<Widget> firstChildren;
  final List<Widget> secondChildren;
  final int firstFlex;
  final int secondFlex;
  final bool secondChildrenScrollable;
  final double breakpoint;

  const ResponsiveSplitLayout({
    super.key,
    required this.firstChildren,
    required this.secondChildren,
    this.firstFlex = 1,
    this.secondFlex = 1,
    this.secondChildrenScrollable = false,
    this.breakpoint = 1024.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= breakpoint;

    // Build the core column for the second children list
    Widget secondContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: secondChildren,
    );

    // IMPLEMENTATION: If true, wrap the column in a scroll container
    if (secondChildrenScrollable) {
      secondContent = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: secondContent,
      );
    }

    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // LEFT / TOP PANEL
        Expanded(
          flex: firstFlex,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: firstChildren,
          ),
        ),

        // Dynamic adaptive spacing between the two panels
        kGapSmall,

        // RIGHT / BOTTOM PANEL
        Expanded(
          flex: secondFlex,
          child: secondContent,
        ),
      ],
    );
  }
}
