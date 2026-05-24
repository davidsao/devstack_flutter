import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:re_editor/re_editor.dart';
import 'package:re_highlight/languages/json.dart';
import 'package:re_highlight/styles/googlecode.dart';

import '../../generated/icon_keys.g.dart';
import '../../generated/locale_keys.g.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isMonoSpace;
  final bool isJsonFormatted;
  final bool isXMLFormatted;
  final bool isEditable;
  final bool isSearchable;
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
    this.isEditable = true,
    this.isSearchable = true,
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

  @override
  void initState() {
    super.initState();

    // 1. Initialize re_editor's controller with the current text
    _codeController =
        CodeLineEditingController.fromText(widget.controller.text);

    _codeFindController = CodeFindController(_codeController);

    // 2. Initialize the scroll controller
    _updateScrollController();

    // 3. Two-way binding: Push re_editor changes to the standard controller
    _codeController.addListener(() {
      if (widget.controller.text != _codeController.text) {
        widget.controller.text = _codeController.text;
        if (widget.onChanged != null) {
          widget.onChanged!(_codeController.text);
        }
      }
    });

    // 4. Two-way binding: Push standard controller changes to re_editor
    widget.controller.addListener(() {
      if (_codeController.text != widget.controller.text) {
        _codeController.text = widget.controller.text;
      }
    });
  }

  @override
  void dispose() {
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
          Container(
            margin: const EdgeInsets.all(AppDimens.marginText),
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimens.marginText),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
              boxShadow: AppColors.cardShadow(context),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Tooltip(
                    message: _isWordWrapEnabled
                        ? 'Disable Word Wrap'
                        : 'Enable Word Wrap',
                    child: IconButton(
                      icon: Icon(
                        _isWordWrapEnabled ? Icons.wrap_text : Icons.subject,
                        size: 20,
                        color:
                            Theme.of(context).iconTheme.color?.withOpacity(0.7),
                      ),
                      onPressed: _toggleWordWrap,
                      splashRadius: 20,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 40, minHeight: 40),
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
                  if (widget.isSearchable)
                    ToolTipIconButton(
                      icon: IconKeys.textfieldSearch,
                      tooltip: LocaleKeys.input_tooltip_search.localize(),
                      onTap: _toggleSearch,
                    ),
                ],
              ),
            ),
          ),

          // NATIVE RE_EDITOR INTEGRATION
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
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
                          'json': CodeHighlightThemeMode(mode: langJson)
                        },
                        theme: googlecodeTheme,
                      ),
                    ),
                    indicatorBuilder: widget.showLineNumbers
                        ? (context, editingController, chunkController,
                            notifier) {
                            return Row(
                              children: [
                                DefaultCodeLineNumber(
                                  controller: editingController,
                                  notifier: notifier,
                                ),
                              ],
                            );
                          }
                        : null,
                    findBuilder: widget.isSearchable
                        ? (context, controller, readOnly) {
                            return CodeFindPanelView(
                                controller: controller, readOnly: readOnly);
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
