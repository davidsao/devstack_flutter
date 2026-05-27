import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class XmlFormatterController extends BaseController<XmlFormatterState> {
  final inputController = TextEditingController();
  final outputController = SyntaxHighlightingController(isXml: true);

  @override
  XmlFormatterState initState() => XmlFormatterState();

  @override
  void onClose() {
    inputController.dispose();
    outputController.dispose();
    super.onClose();
  }

  void updateIndent(String indent) {
    state.indentOption.value = indent;
    format();
  }

  // A basic regex-based XML formatter.
  // For production, consider using the `xml` package from pub.dev.
  String _basicXmlFormat(String xml, String indent) {
    String formatted = '';
    int pad = 0;

    // Remove existing whitespace between tags
    final raw = xml.replaceAll(RegExp(r'>\s+<'), '><');

    final tags = raw.split(RegExp(r'(?=<)|(?<=>)'));

    for (var tag in tags) {
      if (tag.trim().isEmpty) continue;

      if (tag.startsWith('</')) {
        pad -= 1;
        formatted += '${List.filled(pad > 0 ? pad : 0, indent).join()}$tag\n';
      } else if (tag.startsWith('<?') || tag.endsWith('/>')) {
        formatted += '${List.filled(pad, indent).join()}$tag\n';
      } else if (tag.startsWith('<')) {
        formatted += '${List.filled(pad, indent).join()}$tag\n';
        pad += 1;
      } else {
        formatted += '${List.filled(pad, indent).join()}$tag\n';
      }
    }
    return formatted.trim();
  }

  void format() {
    final text = inputController.text;
    if (text.isEmpty) {
      outputController.clear();
      return;
    }
    try {
      outputController.text = _basicXmlFormat(text, state.indentOption.value);
    } catch (e) {
      outputController.text = 'Error formatting XML:\n$e';
    }
  }
}

class XmlFormatterState extends ViewState {
  final indentOption = '  '.obs;
}

class XmlFormatterBinding extends AppBindings<XmlFormatterController> {
  XmlFormatterBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return XmlFormatterController();
  }
}
