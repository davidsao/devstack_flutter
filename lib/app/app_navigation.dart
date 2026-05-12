import 'package:devtoys_flutter/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../generated/icon_keys.g.dart';
import '../generated/locale_keys.g.dart';

enum Nav {
  home,
  converterDate,
  converterJsonYaml,
  converterNumberBase,
  encoderBase64,
  encoderHtml,
  encoderJwt,
  encoderUrl,
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
      default:
        return const Center(child: Text('ComingSoonPage'));
    }
  }

  AppBindings? getBindings(String? tag) {
    switch (this) {
      case Nav.encoderBase64:
        return Base64EncoderBinding(tag: tag);
      case Nav.encoderHtml:
        return HtmlEncoderBinding(tag: tag);
      case Nav.encoderJwt:
        return JwtEncoderBinding(tag: tag);
      case Nav.encoderUrl:
        return UrlEncoderBinding(tag: tag);
      default:
        return null;
    }
  }

  String? get getIcon {
    return {
      Nav.home: IconKeys.home,
      Nav.converterDate: IconKeys.date,
      Nav.converterJsonYaml: IconKeys.json,
      Nav.converterNumberBase: IconKeys.base64,
      Nav.encoderJwt: IconKeys.jwt,
      Nav.encoderUrl: IconKeys.url,
      Nav.encoderHtml: IconKeys.html,
      Nav.encoderBase64: IconKeys.base64,
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
    }[this];
  }
}
