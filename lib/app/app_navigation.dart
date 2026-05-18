import 'package:devtoys_flutter/index.dart';
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
  encoderHtml,
  encoderJwt,
  encoderUrl,
  formatterJson,
  formatterXml,
  formatterSql,
  generatorHash,
  generatorLoremIpsum,
  generatorUuid,
  generatorChecksum,
  generatorQr,
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
      case Nav.generatorHash:
        return HashGeneratorPage(viewTag: viewTag);
      case Nav.generatorLoremIpsum:
        return LoremIpsumGeneratorPage(viewTag: viewTag);
      case Nav.generatorUuid:
        return UuidGeneratorPage(viewTag: viewTag);
      case Nav.generatorChecksum:
        return ChecksumPage(viewTag: viewTag);
      case Nav.generatorQr:
        return QrGeneratorPage(viewTag: viewTag);
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
      Nav.home: IconKeys.home,
      Nav.converterDate: IconKeys.date,
      Nav.converterJsonYaml: IconKeys.json,
      Nav.converterNumberBase: IconKeys.numberBase,
      Nav.encoderJwt: IconKeys.jwt,
      Nav.encoderUrl: IconKeys.url,
      Nav.encoderHtml: IconKeys.html,
      Nav.encoderBase64: IconKeys.base64,
      Nav.formatterJson: IconKeys.jsonFormat,
      Nav.formatterXml: IconKeys.xml,
      Nav.formatterSql: IconKeys.sql,
      Nav.generatorHash: IconKeys.hash,
      Nav.generatorLoremIpsum: IconKeys.loremIpsum,
      Nav.generatorUuid: IconKeys.uuid,
      Nav.generatorChecksum: IconKeys.checksum,
      Nav.generatorQr: IconKeys.qr,
    }[this];
  }

  String? get getName {
    return {
      Nav.converterDate: LocaleKeys.nav_date.localize(),
      Nav.converterNumberBase: LocaleKeys.nav_number_base.localize(),
      Nav.converterJsonYaml: LocaleKeys.nav_json_yaml.localize(),
      Nav.encoderBase64: LocaleKeys.nav_base64.localize(),
      Nav.encoderHtml: LocaleKeys.nav_html.localize(),
      Nav.encoderUrl: LocaleKeys.nav_url.localize(),
      Nav.encoderJwt: LocaleKeys.nav_jwt.localize(),
      Nav.formatterJson: LocaleKeys.nav_json.localize(),
      Nav.formatterXml: LocaleKeys.nav_xml.localize(),
      Nav.formatterSql: LocaleKeys.nav_sql.localize(),
      Nav.generatorHash: LocaleKeys.nav_hash.localize(),
      Nav.generatorLoremIpsum: LocaleKeys.nav_lorem_ipsum.localize(),
      Nav.generatorUuid: LocaleKeys.nav_uuid.localize(),
      Nav.generatorChecksum: LocaleKeys.nav_checksum.localize(),
      Nav.generatorQr: LocaleKeys.nav_qr_generator.localize(),
    }[this];
  }

  List<String> get searchTerms {
    return {
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
          Nav.generatorChecksum: [
            'checksum',
            '校验和',
            'チェックサム',
            '체크섬',
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
        }[this] ??
        [];
  }
}
