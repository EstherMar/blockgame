import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class S implements WidgetsLocalizations {
  const S();

  static const GeneratedLocalizationsDelegate delegate =
    GeneratedLocalizationsDelegate();

  static S of(BuildContext context) => Localizations.of<S>(context, S);

  TextDirection get textDirection => TextDirection.ltr;

  String get record => "Record";
  String get cleans => "Líneas";
  String get level => "Nivel";
  String get next => "Proximo";
  String get pause_resume => "Pausa";
  String get points => "Puntuación";
  String get reset => "Reiniciar";
  String get sounds => "Sonido";
}

class $en extends S {
  const $en();
}

class $zh_CN extends S {
  const $zh_CN();

  TextDirection get textDirection => TextDirection.ltr;

}

class GeneratedLocalizationsDelegate extends LocalizationsDelegate<S> {
  const GeneratedLocalizationsDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale("es", ""),
    ];
  }

  LocaleListResolutionCallback listResolution({Locale fallback}) {
    return (List<Locale> locales, Iterable<Locale> supported) {
      if (locales == null || locales.isEmpty) {
        return fallback ?? supported.first;
      } else {
        return _resolve(locales.first, fallback, supported);
      }
    };
  }

  LocaleResolutionCallback resolution({Locale fallback}) {
    return (Locale locale, Iterable<Locale> supported) {
      return _resolve(locale, fallback, supported);
    };
  }

  Locale _resolve(Locale locale, Locale fallback, Iterable<Locale> supported) {
    if (locale == null || !isSupported(locale)) {
      return fallback ?? supported.first;
    }

    final Locale languageLocale = Locale(locale.languageCode, "");
    if (supported.contains(locale)) {
      return locale;
    } else if (supported.contains(languageLocale)) {
      return languageLocale;
    } else {
      final Locale fallbackLocale = fallback ?? supported.first;
      return fallbackLocale;
    }
  }

  Future<S> load(Locale locale) {
    final String lang = getLang(locale);
    if (lang != null) {
      switch (lang) {
        case "en":
          return SynchronousFuture<S>(const $en());
        case "zh_CN":
          return SynchronousFuture<S>(const $zh_CN());
        default:
          // NO-OP.
      }
    }
    return SynchronousFuture<S>(const S());
  }

  bool isSupported(Locale locale) =>
    locale != null && supportedLocales.contains(locale);

  bool shouldReload(GeneratedLocalizationsDelegate old) => false;
}

String getLang(Locale l) => l == null
  ? null
  : l.countryCode != null && l.countryCode.isEmpty
    ? l.languageCode
    : l.toString();
