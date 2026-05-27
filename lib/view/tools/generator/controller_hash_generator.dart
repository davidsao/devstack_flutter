import 'dart:convert';

import 'package:crclib/catalog.dart';
import 'package:cross_file/cross_file.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:devstack/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pointycastle/export.dart' as pc;

class HashGeneratorState extends ViewState {
  final isUpperCase = false.obs;
  final isTextMode = true.obs;
  final isProcessing = false.obs;
  final currentFile = Rxn<XFile>();
}

class HashGeneratorController extends BaseController<HashGeneratorState> {
  final inputController = TextEditingController();

  final algorithms = [
    'MD5',
    'SHA1',
    'SHA256',
    'SHA224',
    'SHA512',
    'CRC32',
    'SHA3-224',
    'SHA3-256',
    'SHA3-384',
    'SHA3-512',
    'Keccak',
    'BLAKE2',
  ];

  final Map<String, RxString> outputControllers = {};

  @override
  HashGeneratorState initState() => HashGeneratorState();

  @override
  void onInit() {
    super.onInit();
    for (var algo in algorithms) {
      outputControllers[algo] = ''.obs;
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  // --- UI ACTIONS ---

  void setMode(bool isText) {
    state.isTextMode.value = isText;
    if (isText) {
      _hashText();
    } else {
      if (state.currentFile.value != null) {
        _hashFile();
      } else {
        _clearOutputs();
      }
    }
  }

  void toggleCase(bool val) {
    state.isUpperCase.value = val;
    for (var ctrl in outputControllers.values) {
      if (ctrl.value.isNotEmpty &&
          ctrl.value != 'Calculating...' &&
          !ctrl.value.startsWith('Error')) {
        ctrl.value = val ? ctrl.value.toUpperCase() : ctrl.value.toLowerCase();
      }
    }
  }

  void _clearOutputs() {
    for (var ctrl in outputControllers.values) {
      ctrl.value = '';
    }
  }

  String _formatOutput(String hash) {
    return state.isUpperCase.value ? hash.toUpperCase() : hash.toLowerCase();
  }

  String _toHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  // --- FILE HANDLING ---

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
      _setError('Error picking file: $e');
    }
  }

  void handleDrop(DropDoneDetails details) {
    if (details.files.isNotEmpty) {
      handleDroppedFile(details.files.first);
    }
  }

  void handleDroppedFile(XFile file) {
    state.currentFile.value = file;
    state.isTextMode.value = false;
    _hashFile();
  }

  // --- HASHING LOGIC ---

  void onTextChanged(String _) => _hashText();

  void _hashText() {
    final text = inputController.text;
    if (text.isEmpty) {
      _clearOutputs();
      return;
    }

    final bytes = utf8.encode(text);
    final uint8Bytes = Uint8List.fromList(bytes);

    try {
      outputControllers['MD5']?.value =
          _formatOutput(crypto.md5.convert(bytes).toString());
      outputControllers['SHA1']?.value =
          _formatOutput(crypto.sha1.convert(bytes).toString());
      outputControllers['SHA224']?.value =
          _formatOutput(crypto.sha224.convert(bytes).toString());
      outputControllers['SHA256']?.value =
          _formatOutput(crypto.sha256.convert(bytes).toString());
      outputControllers['SHA384']?.value =
          _formatOutput(crypto.sha384.convert(bytes).toString());
      outputControllers['SHA512']?.value =
          _formatOutput(crypto.sha512.convert(bytes).toString());

      outputControllers['CRC32']?.value = _formatOutput(
          Crc32().convert(bytes).toRadixString(16).padLeft(8, '0'));

      outputControllers['SHA3-224']?.value =
          _formatOutput(_toHex(pc.SHA3Digest(224).process(uint8Bytes)));
      outputControllers['SHA3-256']?.value =
          _formatOutput(_toHex(pc.SHA3Digest(256).process(uint8Bytes)));
      outputControllers['SHA3-384']?.value =
          _formatOutput(_toHex(pc.SHA3Digest(384).process(uint8Bytes)));
      outputControllers['SHA3-512']?.value =
          _formatOutput(_toHex(pc.SHA3Digest(512).process(uint8Bytes)));
      outputControllers['Keccak']?.value =
          _formatOutput(_toHex(pc.KeccakDigest(256).process(uint8Bytes)));

      final blake2b = pc.Blake2bDigest(digestSize: 32);
      outputControllers['BLAKE2']?.value =
          _formatOutput(_toHex(blake2b.process(uint8Bytes)));
    } catch (e) {
      _setError(e.toString());
    }
  }

  Future<void> _hashFile() async {
    final file = state.currentFile.value;
    if (file == null) return;

    state.isProcessing.value = true;
    for (var ctrl in outputControllers.values) {
      ctrl.value = 'Calculating...';
    }

    try {
      final stream = file.openRead();

      // 1. Setup Sinks for chunked processing (crypto & crclib)
      crypto.Digest? md5Res,
          sha1Res,
          sha256Res,
          sha224Res,
          sha384Res,
          sha512Res;
      var md5Sink = crypto.md5.startChunkedConversion(
          ChunkedConversionSink.withCallback((d) => md5Res = d.first));
      var sha1Sink = crypto.sha1.startChunkedConversion(
          ChunkedConversionSink.withCallback((d) => sha1Res = d.first));
      var sha256Sink = crypto.sha256.startChunkedConversion(
          ChunkedConversionSink.withCallback((d) => sha256Res = d.first));
      var sha224Sink = crypto.sha224.startChunkedConversion(
          ChunkedConversionSink.withCallback((d) => sha224Res = d.first));
      var sha384Sink = crypto.sha384.startChunkedConversion(
          ChunkedConversionSink.withCallback((d) => sha384Res = d.first));
      var sha512Sink = crypto.sha512.startChunkedConversion(
          ChunkedConversionSink.withCallback((d) => sha512Res = d.first));

      dynamic crcRes;
      var crcSink = Crc32().startChunkedConversion(
          ChunkedConversionSink.withCallback((d) => crcRes = d.first));

      // 2. Setup PointyCastle digests
      final sha3_224 = pc.SHA3Digest(224);
      final sha3_256 = pc.SHA3Digest(256);
      final sha3_384 = pc.SHA3Digest(384);
      final sha3_512 = pc.SHA3Digest(512);
      final keccak = pc.KeccakDigest(256);
      final blake2b = pc.Blake2bDigest(digestSize: 32);

      // 3. Process the file stream exactly once
      await for (final chunk in stream) {
        md5Sink.add(chunk);
        sha1Sink.add(chunk);
        sha256Sink.add(chunk);
        sha224Sink.add(chunk);
        sha384Sink.add(chunk);
        sha512Sink.add(chunk);
        crcSink.add(chunk);

        final uChunk = Uint8List.fromList(chunk);
        sha3_224.update(uChunk, 0, uChunk.length);
        sha3_256.update(uChunk, 0, uChunk.length);
        sha3_384.update(uChunk, 0, uChunk.length);
        sha3_512.update(uChunk, 0, uChunk.length);
        keccak.update(uChunk, 0, uChunk.length);
        blake2b.update(uChunk, 0, uChunk.length);
      }

      // 4. Close Sinks
      md5Sink.close();
      sha1Sink.close();
      sha256Sink.close();
      sha224Sink.close();
      sha384Sink.close();
      sha512Sink.close();
      crcSink.close();

      // 5. Finalize PointyCastle
      Uint8List finalizePC(pc.Digest digest) {
        final out = Uint8List(digest.digestSize);
        digest.doFinal(out, 0);
        return out;
      }

      // 6. Update UI
      outputControllers['MD5']?.value = _formatOutput(md5Res.toString());
      outputControllers['SHA1']?.value = _formatOutput(sha1Res.toString());
      outputControllers['SHA256']?.value = _formatOutput(sha256Res.toString());
      outputControllers['SHA224']?.value = _formatOutput(sha224Res.toString());
      outputControllers['SHA384']?.value = _formatOutput(sha384Res.toString());
      outputControllers['SHA512']?.value = _formatOutput(sha512Res.toString());

      outputControllers['CRC32']?.value =
          _formatOutput(crcRes.toRadixString(16).padLeft(8, '0'));

      outputControllers['SHA3-224']?.value =
          _formatOutput(_toHex(finalizePC(sha3_224)));
      outputControllers['SHA3-256']?.value =
          _formatOutput(_toHex(finalizePC(sha3_256)));
      outputControllers['SHA3-384']?.value =
          _formatOutput(_toHex(finalizePC(sha3_384)));
      outputControllers['SHA3-512']?.value =
          _formatOutput(_toHex(finalizePC(sha3_512)));
      outputControllers['Keccak']?.value =
          _formatOutput(_toHex(finalizePC(keccak)));
      outputControllers['BLAKE2']?.value =
          _formatOutput(_toHex(finalizePC(blake2b)));
    } catch (e) {
      _setError('Error reading file: $e');
    } finally {
      state.isProcessing.value = false;
    }
  }

  void _setError(String err) {
    for (var ctrl in outputControllers.values) {
      ctrl.value = 'Error: $err';
    }
  }

  void copy(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
    );
  }
}

class HashGeneratorBinding extends AppBindings<HashGeneratorController> {
  HashGeneratorBinding({required super.tag});
  @override
  get controller => HashGeneratorController();
}
