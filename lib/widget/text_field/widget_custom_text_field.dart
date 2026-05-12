import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isMonoSpace;
  final bool isJsonFormatted;
  final bool isXMLFormatted;
  final bool isEditable;
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
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _paste() async {
    if (!widget.isEditable) return;
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      widget.controller.text = data.text!;
      if (widget.onChanged != null) {
        widget.onChanged!(data.text!);
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // TOOLBAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isSearchVisible)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        height: 36,
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search...',
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (val) {
                            // Implement search highlighting logic here if needed
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                Tooltip(
                    message: 'Select All',
                    child: IconButton(
                        icon: const Icon(Icons.select_all, size: 20),
                        onPressed: _selectAll)),
                Tooltip(
                    message: 'Copy',
                    child: IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: _copy)),
                if (widget.isEditable)
                  Tooltip(
                      message: 'Paste',
                      child: IconButton(
                          icon: const Icon(Icons.paste, size: 20),
                          onPressed: _paste)),
                Tooltip(
                    message: 'Search',
                    child: IconButton(
                        icon: const Icon(Icons.search, size: 20),
                        onPressed: _toggleSearch)),
              ],
            ),
          ),

          // TEXT FIELD
          Expanded(
            child: TextField(
              controller: widget.controller,
              readOnly: !widget.isEditable,
              maxLines: widget.maxLines,
              expands: widget.maxLines == null,
              inputFormatters: widget.inputFormatters,
              style: TextStyle(
                fontFamily: widget.isMonoSpace ? 'monospace' : null,
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: InputBorder.none, // Border handled by outer container
                contentPadding: EdgeInsets.all(16),
              ),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
