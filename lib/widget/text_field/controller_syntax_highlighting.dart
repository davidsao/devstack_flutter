import 'package:flutter/material.dart';

class SyntaxHighlightingController extends TextEditingController {
  final bool isJson;
  final bool isXml;

  String _searchQuery = '';
  int _activeMatchIndex = -1;
  int _internalMatchCounter =
      0; // Tracks occurrence index during the paint cycle

  SyntaxHighlightingController(
      {this.isJson = false, this.isXml = false, super.text});

  // Updated to receive both the query and the currently active index
  void updateSearch(String query, int activeIndex) {
    if (_searchQuery != query || _activeMatchIndex != activeIndex) {
      _searchQuery = query;
      _activeMatchIndex = activeIndex;
      notifyListeners(); // Triggers a repaint
    }
  }

  // Helper method to inject search highlights
  List<TextSpan> _parseSearch(String textPart, TextStyle? baseStyle) {
    if (_searchQuery.isEmpty)
      return [TextSpan(text: textPart, style: baseStyle)];

    List<TextSpan> result = [];
    int start = 0;
    final searchExp = RegExp(RegExp.escape(_searchQuery), caseSensitive: false);

    for (final match in searchExp.allMatches(textPart)) {
      if (match.start > start) {
        result.add(TextSpan(
            text: textPart.substring(start, match.start), style: baseStyle));
      }

      // Determine if this specific regex match is the active one in the UI
      bool isActiveMatch = _internalMatchCounter == _activeMatchIndex;

      result.add(TextSpan(
        text: match.group(0),
        style: baseStyle?.copyWith(
              backgroundColor:
                  isActiveMatch ? Colors.orange : Colors.yellowAccent,
              color: Colors.black, // High contrast text for readability
            ) ??
            TextStyle(
                backgroundColor:
                    isActiveMatch ? Colors.orange : Colors.yellowAccent,
                color: Colors.black),
      ));

      _internalMatchCounter++;
      start = match.end;
    }

    if (start < textPart.length) {
      result.add(TextSpan(text: textPart.substring(start), style: baseStyle));
    }

    return result;
  }

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    // Reset the counter at the start of every text render pass
    _internalMatchCounter = 0;

    if (!isJson && !isXml && _searchQuery.isEmpty) {
      return super.buildTextSpan(
          context: context, style: style, withComposing: withComposing);
    }

    List<TextSpan> spans = [];
    String source = text;

    if (!isJson && !isXml) {
      return TextSpan(children: _parseSearch(source, style), style: style);
    }

    RegExp exp;
    if (isJson) {
      exp = RegExp(r'(".*?"|\btrue\b|\bfalse\b|\bnull\b|\b\d+\b)');
    } else {
      exp = RegExp(r'(<[^>]+>|".*?")');
    }

    int start = 0;
    for (final match in exp.allMatches(source)) {
      if (match.start > start) {
        spans.addAll(_parseSearch(source.substring(start, match.start), style));
      }

      final String matchText = match.group(0)!;
      Color color = Colors.blueAccent;

      if (isJson) {
        if (matchText.startsWith('"')) {
          color = Colors.green;
        } else if (matchText == 'true' || matchText == 'false') {
          color = Colors.orangeAccent;
        } else if (matchText == 'null') {
          color = Colors.red;
        } else {
          color = Colors.purpleAccent;
        }
      } else if (isXml) {
        if (matchText.startsWith('<')) {
          color = Colors.blue;
        } else if (matchText.startsWith('"')) {
          color = Colors.green;
        }
      }

      spans.addAll(_parseSearch(
        matchText,
        style?.copyWith(color: color, fontWeight: FontWeight.bold) ??
            TextStyle(color: color, fontWeight: FontWeight.bold),
      ));

      start = match.end;
    }

    if (start < source.length) {
      spans.addAll(_parseSearch(source.substring(start), style));
    }

    return TextSpan(children: spans, style: style);
  }
}
