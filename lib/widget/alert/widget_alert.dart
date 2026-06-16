import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

class AlertInfoWidget extends StatefulWidget {
  final VoidCallback onDismissed;
  final AlertHelper alertHelper;

  const AlertInfoWidget({
    super.key,
    required this.onDismissed,
    required this.alertHelper,
  });

  @override
  State<AlertInfoWidget> createState() => _AlertInfoWidgetState();
}

class _AlertInfoWidgetState extends State<AlertInfoWidget>
    with TickerProviderStateMixin {
  final GlobalKey _globalKey = GlobalKey();
  final GlobalKey _textKey = GlobalKey();
  bool isInnited = false;
  late double finalHeight;
  late double finalWidth;
  late double textWidth;
  late double textHeight;
  bool _isDissmissed = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward();
      Future.delayed(Duration(seconds: widget.alertHelper.duration)).then((_) {
        if (mounted && !_isDissmissed) {
          _controller.reverse();
        }
      });
    } on TickerCanceled {
      //Ticker canceled
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInnited) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        finalHeight = _globalKey.currentContext!.size!.height;
        finalWidth = _globalKey.currentContext!.size!.width;
        textWidth = _textKey.currentContext!.size!.width;
        textHeight = _textKey.currentContext!.size!.height;
        _playAnimation();
        setState(() {
          isInnited = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isInnited)
          Positioned(
            top: -widget.alertHelper.maxWidth,
            child: MainAlertWidget(
              globalKey: _globalKey,
              textKey: _textKey,
              alertHelper: widget.alertHelper,
            ),
          ),
        if (isInnited)
          AlertInfoAnimated(
            alertHelper: widget.alertHelper,
            controller: _controller.view,
            finalWidth: finalWidth,
            finalHeight: finalHeight,
            textWidth: textWidth,
            textHeight: textHeight,
            onDismissed: () {
              _isDissmissed = true;
              _controller.stop();
              widget.onDismissed();
            },
          ),
      ],
    );
  }
}
