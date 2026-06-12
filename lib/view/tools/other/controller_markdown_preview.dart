import 'package:devstack/index.dart';
import 'package:flutter/material.dart'; // Needed for TextEditingController
import 'package:get/get.dart';

class MarkdownPreviewState extends ViewState {
  final inputText = ''.obs;
  // 'light', 'dark', or 'system'
  final previewTheme = 'system'.obs;
}

class MarkdownPreviewController extends BaseController<MarkdownPreviewState> {
  // NEW: Add a text controller to manage the physical text field
  final TextEditingController textController = TextEditingController();

  @override
  MarkdownPreviewState initState() => MarkdownPreviewState();

  @override
  void onClose() {
    textController.dispose(); // Clean up memory when the view closes
    super.onClose();
  }

  void updateMarkdown(String text) {
    state.inputText.value = text;
  }

  void updateTheme(String themeStr) {
    state.previewTheme.value = themeStr;
  }

  // NEW: Editor action methods
  void clearText() {
    textController.clear();
    updateMarkdown('');
  }

  Future<void> pasteText() async {
    // Basic paste implementation (assuming you have a clipboard utility)
    // final text = await Clipboard.getData(Clipboard.kTextPlain);
    // if (text?.text != null) {
    //   textController.text = text!.text!;
    //   updateMarkdown(text.text!);
    // }
  }
}

class MarkdownPreviewBinding extends AppBindings<MarkdownPreviewController> {
  MarkdownPreviewBinding({required super.tag});

  @override
  get controller => MarkdownPreviewController();
}
