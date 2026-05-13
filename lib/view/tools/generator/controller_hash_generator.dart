import 'dart:convert';
import 'dart:typed_data';

import 'package:crclib/catalog.dart'; // From crclib
import 'package:crypto/crypto.dart' as crypto;
import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointycastle/export.dart' as pc; // From pointycastle

class HashGeneratorController extends BaseController<HashGeneratorState> {
  final inputController = TextEditingController();

  // List of required algorithms
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

  // We use a map to dynamically hold a controller for each algorithm
  final Map<String, TextEditingController> outputControllers = {};

  @override
  HashGeneratorState initState() => HashGeneratorState();

  @override
  void onInit() {
    super.onInit();
    for (var algo in algorithms) {
      outputControllers[algo] = TextEditingController();
    }
  }

  @override
  void onClose() {
    inputController.dispose();
    for (var ctrl in outputControllers.values) {
      ctrl.dispose();
    }
    super.onClose();
  }

  void toggleCase(bool val) {
    state.isUpperCase.value = val;
    generateHashes();
  }

  // Helper to convert Uint8List to a Hex String
  String _toHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join('');
  }

  void generateHashes() {
    final text = inputController.text;
    if (text.isEmpty) {
      for (var ctrl in outputControllers.values) {
        ctrl.clear();
      }
      return;
    }

    final bytes = utf8.encode(text);
    final uint8Bytes = Uint8List.fromList(bytes); // Required for PointyCastle

    // Helper to apply case formatting
    String formatOutput(String hash) {
      return state.isUpperCase.value ? hash.toUpperCase() : hash.toLowerCase();
    }

    try {
      // 1. Standard algorithms using the 'crypto' package
      outputControllers['MD5']?.text =
          formatOutput(crypto.md5.convert(bytes).toString());
      outputControllers['SHA1']?.text =
          formatOutput(crypto.sha1.convert(bytes).toString());
      outputControllers['SHA224']?.text =
          formatOutput(crypto.sha224.convert(bytes).toString());
      outputControllers['SHA256']?.text =
          formatOutput(crypto.sha256.convert(bytes).toString());
      outputControllers['SHA384']?.text =
          formatOutput(crypto.sha384.convert(bytes).toString());
      outputControllers['SHA512']?.text =
          formatOutput(crypto.sha512.convert(bytes).toString());

      // 2. CRC32 using 'crclib'
      // We use padLeft(8, '0') because CRC32 produces an 8-character hex string
      final crcValue = Crc32().convert(bytes);
      outputControllers['CRC32']?.text =
          formatOutput(crcValue.toRadixString(16).padLeft(8, '0'));

      // 3. SHA-3 Family using 'pointycastle'
      outputControllers['SHA3-224']?.text =
          formatOutput(_toHex(pc.SHA3Digest(224).process(uint8Bytes)));
      outputControllers['SHA3-256']?.text =
          formatOutput(_toHex(pc.SHA3Digest(256).process(uint8Bytes)));
      outputControllers['SHA3-384']?.text =
          formatOutput(_toHex(pc.SHA3Digest(384).process(uint8Bytes)));
      outputControllers['SHA3-512']?.text =
          formatOutput(_toHex(pc.SHA3Digest(512).process(uint8Bytes)));

      // 4. Keccak (Usually evaluated at 256-bit) using 'pointycastle'
      outputControllers['Keccak']?.text =
          formatOutput(_toHex(pc.KeccakDigest(256).process(uint8Bytes)));

      // 5. BLAKE2 (Using Blake2b with a 256-bit / 32-byte digest size)
      // Note: Depending on your PointyCastle version, the constructor might just be pc.Blake2bDigest()
      // which defaults to 64 bytes (512-bit). If so, use that.
      final blake2b = pc.Blake2bDigest(digestSize: 32);
      outputControllers['BLAKE2']?.text =
          formatOutput(_toHex(blake2b.process(uint8Bytes)));
    } catch (e) {
      // Just in case a digest throws an error on initialization
      debugPrint('Hash Generation Error: $e');
    }
  }
}

class HashGeneratorState extends ViewState {
  final isUpperCase = false.obs;
}

class HashGeneratorBinding extends AppBindings<HashGeneratorController> {
  HashGeneratorBinding({required super.tag});

  @override
  get controller {
    return HashGeneratorController();
  }
}
