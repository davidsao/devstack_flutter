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
    this.breakpoint = 800.0,
  });

  @override
  Widget build(BuildContext context) {
    // Keep MediaQuery ONLY for the keyboard inset
    final isKeyboardVisible = MediaQuery.viewInsetsOf(context).bottom > 0;

    // Build the core column for the second children list
    Widget secondContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: secondChildren,
    );

    if (secondChildrenScrollable) {
      secondContent = SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: secondContent,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= breakpoint;

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

            // Hide the bottom panel on mobile when the keyboard is open.
            if (isDesktop || !isKeyboardVisible) ...[
              kGapSmall,
              // RIGHT / BOTTOM PANEL
              Expanded(
                flex: secondFlex,
                child: secondContent,
              ),
            ],
          ],
        );
      },
    );
  }
}
