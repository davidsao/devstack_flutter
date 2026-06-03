import 'dart:async'; // Required for the typing debounce Timer

import 'package:devstack/generated/icon_keys.g.dart';
import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/markdown.dart';
import 'package:re_highlight/styles/googlecode.dart';

import '../../generated/locale_keys.g.dart';

const Map<String, String> _emojiMap = {
  'smile': '😄',
  'heart': '❤️',
  'thumbsup': '👍',
  'rocket': '🚀',
  'fire': '🔥',
  'star': '⭐',
  'warning': '⚠️',
  'check': '✅',
};

// --- NEW: A helper class to store text states for our Undo/Redo stack ---
class _EditorHistory {
  final String text;
  final CodeLineSelection selection;
  _EditorHistory(this.text, this.selection);
}

class MarkdownEditorField extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const MarkdownEditorField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  State<MarkdownEditorField> createState() => _MarkdownEditorFieldState();
}

class _MarkdownEditorFieldState extends State<MarkdownEditorField> {
  late CodeLineEditingController _codeController;
  late CodeScrollController _codeScrollController;
  late CodeFindController _codeFindController;
  final FocusNode _focusNode = FocusNode();
  bool _isWordWrapEnabled = true;
  bool _isInternalUpdate = false;

  // --- NEW: State variables for Undo/Redo ---
  final List<_EditorHistory> _undoStack = [];
  final List<_EditorHistory> _redoStack = [];
  String _lastSavedText = '';
  CodeLineSelection _lastSavedSelection = const CodeLineSelection.zero();
  Timer? _typingTimer;

  @override
  void initState() {
    super.initState();
    _codeController =
        CodeLineEditingController.fromText(widget.controller.text);
    _codeFindController = CodeFindController(_codeController);
    _codeScrollController = CodeScrollController(
      verticalScroller: ScrollController(),
      horizontalScroller: null,
    );

    // Initialize baseline history
    _lastSavedText = widget.controller.text;
    _lastSavedSelection = _codeController.selection;

    _codeController.addListener(_onEditorTextChanged);
    widget.controller.addListener(_syncToCodeController);
  }

  // ==========================================
  // UNDO / REDO LOGIC
  // ==========================================

  void _pushHistory(String text, CodeLineSelection selection) {
    _undoStack.add(_EditorHistory(text, selection));
    if (_undoStack.length > 50) _undoStack.removeAt(0); // Max 50 undos
    _redoStack.clear();
    if (mounted) setState(() {}); // Refresh button colors
  }

  void _commitTypingHistory() {
    if (_lastSavedText != _codeController.text) {
      _pushHistory(_lastSavedText, _lastSavedSelection);
      _lastSavedText = _codeController.text;
      _lastSavedSelection = _codeController.selection;
    }
  }

  // Call this specifically BEFORE formatting actions
  void _prepareForFormatAction() {
    _typingTimer?.cancel();
    _commitTypingHistory();
  }

  void _undo() {
    _typingTimer?.cancel();
    if (_undoStack.isEmpty) return;

    _redoStack
        .add(_EditorHistory(_codeController.text, _codeController.selection));
    final prev = _undoStack.removeLast();

    _isInternalUpdate = true;
    _codeController.text = prev.text;
    _codeController.selection = prev.selection;
    _isInternalUpdate = false;

    _lastSavedText = prev.text;
    _lastSavedSelection = prev.selection;

    _onEditorTextChanged();
    setState(() {}); // Refresh button colors
    _focusNode.requestFocus();
  }

  void _redo() {
    _typingTimer?.cancel();
    if (_redoStack.isEmpty) return;

    _undoStack
        .add(_EditorHistory(_codeController.text, _codeController.selection));
    final next = _redoStack.removeLast();

    _isInternalUpdate = true;
    _codeController.text = next.text;
    _codeController.selection = next.selection;
    _isInternalUpdate = false;

    _lastSavedText = next.text;
    _lastSavedSelection = next.selection;

    _onEditorTextChanged();
    setState(() {}); // Refresh button colors
    _focusNode.requestFocus();
  }

  // ==========================================
  // CORE EDITOR LOGIC
  // ==========================================

  void _onEditorTextChanged() {
    if (_isInternalUpdate) return;
    String currentText = _codeController.text;

    // --- 1. Auto-Convert Emojis ---
    bool textModified = false;
    final emojiRegex = RegExp(r':([a-z_]+):');

    if (emojiRegex.hasMatch(currentText)) {
      currentText = currentText.replaceAllMapped(emojiRegex, (match) {
        final shortcode = match.group(1);
        if (_emojiMap.containsKey(shortcode)) {
          textModified = true;
          return _emojiMap[shortcode]!;
        }
        return match.group(0)!;
      });
    }

    if (textModified) {
      _prepareForFormatAction();
      _isInternalUpdate = true;
      _codeController.text = currentText;
      _isInternalUpdate = false;

      _lastSavedText = currentText;
      _lastSavedSelection = _codeController.selection;
      if (mounted) setState(() {});
    } else {
      // --- 2. Track standard typing for Undo History ---
      // If length changed drastically (e.g. Paste), commit immediately
      if ((currentText.length - _lastSavedText.length).abs() > 1) {
        _commitTypingHistory();
      } else {
        // Debounce normal character-by-character typing
        _typingTimer?.cancel();
        _typingTimer = Timer(const Duration(milliseconds: 800), () {
          if (mounted) _commitTypingHistory();
        });
      }
    }

    // --- 3. Sync to parent controller ---
    if (widget.controller.text != currentText) {
      widget.controller.text = currentText;
      if (widget.onChanged != null) widget.onChanged!(currentText);
    }
  }

  void _syncToCodeController() {
    if (_codeController.text != widget.controller.text) {
      _isInternalUpdate = true;
      _codeController.text = widget.controller.text;
      _isInternalUpdate = false;
    }
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    widget.controller.removeListener(_syncToCodeController);
    _codeController.dispose();
    _codeScrollController.dispose();
    _codeFindController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  int _to1DOffset(CodeLineSelection selection, List<CodeLine> lines) {
    int offset = 0;
    for (int i = 0; i < selection.extentIndex; i++) {
      if (i < lines.length) offset += lines[i].text.length + 1;
    }
    return offset + selection.extentOffset;
  }

  CodeLineSelection _to2DSelection(int offset, List<CodeLine> lines) {
    if (lines.isEmpty) return const CodeLineSelection.zero();
    int currentOffset = 0;
    for (int i = 0; i < lines.length; i++) {
      int lineLength = lines[i].text.length;
      if (offset <= currentOffset + lineLength) {
        final charOffset = offset - currentOffset;
        return CodeLineSelection(
            baseIndex: i,
            baseOffset: charOffset,
            extentIndex: i,
            extentOffset: charOffset);
      }
      currentOffset += lineLength + 1;
    }
    return CodeLineSelection(
      baseIndex: lines.length - 1,
      baseOffset: lines.last.text.length,
      extentIndex: lines.length - 1,
      extentOffset: lines.last.text.length,
    );
  }

  void _wrapSelection(String prefix, [String? suffix]) {
    _prepareForFormatAction(); // Snapshot history before injection
    suffix ??= prefix;
    final lines = _codeController.codeLines.toList();

    CodeLineSelection sel = _codeController.selection;
    int startOffset = _to1DOffset(
        CodeLineSelection(
            baseIndex: sel.baseIndex,
            baseOffset: sel.baseOffset,
            extentIndex: sel.baseIndex,
            extentOffset: sel.baseOffset),
        lines);
    int endOffset = _to1DOffset(sel, lines);

    if (startOffset > endOffset) {
      int temp = startOffset;
      startOffset = endOffset;
      endOffset = temp;
    }

    String fullText = _codeController.text;
    String before = fullText.substring(0, startOffset);
    String selected = fullText.substring(startOffset, endOffset);
    String after = fullText.substring(endOffset);

    if (selected.isEmpty) selected = "text";

    String newText = "$before$prefix$selected$suffix$after";

    _isInternalUpdate = true;
    _codeController.text = newText;
    _codeController.selection = _to2DSelection(
        startOffset + prefix.length + selected.length,
        _codeController.codeLines.toList());
    _isInternalUpdate = false;

    _onEditorTextChanged();
    _lastSavedText = _codeController.text;
    _lastSavedSelection = _codeController.selection;
    if (mounted) setState(() {});

    _focusNode.requestFocus();
  }

  void _prefixMultiline(String prefix) {
    _prepareForFormatAction(); // Snapshot history before injection
    final lines = _codeController.codeLines.toList();
    int startLine = _codeController.selection.baseIndex;
    int endLine = _codeController.selection.extentIndex;

    if (startLine > endLine) {
      int temp = startLine;
      startLine = endLine;
      endLine = temp;
    }

    StringBuffer sb = StringBuffer();
    for (int i = 0; i < lines.length; i++) {
      if (i >= startLine && i <= endLine) sb.write("$prefix ");
      sb.write(lines[i].text);
      if (i < lines.length - 1) sb.write('\n');
    }

    _isInternalUpdate = true;
    _codeController.text = sb.toString();
    _codeController.selection = _to2DSelection(
        _to1DOffset(
                _codeController.selection, _codeController.codeLines.toList()) +
            prefix.length +
            1,
        _codeController.codeLines.toList());
    _isInternalUpdate = false;

    _onEditorTextChanged();
    _lastSavedText = _codeController.text;
    _lastSavedSelection = _codeController.selection;
    if (mounted) setState(() {});

    _focusNode.requestFocus();
  }

  void _insertLink() => _wrapSelection("[", "](url)");
  void _insertCodeBlock() => _wrapSelection("\n```\n", "\n```\n");

  @override
  Widget build(BuildContext context) {
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
          _buildToolbar(),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: CodeEditor(
              focusNode: _focusNode,
              controller: _codeController,
              scrollController: _codeScrollController,
              findController: _codeFindController,
              wordWrap: _isWordWrapEnabled,
              style: CodeEditorStyle(
                fontFamily: AppTextStyles.monoStyle().fontFamily,
                codeTheme: CodeHighlightTheme(
                  languages: {
                    'markdown': CodeHighlightThemeMode(mode: langMarkdown)
                  },
                  theme: googlecodeTheme,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Padding(
      // --- NEW: Using Wrap instead of SingleChildScrollView/Row ---
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Wrap(
        spacing: 2, // horizontal gap between items
        runSpacing: 4, // vertical gap if wrapped to next line
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _ToolbarBtn(
              icon: IconKeys.undo,
              tooltip: LocaleKeys.lbl_markdown_undo.localize(),
              // Pass null if empty to disable the button
              onTap: _undoStack.isNotEmpty ? _undo : null),
          _ToolbarBtn(
              icon: IconKeys.redo,
              tooltip: LocaleKeys.lbl_markdown_redo.localize(),
              // Pass null if empty to disable the button
              onTap: _redoStack.isNotEmpty ? _redo : null),
          const _Divider(),
          _ToolbarBtn(
              icon: IconKeys.textBold,
              tooltip: LocaleKeys.lbl_markdown_bold.localize(),
              onTap: () => _wrapSelection("**")),
          _ToolbarBtn(
              icon: IconKeys.textItalic,
              tooltip: LocaleKeys.lbl_markdown_italic.localize(),
              onTap: () => _wrapSelection("*")),
          _ToolbarBtn(
              icon: IconKeys.textStrikethrough,
              tooltip: LocaleKeys.lbl_markdown_strikethrough.localize(),
              onTap: () => _wrapSelection("~~")),
          const _Divider(),
          _ToolbarBtn(
              icon: IconKeys.codeInline,
              tooltip: LocaleKeys.lbl_markdown_inline_code.localize(),
              onTap: () => _wrapSelection("`")),
          _ToolbarBtn(
              icon: IconKeys.codeBlock,
              tooltip: LocaleKeys.lbl_markdown_code_block.localize(),
              onTap: _insertCodeBlock),
          _ToolbarBtn(
              icon: IconKeys.textUrl,
              tooltip: LocaleKeys.lbl_markdown_link.localize(),
              onTap: _insertLink),
          const _Divider(),
          _ToolbarBtn(
              icon: IconKeys.h1,
              tooltip: LocaleKeys.lbl_markdown_h1.localize(),
              onTap: () => _prefixMultiline("#")),
          _ToolbarBtn(
              icon: IconKeys.h2,
              tooltip: LocaleKeys.lbl_markdown_h2.localize(),
              onTap: () => _prefixMultiline("##")),
          _ToolbarBtn(
              icon: IconKeys.h3,
              tooltip: LocaleKeys.lbl_markdown_h3.localize(),
              onTap: () => _prefixMultiline("###")),
          const _Divider(),
          _ToolbarBtn(
              icon: IconKeys.quote,
              tooltip: LocaleKeys.lbl_markdown_quote.localize(),
              onTap: () => _prefixMultiline(">")),
          _ToolbarBtn(
              icon: IconKeys.unorderedList,
              tooltip: LocaleKeys.lbl_markdown_list.localize(),
              onTap: () => _prefixMultiline("-")),
          _ToolbarBtn(
              icon: IconKeys.checklist,
              tooltip: LocaleKeys.lbl_markdown_task.localize(),
              onTap: () => _prefixMultiline("- [ ]")),
          const _Divider(),
          _ToolbarBtn(
            // icon: _isWordWrapEnabled ? IconKeys.textWrap : Icons.subject,
            icon: IconKeys.textWrap,
            tooltip: LocaleKeys.lbl_markdown_wrap.localize(),
            onTap: () {
              setState(() => _isWordWrapEnabled = !_isWordWrapEnabled);
              _codeScrollController = CodeScrollController(
                  verticalScroller: ScrollController(),
                  horizontalScroller:
                      _isWordWrapEnabled ? null : ScrollController());
            },
          ),
        ],
      ),
    );
  }
}

class _ToolbarBtn extends StatelessWidget {
  final String icon;
  final String tooltip;
  final VoidCallback? onTap; // Nullable to support disabled state

  const _ToolbarBtn(
      {required this.icon, required this.tooltip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppImage(
            icon,
            size: 16,
            // Dim the icon if the action is currently disabled (e.g. empty undo stack)
            color: isDisabled
                ? Theme.of(context).disabledColor
                : Theme.of(context).iconTheme.color,
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: Theme.of(context).dividerColor.withAlpha(50),
    );
  }
}
