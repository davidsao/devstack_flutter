import 'package:devstack/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../generated/icon_keys.g.dart';
import '../generated/locale_keys.g.dart';

enum Nav {
  home,
  allTools,
  settings,
  converterDate,
  converterJsonYaml,
  converterNumberBase,
  encoderBase64,
  encoderBase64Image,
  encoderHtml,
  encoderJwt,
  encoderUrl,
  formatterJson,
  formatterXml,
  formatterSql,
  minifier,
  generatorHash,
  generatorLoremIpsum,
  generatorUuid,
  generatorQr,
  textRegex,
  colorPicker,
  markdown,
  textInspector,
  codeToImage,
}

class Navigation {
  Navigation(this.id, this.destination, {this.binding, this.name, this.icon});
  final String id;
  final Widget destination;
  final Bindings? binding;
  final String? name;
  final String? icon;
}

extension NavigationExtension on Nav {
  String get screenName {
    return _screenName ?? "";
  }

  String? get _screenName => {
        Nav.home: "home",
      }[this];

  Widget getWidget(String? viewTag) {
    switch (this) {
      case Nav.home:
        return HomePage(viewTag: viewTag);
      case Nav.allTools:
        return AllToolsPage(viewTag: viewTag);
      case Nav.settings:
        return SettingsPage(viewTag: viewTag);
      case Nav.converterDate:
        return DateConverterPage(viewTag: viewTag);
      case Nav.converterJsonYaml:
        return JsonYamlPage(viewTag: viewTag);
      case Nav.converterNumberBase:
        return NumberBasePage(viewTag: viewTag);
      case Nav.encoderBase64:
        return Base64EncoderPage(viewTag: viewTag);
      case Nav.encoderBase64Image:
        return Base64ImagePage(viewTag: viewTag);
      case Nav.encoderHtml:
        return HtmlEncoderPage(viewTag: viewTag);
      case Nav.encoderJwt:
        return JwtEncoderPage(viewTag: viewTag);
      case Nav.encoderUrl:
        return UrlEncoderPage(viewTag: viewTag);
      case Nav.formatterJson:
        return JsonFormatterPage(viewTag: viewTag);
      case Nav.formatterSql:
        return SqlFormatterPage(viewTag: viewTag);
      case Nav.formatterXml:
        return XmlFormatterPage(viewTag: viewTag);
      case Nav.minifier:
        return MinifierPage(viewTag: viewTag);
      case Nav.generatorHash:
        return HashGeneratorPage(viewTag: viewTag);
      case Nav.generatorLoremIpsum:
        return LoremIpsumGeneratorPage(viewTag: viewTag);
      case Nav.generatorUuid:
        return UuidGeneratorPage(viewTag: viewTag);
      case Nav.generatorQr:
        return QrGeneratorPage(viewTag: viewTag);
      case Nav.textRegex:
        return RegexTesterPage(viewTag: viewTag);
      case Nav.colorPicker:
        return ColorPickerPage(viewTag: viewTag);
      case Nav.markdown:
        return MarkdownPreviewPage(viewTag: viewTag);
      case Nav.textInspector:
        return TextInspectorPage(viewTag: viewTag);
      case Nav.codeToImage:
        return CodeToImagePage(viewTag: viewTag);
      default:
        return const Center(child: Text('ComingSoonPage'));
    }
  }

  AppBindings? getBindings(String? tag) {
    switch (this) {
      default:
        return null;
    }
  }

  String? get getIcon {
    return {
      Nav.allTools: IconKeys.home,
      Nav.converterDate: IconKeys.date,
      Nav.converterJsonYaml: IconKeys.json,
      Nav.converterNumberBase: IconKeys.numberBase,
      Nav.encoderJwt: IconKeys.jwt,
      Nav.encoderUrl: IconKeys.url,
      Nav.encoderHtml: IconKeys.html,
      Nav.encoderBase64: IconKeys.base64,
      Nav.encoderBase64Image: IconKeys.base64,
      Nav.formatterJson: IconKeys.jsonFormat,
      Nav.formatterXml: IconKeys.xml,
      Nav.formatterSql: IconKeys.sql,
      Nav.minifier: IconKeys.minify,
      Nav.generatorHash: IconKeys.hash,
      Nav.generatorLoremIpsum: IconKeys.loremIpsum,
      Nav.generatorUuid: IconKeys.uuid,
      Nav.generatorQr: IconKeys.qr,
      Nav.textRegex: IconKeys.regex,
      Nav.colorPicker: IconKeys.colorPicker,
      Nav.markdown: IconKeys.markdown,
      Nav.textInspector: IconKeys.textInspector,
      Nav.codeToImage: IconKeys.codeToImage,
      Nav.settings: IconKeys.settings,
    }[this];
  }

  String? get getName {
    return {
      Nav.allTools: LocaleKeys.lbl_all_tools.localize(),
      Nav.converterDate: LocaleKeys.nav_date.localize(),
      Nav.converterNumberBase: LocaleKeys.nav_number_base.localize(),
      Nav.converterJsonYaml: LocaleKeys.nav_json_yaml.localize(),
      Nav.encoderBase64: LocaleKeys.nav_base64_text.localize(),
      Nav.encoderBase64Image: LocaleKeys.nav_base64_image.localize(),
      Nav.encoderHtml: LocaleKeys.nav_html.localize(),
      Nav.encoderUrl: LocaleKeys.nav_url.localize(),
      Nav.encoderJwt: LocaleKeys.nav_jwt.localize(),
      Nav.formatterJson: LocaleKeys.nav_json.localize(),
      Nav.formatterXml: LocaleKeys.nav_xml.localize(),
      Nav.formatterSql: LocaleKeys.nav_sql.localize(),
      Nav.minifier: LocaleKeys.nav_minifier.localize(),
      Nav.generatorHash: LocaleKeys.nav_hash.localize(),
      Nav.generatorLoremIpsum: LocaleKeys.nav_lorem_ipsum.localize(),
      Nav.generatorUuid: LocaleKeys.nav_uuid.localize(),
      Nav.generatorQr: LocaleKeys.nav_qr_generator.localize(),
      Nav.textRegex: LocaleKeys.nav_regex.localize(),
      Nav.colorPicker: LocaleKeys.nav_color_picker.localize(),
      Nav.markdown: LocaleKeys.nav_markdown.localize(),
      Nav.textInspector: LocaleKeys.nav_text_inspector.localize(),
      Nav.codeToImage: LocaleKeys.nav_code_to_image.localize(),
      Nav.settings: LocaleKeys.lbl_settings_title.localize(),
    }[this];
  }

  List<String> get searchTerms {
    return {
          Nav.allTools: ['home', 'all tools', 'dashboard', '所有工具', '主页', '主頁'],
          Nav.converterDate: ['date', '日期', '日付', '날짜', 'fecha'],
          Nav.converterNumberBase: [
            'number base',
            '進制轉換',
            '进制转换',
            '基数変換',
            '진수 변환',
            'base numérica',
            'base numérique'
          ],
          Nav.converterJsonYaml: ['json', 'yaml', 'converter'],
          Nav.encoderBase64: [
            'base64',
            'encoder',
            '編碼',
            '编码',
            'エンコーダ',
            '인코더',
            'codificador',
            'encodeur'
          ],
          Nav.encoderBase64Image: [
            'base64',
            'encoder',
            '編碼',
            '编码',
            'エンコーダ',
            '인코더',
            'codificador',
            'encodeur'
          ],
          Nav.encoderHtml: [
            'html',
            'encoder',
            '編碼',
            '编码',
            'エンコーダ',
            '인코더',
            'codificador',
            'encodeur'
          ],
          Nav.encoderUrl: [
            'url',
            'encoder',
            '編碼',
            '编码',
            'エンコーダ',
            '인코더',
            'codificador',
            'encodeur'
          ],
          Nav.encoderJwt: [
            'jwt',
            'encoder',
            '編碼',
            '编码',
            'エンコーダ',
            '인코더',
            'codificador',
            'encodeur'
          ],
          Nav.formatterJson: [
            'json',
            'formatter',
            '格式化',
            'フォーマッタ',
            '포매터',
            'formateador',
            'formateur'
          ],
          Nav.formatterXml: [
            'xml',
            'formatter',
            '格式化',
            'フォーマッタ',
            '포매터',
            'formateador',
            'formateur'
          ],
          Nav.formatterSql: [
            'sql',
            'formatter',
            '格式化',
            'フォーマッタ',
            '포매터',
            'formateador',
            'formateur'
          ],
          Nav.minifier: [
            'minifier',
            '最小化工具',
            'ミニファイア',
            '미니파이어',
            'Minificador',
            'Minificateur',
          ],
          Nav.generatorHash: [
            'hash',
            '哈希',
            'ハッシュ',
            '해시',
            'generator',
            '產生器',
            '生成器',
            'ジェネレーター',
            '생성기',
            'generador',
            'générateur'
          ],
          Nav.generatorLoremIpsum: [
            'lorem ipsum',
            'generator',
            '產生器',
            '生成器',
            'ジェネレーター',
            '생성기',
            'generador',
            'générateur'
          ],
          Nav.generatorUuid: [
            'uuid',
            'generator',
            '產生器',
            '生成器',
            'ジェネレーター',
            '생성기',
            'generador',
            'générateur'
          ],
          Nav.generatorQr: [
            'qr',
            'qrcode',
            'generator',
            '產生器',
            '生成器',
            'ジェネレーター',
            '생성기',
            'generador',
            'générateur'
          ],
          Nav.textRegex: [
            'regex',
            '正则表达式',
            '正規表現',
            '정규식',
            'Expresión regular',
            'Expression régulière',
          ],
          Nav.colorPicker: [
            'color picker',
            '顏色選擇器',
            '颜色选择器',
            'カラーピッカー',
            '색상 선택기',
            'Selector de color',
            'Sélecteur de couleur',
          ],
          Nav.encoderBase64Image: [
            'base64',
            'image',
            'picture',
            '图片',
            '圖片',
            '画像',
            '이미지',
            'imagen',
            'photo',
            '照片',
            '写真',
            '사진',
            'foto',
          ],
          Nav.markdown: [
            'markdown',
            'md',
            'preview',
            'editor',
            '预览',
            '預覽',
            'プレビュー',
            '미리보기',
            'vista previa',
            'aperçu',
            '编辑器',
            '編輯器',
            'エディタ',
            '에디터',
            'éditeur',
          ],
          Nav.textInspector: [
            'text',
            'inspector',
            'case',
            'camelcase',
            'word count',
            '文本',
            '文字',
            'テキスト',
            '텍스트',
            'texto',
            'texte',
            '检查器',
            '檢查器',
            'インスペクター',
            '검사기',
            'inspecteur',
            '大小写',
            '大小寫',
            '大文字',
            '대문자',
            'mayúsculas',
            'majuscule',
          ],
        }[this] ??
        [];
  }
}
