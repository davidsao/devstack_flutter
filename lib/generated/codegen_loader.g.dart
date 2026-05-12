// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _en = {
  "lbl_app_name": "DevStack",
  "lbl_menu_home": "Home",
  "lbl_menu_converter": "Converters",
  "nav_json_yaml": "JSON <> YAML",
  "nav_number_base": "Number Base",
  "nav_date": "Date",
  "lbl_menu_encoder": "Encoders / Decoders",
  "nav_html": "HTML",
  "nav_url": "URL",
  "nav_base64": "Base64",
  "nav_jwt": "JWT",
  "lbl_menu_formatter": "Formatters",
  "nav_json": "JSON",
  "nav_xml": "XML",
  "nav_sql": "SQL Formatter",
  "lbl_menu_generator": "Generators",
  "nav_hash": "Hash",
  "nav_uuid": "UUID",
  "nav_lorem_ipsum": "Lorem Ipsum",
  "nav_checksum": "Checksum",
  "nav_qr_generator": "QR Code Gen..."
};
static const Map<String,dynamic> _zh_Hans = {
  "lbl_app_name": "开发栈",
  "lbl_menu_home": "首页",
  "lbl_menu_converter": "转换工具",
  "nav_json_yaml": "JSON <> YAML",
  "nav_number_base": "进制转换",
  "nav_date": "日期",
  "lbl_menu_encoder": "编码 / 解码工具",
  "nav_html": "HTML",
  "nav_url": "URL",
  "nav_base64": "Base64",
  "nav_jwt": "JWT",
  "lbl_menu_formatter": "格式化工具",
  "nav_json": "JSON",
  "nav_xml": "XML",
  "nav_sql": "SQL 格式化",
  "lbl_menu_generator": "生成工具",
  "nav_hash": "哈希",
  "nav_uuid": "UUID",
  "nav_lorem_ipsum": "Lorem Ipsum",
  "nav_checksum": "校验和",
  "nav_qr_generator": "二维码生成器"
};
static const Map<String,dynamic> _zh_Hant = {
  "lbl_app_name": "DevStack",
  "lbl_menu_home": "首頁",
  "lbl_menu_converter": "轉換工具",
  "nav_json_yaml": "JSON <> YAML",
  "nav_number_base": "進制轉換",
  "nav_date": "日期",
  "lbl_menu_encoder": "編碼 / 解碼工具",
  "nav_html": "HTML",
  "nav_url": "URL",
  "nav_base64": "Base64",
  "nav_jwt": "JWT",
  "lbl_menu_formatter": "格式化工具",
  "nav_json": "JSON",
  "nav_xml": "XML",
  "nav_sql": "SQL 格式化",
  "lbl_menu_generator": "生成工具",
  "nav_hash": "雜湊",
  "nav_uuid": "UUID",
  "nav_lorem_ipsum": "Lorem Ipsum",
  "nav_checksum": "檢查碼",
  "nav_qr_generator": "QR碼生成器"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": _en, "zh_Hans": _zh_Hans, "zh_Hant": _zh_Hant};
}
