import 'package:cross_file/cross_file.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:devtoys_flutter/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ChecksumController extends BaseController<ChecksumState> {
  final outputController = TextEditingController();
  final compareController = TextEditingController();

  final algorithms = {
    'MD5': 'MD5',
    'SHA1': 'SHA1',
    'SHA256': 'SHA256',
    'SHA384': 'SHA384',
    'SHA512': 'SHA512'
  };

  @override
  ChecksumState initState() => ChecksumState();

  @override
  void onInit() {
    super.onInit();
    compareController.addListener(() => update(['comparer']));
  }

  @override
  void onClose() {
    outputController.dispose();
    compareController.dispose();
    super.onClose();
  }

  // --- ACTIONS ---

  void toggleUppercase(bool val) {
    state.isUppercase.value = val;
    _formatOutput();
  }

  void changeAlgorithm(String algo) {
    state.selectedAlgorithm.value = algo;
    if (state.currentFile.value != null) {
      _calculateHash();
    }
  }

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        withData: kIsWeb,
        withReadStream: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;

        final xfile = file.path != null
            ? XFile(file.path!)
            : XFile.fromData(file.bytes!, name: file.name, length: file.size);

        handleDroppedFile(xfile);
      }
    } catch (e) {
      outputController.text = 'Error picking file: $e';
      state.isProcessing.value = false;
    }
  }

  void handleDrop(DropDoneDetails details) {
    if (details.files.isNotEmpty) {
      handleDroppedFile(details.files.first);
    }
  }

  void handleDroppedFile(XFile file) {
    state.currentFile.value = file;
    _calculateHash();
  }

  // --- CORE HASHING LOGIC ---

  Future<void> _calculateHash() async {
    final file = state.currentFile.value;
    if (file == null) return;

    state.isProcessing.value = true;
    outputController.text = 'Calculating...';

    try {
      final algo = _getAlgorithm(state.selectedAlgorithm.value);

      // Use bind() to stream the file bit-by-bit directly into the hasher.
      // This prevents Out-Of-Memory errors on large files!
      final stream = file.openRead();
      final digest = await algo.bind(stream).first;

      outputController.text = digest.toString();
      _formatOutput();
    } catch (e) {
      outputController.text = 'Error reading file: $e';
    } finally {
      state.isProcessing.value = false;
    }
  }

  crypto.Hash _getAlgorithm(String name) {
    switch (name) {
      case 'MD5':
        return crypto.md5;
      case 'SHA1':
        return crypto.sha1;
      case 'SHA256':
        return crypto.sha256;
      case 'SHA384':
        return crypto.sha384;
      case 'SHA512':
        return crypto.sha512;
      default:
        return crypto.md5;
    }
  }

  void _formatOutput() {
    if (outputController.text.isEmpty ||
        outputController.text.startsWith('Error') ||
        outputController.text == 'Calculating...') return;

    outputController.text = state.isUppercase.value
        ? outputController.text.toUpperCase()
        : outputController.text.toLowerCase();

    update(['comparer']); // Trigger UI update for the comparer color
  }

  // --- CLIPBOARD ---

  void copyOutput() {
    Clipboard.setData(ClipboardData(text: outputController.text));
  }

  Future<void> pasteComparer() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      compareController.text = data.text!.trim();
    }
  }
}

class ChecksumState extends ViewState {
  final isUppercase = false.obs;
  final selectedAlgorithm = 'MD5'.obs;
  final isProcessing = false.obs;

  // Track the current file so we can recalculate if the user changes the algorithm
  final Rx<XFile?> currentFile = Rx<XFile?>(null);
}

class ChecksumBinding extends AppBindings<ChecksumController> {
  ChecksumBinding({required super.tag});
  @override
  get controller => ChecksumController();
}
