import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/languages/sql.dart';
import 'package:re_highlight/languages/xml.dart';
import 'package:re_highlight/languages/yaml.dart';
import 'package:re_highlight/styles/googlecode.dart';

import '../../generated/icon_keys.g.dart';
import '../../generated/locale_keys.g.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isMonoSpace;
  final bool isJsonFormatted;
  final bool isXMLFormatted;
  final bool isYamlFormatted;
  final bool isSqlFormatted;
  final bool isEditable;
  final bool showLineNumbers;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    this.isMonoSpace = true,
    this.isJsonFormatted = false,
    this.isXMLFormatted = false,
    this.isYamlFormatted = false,
    this.isSqlFormatted = false,
    this.isEditable = true,
    this.showLineNumbers = false,
    this.maxLines,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // re_editor controllers
  late CodeLineEditingController _codeController;
  late CodeScrollController _codeScrollController;
  late CodeFindController _codeFindController;
  late bool _isWordWrapEnabled = true;
  final FocusNode _focusNode = FocusNode();

  // State for manual input formatting
  TextEditingValue _lastValue = TextEditingValue.empty;
  bool _isInternalUpdate = false;

  @override
  void initState() {
    super.initState();

    // 1. Initialize re_editor's controller with the current text
    _codeController =
        CodeLineEditingController.fromText(widget.controller.text);
    _codeFindController = CodeFindController(_codeController);

    // Initialize formatting state with an approximated end-of-file cursor
    _lastValue = TextEditingValue(
      text: widget.controller.text,
      selection: TextSelection.collapsed(offset: widget.controller.text.length),
    );

    // 2. Initialize the scroll controller
    _updateScrollController();

    // 3. Two-way binding: Push re_editor changes to the standard controller
    _codeController.addListener(() {
      if (_isInternalUpdate) return; // Prevent infinite loops during formatting

      String currentText = _codeController.text;
      final currentLines = _codeController.codeLines;

      // Map re_editor's 2D selection to a standard 1D offset for the formatter
      int current1DOffset = _to1DOffset(
        _codeController.selection,
        currentLines.toList(),
      );

      // --- Apply Input Formatters ---
      if (widget.inputFormatters != null &&
          widget.inputFormatters!.isNotEmpty &&
          currentText != _lastValue.text) {
        TextEditingValue newValue = TextEditingValue(
          text: currentText,
          selection: TextSelection.collapsed(offset: current1DOffset),
        );

        // Run through all formatters sequentially
        for (final formatter in widget.inputFormatters!) {
          newValue = formatter.formatEditUpdate(_lastValue, newValue);
        }

        // If the formatter rejected or changed the text, apply it back
        if (newValue.text != currentText) {
          _isInternalUpdate = true;
          _codeController.text = newValue.text; // Update text

          // CRITICAL FIX: Restore/Update the cursor position based on formatter output
          final newLines = _codeController.codeLines.toList();
          _codeController.selection = _to2DSelection(
            newValue.selection.isValid
                ? newValue.selection.baseOffset
                : newValue.text.length,
            newLines,
          );

          currentText = newValue.text;
          _isInternalUpdate = false;
        }

        _lastValue = newValue;
      } else {
        _lastValue = TextEditingValue(
          text: currentText,
          selection: TextSelection.collapsed(offset: current1DOffset),
        );
      }

      // --- Sync out to standard controller ---
      if (widget.controller.text != currentText) {
        widget.controller.text = currentText;
        if (widget.onChanged != null) {
          widget.onChanged!(currentText);
        }
      }
    });

    // 4. Two-way binding: Push standard controller changes to re_editor
    widget.controller.addListener(_syncToCodeController);
  }

  // --- HELPER: Convert 2D re_editor selection to 1D Flutter offset ---
  int _to1DOffset(CodeLineSelection selection, List<CodeLine> lines) {
    int offset = 0;
    for (int i = 0; i < selection.extentIndex; i++) {
      if (i < lines.length) {
        offset +=
            lines[i].text.length + 1; // +1 to account for the newline character
      }
    }
    offset += selection.extentOffset;
    return offset;
  }

  // --- HELPER: Convert 1D Flutter offset to 2D re_editor selection ---
  CodeLineSelection _to2DSelection(int offset, List<CodeLine> lines) {
    if (lines.isEmpty) {
      return const CodeLineSelection(
          baseIndex: 0, baseOffset: 0, extentIndex: 0, extentOffset: 0);
    }

    int currentOffset = 0;
    for (int i = 0; i < lines.length; i++) {
      int lineLength = lines[i].text.length;

      if (offset <= currentOffset + lineLength) {
        final charOffset = offset - currentOffset;
        return CodeLineSelection(
          baseIndex: i,
          baseOffset: charOffset,
          extentIndex: i,
          extentOffset: charOffset,
        );
      }
      currentOffset +=
          lineLength + 1; // +1 to account for the newline character
    }

    // Fallback: If offset is out of bounds, place cursor at the very end
    final lastIndex = lines.length - 1;
    final lastOffset = lines.last.text.length;
    return CodeLineSelection(
      baseIndex: lastIndex,
      baseOffset: lastOffset,
      extentIndex: lastIndex,
      extentOffset: lastOffset,
    );
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the framework swaps the controller (e.g., toggling Encode/Decode)
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_syncToCodeController);
      widget.controller.addListener(_syncToCodeController);
      _syncToCodeController(); // Force sync text
    }
  }

  void _syncToCodeController() {
    if (_codeController.text != widget.controller.text) {
      _isInternalUpdate = true;
      _codeController.text = widget.controller.text;
      _lastValue = TextEditingValue(text: widget.controller.text);
      _isInternalUpdate = false;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_syncToCodeController);
    _codeController.dispose();
    _codeScrollController.dispose();
    _codeFindController.dispose();
    super.dispose();
  }

  void _updateScrollController() {
    _codeScrollController = CodeScrollController(
      verticalScroller: ScrollController(),
      horizontalScroller: _isWordWrapEnabled ? null : ScrollController(),
    );
  }

  void _toggleWordWrap() {
    setState(() {
      _isWordWrapEnabled = !_isWordWrapEnabled;
      _updateScrollController();
    });
  }

  void _toggleSearch() {
    Actions.invoke(_focusNode.context!, const CodeShortcutFindIntent());
  }

  void _selectAll() {
    final lines = _codeController.codeLines;
    if (lines.isEmpty) return;

    _codeController.selection = CodeLineSelection(
      baseIndex: 0,
      baseOffset: 0,
      extentIndex: lines.length - 1,
      extentOffset: lines.last.text.length,
    );
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: _codeController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
    );
  }

  void _paste() async {
    if (!widget.isEditable) return;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      _codeController.text = data.text!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle =
        widget.isMonoSpace ? AppTextStyles.monoStyle() : AppTextStyles.b2;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor.withAlpha(10),
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        color: Colors.transparent,
        boxShadow: AppColors.textfieldShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TOOLBAR
          _toolbar,

          // NATIVE RE_EDITOR INTEGRATION
          Expanded(
            child: CodeEditor(
              focusNode: _focusNode,
              controller: _codeController,
              scrollController: _codeScrollController,
              findController: _codeFindController,
              readOnly: !widget.isEditable,
              style: CodeEditorStyle(
                fontFamily: textStyle.fontFamily,
                codeTheme: CodeHighlightTheme(
                  languages: {
                    if (widget.isJsonFormatted)
                      'json': CodeHighlightThemeMode(mode: langJson),
                    if (widget.isXMLFormatted)
                      'xml': CodeHighlightThemeMode(mode: langXml),
                    if (widget.isYamlFormatted)
                      'yaml': CodeHighlightThemeMode(mode: langYaml),
                    if (widget.isSqlFormatted)
                      'sql': CodeHighlightThemeMode(mode: langSql),
                  },
                  theme: googlecodeTheme,
                ),
              ),
              wordWrap: _isWordWrapEnabled,
              indicatorBuilder: widget.showLineNumbers
                  ? (context, editingController, chunkController, notifier) {
                      return Row(
                        children: [
                          DefaultCodeLineNumber(
                            controller: editingController,
                            notifier: notifier,
                          ),
                          DefaultCodeChunkIndicator(
                            width: 20,
                            controller: chunkController,
                            notifier: notifier,
                          ),
                        ],
                      );
                    }
                  : null,
              findBuilder: (context, controller, readOnly) {
                return CodeFindPanelView(
                  controller: controller,
                  readOnly: readOnly,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget get _toolbar {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        kGapTiny,
        Tooltip(
          message:
              _isWordWrapEnabled ? 'Disable Word Wrap' : 'Enable Word Wrap',
          child: IconButton(
            icon: Icon(
              _isWordWrapEnabled ? Icons.wrap_text : Icons.subject,
              size: 20,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
            ),
            onPressed: _toggleWordWrap,
            splashRadius: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ),
        ToolTipIconButton(
          icon: IconKeys.textfieldSelect,
          tooltip: LocaleKeys.input_tooltip_select_all.localize(),
          onTap: _selectAll,
        ),
        ToolTipIconButton(
          icon: IconKeys.textfieldCopy,
          tooltip: LocaleKeys.input_tooltip_copy.localize(),
          onTap: _copy,
        ),
        if (widget.isEditable)
          ToolTipIconButton(
            icon: IconKeys.textfieldPaste,
            tooltip: LocaleKeys.input_tooltip_paste.localize(),
            onTap: _paste,
          ),
        kGapTiny,
      ],
    );
  }
}
