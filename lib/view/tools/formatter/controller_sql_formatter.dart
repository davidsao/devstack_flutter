import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';

class SqlFormatterController extends BaseController<SqlFormatterState> {
  final inputController = TextEditingController();
  final outputController = TextEditingController();

  @override
  SqlFormatterState initState() => SqlFormatterState();

  @override
  void onClose() {
    inputController.dispose();
    outputController.dispose();
    super.onClose();
  }

  // A rudimentary SQL formatter.
  // For robust, dialect-aware formatting, consider adding the `sql_formatter` package.
  String _basicSqlFormat(String sql) {
    String formatted = sql.replaceAll(RegExp(r'\s+'), ' '); // Normalize spaces

    final keywords = [
      'SELECT',
      'FROM',
      'WHERE',
      'AND',
      'OR',
      'ORDER BY',
      'GROUP BY',
      'HAVING',
      'LIMIT',
      'JOIN',
      'LEFT JOIN',
      'RIGHT JOIN',
      'INNER JOIN',
      'INSERT INTO',
      'VALUES',
      'UPDATE',
      'SET'
    ];

    for (var keyword in keywords) {
      // Add newlines before major keywords and capitalize them
      formatted = formatted.replaceAllMapped(
          RegExp('\\b$keyword\\b', caseSensitive: false),
          (match) => '\n${match.group(0)!.toUpperCase()}');
    }

    // Clean up extra leading newlines
    return formatted.trim();
  }

  void format() {
    final text = inputController.text;
    if (text.isEmpty) {
      outputController.clear();
      return;
    }
    try {
      outputController.text = _basicSqlFormat(text);
    } catch (e) {
      outputController.text = 'Error formatting SQL:\n$e';
    }
  }
}

class SqlFormatterState extends ViewState {}

class SqlFormatterBinding extends AppBindings<SqlFormatterController> {
  SqlFormatterBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return SqlFormatterController();
  }
}
