import 'dart:math';

import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../generated/locale_keys.g.dart';

class LoremIpsumGeneratorState extends ViewState {
  final type = 'paragraphs'.obs; // Words, Sentences, Paragraphs
  final length = 3.obs; // 1 to 1000
  final Map<String, String> choices = {
    'words': LocaleKeys.lbl_lorem_ipsum_words.localize(),
    'sentences': LocaleKeys.lbl_lorem_ipsum_sentences.localize(),
    'paragraphs': LocaleKeys.lbl_lorem_ipsum_paragraphs.localize(),
  };
}

class LoremIpsumGeneratorController
    extends BaseController<LoremIpsumGeneratorState> {
  final outputController = TextEditingController();
  final lengthController = TextEditingController();

  final List<String> _words = [
    "lorem",
    "ipsum",
    "dolor",
    "sit",
    "amet",
    "consectetur",
    "adipiscing",
    "elit",
    "sed",
    "do",
    "eiusmod",
    "tempor",
    "incididunt",
    "ut",
    "labore",
    "et",
    "dolore",
    "magna",
    "aliqua",
    "enim",
    "ad",
    "minim",
    "veniam",
    "quis",
    "nostrud",
    "exercitation",
    "ullamco",
    "laboris",
    "nisi",
    "aliquip",
    "ex",
    "ea",
    "commodo",
    "consequat"
  ];

  @override
  LoremIpsumGeneratorState initState() => LoremIpsumGeneratorState();

  @override
  void onInit() {
    super.onInit();
    lengthController.text = state.length.value.toString();
    generateText();
  }

  @override
  void onClose() {
    outputController.dispose();
    lengthController.dispose();
    super.onClose();
  }

  void updateLength(String val) {
    int? parsed = int.tryParse(val);
    if (parsed != null && parsed > 0 && parsed <= 1000) {
      state.length.value = parsed;
      generateText();
    }
  }

  String _getRandomWord(Random random) => _words[random.nextInt(_words.length)];

  String _generateSentence(Random random) {
    int wordCount = 5 + random.nextInt(8); // Sentences between 5 and 12 words
    List<String> sentenceWords =
        List.generate(wordCount, (_) => _getRandomWord(random));
    String sentence = sentenceWords.join(' ');
    return '${sentence[0].toUpperCase()}${sentence.substring(1)}.';
  }

  String _generateParagraph(Random random) {
    int sentenceCount =
        3 + random.nextInt(5); // Paragraphs between 3 and 7 sentences
    return List.generate(sentenceCount, (_) => _generateSentence(random))
        .join(' ');
  }

  void generateText() {
    final random = Random();
    int count = state.length.value;
    List<String> results = [];

    if (state.type.value == 'words') {
      results = List.generate(count, (_) => _getRandomWord(random));
      outputController.text = results.join(' ');
    } else if (state.type.value == 'sentences') {
      results = List.generate(count, (_) => _generateSentence(random));
      outputController.text = results.join(' ');
    } else {
      // Paragraphs
      results = List.generate(count, (_) => _generateParagraph(random));
      outputController.text = results.join('\n\n');
    }
  }
}

class LoremIpsumGeneratorBinding
    extends AppBindings<LoremIpsumGeneratorController> {
  LoremIpsumGeneratorBinding({required super.tag});
  @override
  get controller => LoremIpsumGeneratorController();
}
