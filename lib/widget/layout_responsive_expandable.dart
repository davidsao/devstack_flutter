import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

class ResponsiveExpandableLayout extends StatefulWidget {
  final List<Widget> firstChildren;
  final List<Widget> secondChildren;
  final int firstFlex;
  final int secondFlex;
  final double breakpoint;

  final String expandTitle;
  final IconData expandIcon;

  const ResponsiveExpandableLayout({
    super.key,
    required this.firstChildren,
    required this.secondChildren,
    required this.expandTitle,
    required this.expandIcon,
    this.firstFlex = 1,
    this.secondFlex = 1,
    this.breakpoint = 800.0,
  });

  @override
  State<ResponsiveExpandableLayout> createState() =>
      _ResponsiveExpandableLayoutState();
}

class _ResponsiveExpandableLayoutState
    extends State<ResponsiveExpandableLayout> {
  bool _isExpanded = false;

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= widget.breakpoint;

        if (isDesktop) {
          return Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: widget.firstFlex,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.firstChildren,
                ),
              ),
              kGapSmall,
              Expanded(
                flex: widget.secondFlex,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.secondChildren,
                ),
              ),
            ],
          );
        }

        // MOBILE LAYOUT: Expandable Bottom Sheet
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: _isExpanded ? 0 : 56,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.firstChildren,
              ),
            ),
            if (_isExpanded)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _toggleExpand,
                  child: Container(color: Colors.black.withOpacity(0.5)),
                ),
              ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuint,
              bottom: 0,
              left: 0,
              right: 0,
              height: _isExpanded
                  ? constraints.maxHeight * 0.8
                  : 56, // Also use constraints here!
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: _toggleExpand,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Icon(widget.expandIcon,
                                color: Theme.of(context).colorScheme.primary),
                            kGapSmall,
                            Text(widget.expandTitle,
                                style: AppTextStyles.b2.bold),
                            const Spacer(),
                            Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              color: AppColors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_isExpanded)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16)
                              .copyWith(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: widget.secondChildren,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
