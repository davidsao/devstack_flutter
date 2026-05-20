import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../generated/icon_keys.g.dart';
import '../../generated/locale_keys.g.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isMonoSpace;
  final bool isJsonFormatted;
  final bool isXMLFormatted;
  final bool isEditable;
  final bool isSearchable;
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
    this.maxLines,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<int> _matchIndices = [];
  int _currentMatch = 0;
  String _lastKnownText = '';

  // Stored constraints to calculate the exact text height
  double _textFieldMaxWidth = 0;
  double _textFieldMaxHeight = 0;

  @override
  void initState() {
    super.initState();
    _lastKnownText = widget.controller.text;
    widget.controller.addListener(_onMainTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onMainTextChanged);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onMainTextChanged() {
    // --- FIX: Only recalculate if the actual text changed, not just the cursor/selection ---
    if (widget.controller.text != _lastKnownText) {
      _lastKnownText = widget.controller.text;

      if (_isSearchVisible && _searchController.text.isNotEmpty) {
        _calculateMatches(_searchController.text);
      } else if (_isSearchVisible && _searchController.text.isEmpty) {
        _calculateMatches('');
      }
    }
  }

  void _syncSearchStateToController() {
    if (widget.controller is SyntaxHighlightingController) {
      int activeIndex = _matchIndices.isEmpty ? -1 : _currentMatch - 1;
      (widget.controller as SyntaxHighlightingController)
          .updateSearch(_searchController.text, activeIndex);
    }
  }

  void _calculateMatches(String query) {
    if (query.isEmpty) {
      setState(() {
        _matchIndices = [];
        _currentMatch = 0;
      });
      _syncSearchStateToController();
      return;
    }

    final matches = RegExp(RegExp.escape(query), caseSensitive: false)
        .allMatches(widget.controller.text);

    setState(() {
      _matchIndices = matches.map((m) => m.start).toList();
      if (_matchIndices.isNotEmpty) {
        _currentMatch = 1;
        _scrollToCurrentMatch();
      } else {
        _currentMatch = 0;
      }
    });
    _syncSearchStateToController();
  }

  void _onSearchChanged(String query) {
    _calculateMatches(query);
  }

  void _scrollToCurrentMatch() {
    if (_matchIndices.isEmpty || _currentMatch < 1) return;
    int offset = _matchIndices[_currentMatch - 1];
    int queryLength = _searchController.text.length;

    // Highlight the selection (This triggers the controller listener!)
    widget.controller.selection =
        TextSelection(baseOffset: offset, extentOffset: offset + queryLength);

    // Calculate scroll position
    if (_textFieldMaxWidth > 0 && _scrollController.hasClients) {
      final textStyle =
          widget.isMonoSpace ? AppTextStyles.monoStyle() : AppTextStyles.b3;

      final textUpToMatch = widget.controller.text.substring(0, offset);

      final tp = TextPainter(
        text: TextSpan(text: textUpToMatch, style: textStyle),
        textDirection: TextDirection.ltr,
      );

      tp.layout(maxWidth: _textFieldMaxWidth);

      double targetScroll = tp.size.height - (_textFieldMaxHeight / 2) + 10;
      if (targetScroll < 0) targetScroll = 0;

      final maxScroll = _scrollController.position.maxScrollExtent;
      if (targetScroll > maxScroll) targetScroll = maxScroll;

      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextMatch() {
    if (_matchIndices.isEmpty) return;
    setState(() {
      _currentMatch =
          _currentMatch < _matchIndices.length ? _currentMatch + 1 : 1;
    });
    _scrollToCurrentMatch();
    _syncSearchStateToController();
  }

  void _prevMatch() {
    if (_matchIndices.isEmpty) return;
    setState(() {
      _currentMatch =
          _currentMatch > 1 ? _currentMatch - 1 : _matchIndices.length;
    });
    _scrollToCurrentMatch();
    _syncSearchStateToController();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        _onSearchChanged('');
      }
    });
  }

  void _selectAll() {
    widget.controller.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.controller.text.length,
    );
  }

  void _copy() {
    Clipboard.setData(ClipboardData(text: widget.controller.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
    );
  }

  void _paste() async {
    if (!widget.isEditable) return;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      widget.controller.text = data.text!;
      // Update our tracker manually here so pasting doesn't break logic
      _lastKnownText = data.text!;
      if (widget.onChanged != null) {
        widget.onChanged!(data.text!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor.withAlpha(10),
            ),
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            color: Colors.transparent,
            // color: Theme.of(context).colorScheme.surface,
            boxShadow: AppColors.textfieldShadow(context),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // TOOLBAR
              Container(
                margin: const EdgeInsets.all(AppDimens.marginText),
                padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.marginText),
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

              // TEXT FIELD WRAPPED IN LAYOUT BUILDER
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  _textFieldMaxWidth = constraints.maxWidth - 32;
                  _textFieldMaxHeight = constraints.maxHeight;

                  return TextField(
                    controller: widget.controller,
                    scrollController: _scrollController,
                    readOnly: !widget.isEditable,
                    maxLines: widget.maxLines,
                    expands: widget.maxLines == null,
                    inputFormatters: widget.inputFormatters,
                    style: widget.isMonoSpace
                        ? AppTextStyles.monoStyle()
                        : AppTextStyles.b2,
                    decoration: InputDecoration(
                      fillColor:
                          Theme.of(context).inputDecorationTheme.fillColor,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    onChanged: widget.onChanged,
                  );
                }),
              ),
            ],
          ),
        ),

        // OVERFLOW FLOATING SEARCH WIDGET
        if (_isSearchVisible)
          Positioned(
            top: 48,
            right: 16,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.surface,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search, size: 18),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: const InputDecoration(
                          hintText: 'Search...',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        onChanged: _onSearchChanged,
                        onSubmitted: (_) => _nextMatch(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_matchIndices.isEmpty ? 0 : _currentMatch}/${_matchIndices.length}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.arrow_upward, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: _prevMatch,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: _nextMatch,
                    ),
                    const SizedBox(width: 8),
                    Container(
                        width: 1,
                        height: 20,
                        color: Theme.of(context).dividerColor),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: _toggleSearch,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
