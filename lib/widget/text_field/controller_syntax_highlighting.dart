import 'package:flutter/material.dart';

class SyntaxHighlightingController extends TextEditingController {
  final bool isJson;
  final bool isXml;

  SyntaxHighlightingController(
      {this.isJson = false, this.isXml = false, super.text});

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    if (!isJson && !isXml) {
      return super.buildTextSpan(
          context: context, style: style, withComposing: withComposing);
    }

    List<TextSpan> spans = [];
    String source = text;

    // A very basic JSON/XML Regex Pattern
    // For a production app, consider using the 'flutter_code_editor' package.
    RegExp exp;
    if (isJson) {
      // Matches JSON strings, numbers, booleans, and null
      exp = RegExp(r'(".*?"|\btrue\b|\bfalse\b|\bnull\b|\b\d+\b)');
    } else {
      // Matches XML tags and attributes
      exp = RegExp(r'(<[^>]+>|".*?")');
    }

    int start = 0;
    for (final match in exp.allMatches(source)) {
      if (match.start > start) {
        spans.add(
            TextSpan(text: source.substring(start, match.start), style: style));
      }

      final String matchText = match.group(0)!;
      Color color = Colors.blueAccent; // Default color for matches

      if (isJson) {
        if (matchText.startsWith('"'))
          color = Colors.green; // Strings
        else if (matchText == 'true' || matchText == 'false')
          color = Colors.orange; // Booleans
        else if (matchText == 'null')
          color = Colors.red; // Null
        else
          color = Colors.purpleAccent; // Numbers
      } else if (isXml) {
        if (matchText.startsWith('<'))
          color = Colors.blue; // Tags
        else if (matchText.startsWith('"')) color = Colors.green; // Attributes
      }

      spans.add(TextSpan(
        text: matchText,
        style: style?.copyWith(color: color, fontWeight: FontWeight.bold),
      ));

      start = match.end;
    }

    if (start < source.length) {
      spans.add(TextSpan(text: source.substring(start), style: style));
    }

    return TextSpan(children: spans, style: style);
  }
}
