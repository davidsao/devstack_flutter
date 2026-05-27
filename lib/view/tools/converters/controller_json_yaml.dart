import 'dart:convert';

import 'package:devstack/index.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:yaml/yaml.dart';

class JsonYamlController extends BaseController<JsonYamlState> {
  final jsonController = SyntaxHighlightingController(isJson: true);
  final yamlController = SyntaxHighlightingController();

  @override
  JsonYamlState initState() => JsonYamlState();

  @override
  void onClose() {
    jsonController.dispose();
    yamlController.dispose();
    super.onClose();
  }

  // --- HELPER TO CONVERT YamlMap TO STANDARD DART MAP ---
  dynamic _convertNode(dynamic node) {
    if (node is YamlMap) {
      return node.map((k, v) => MapEntry(k.toString(), _convertNode(v)));
    } else if (node is YamlList) {
      return node.map((e) => _convertNode(e)).toList();
    }
    return node;
  }

  // --- EVENT HANDLERS ---
  void onJsonChanged(String jsonString) {
    if (jsonString.isEmpty) {
      yamlController.clear();
      return;
    }
    try {
      // 1. Decode JSON string to Dart Map
      final decoded = jsonDecode(jsonString);
      // 2. Convert Dart Map to YAML string
      final yamlString = json2yaml(decoded, yamlStyle: YamlStyle.generic);
      yamlController.text = yamlString;
    } catch (e) {
      // Invalid JSON mid-typing; ignore without crashing the UI
    }
  }

  void onYamlChanged(String yamlString) {
    if (yamlString.isEmpty) {
      jsonController.clear();
      return;
    }
    try {
      // 1. Load YAML string into YamlMap
      final yamlDoc = loadYaml(yamlString);
      // 2. Convert YamlMap to standard Dart objects
      final dartObj = _convertNode(yamlDoc);
      // 3. Encode Dart object back to pretty-printed JSON
      final jsonStr = const JsonEncoder.withIndent('  ').convert(dartObj);
      jsonController.text = jsonStr;
    } catch (e) {
      // Invalid YAML mid-typing; ignore
    }
  }
}

class JsonYamlState extends ViewState {}

class JsonYamlBinding extends AppBindings<JsonYamlController> {
  JsonYamlBinding({required super.tag});

  @override
  get controller {
    // final get = GetIt.instance;
    return JsonYamlController();
  }
}
