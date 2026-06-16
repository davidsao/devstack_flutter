import 'package:devstack/index.dart';
import 'package:flutter/material.dart';

class MainAlertWidget extends StatelessWidget {
  final GlobalKey globalKey;
  final GlobalKey textKey;
  final AlertHelper alertHelper;
  const MainAlertWidget({
    super.key,
    required this.globalKey,
    required this.textKey,
    required this.alertHelper,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Opacity(
        opacity: 1.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400, minWidth: 100),
          key: globalKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 5.0,
              vertical: 10.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Icon(alertHelper.icon, size: 25.0),
                ),
                Flexible(child: Text(key: textKey, alertHelper.text)),
                if (alertHelper.action == null) const SizedBox(width: 10),
                if (alertHelper.action != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 3, right: 2),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 120,
                        maxHeight: 45,
                      ),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(alertHelper.action!),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
