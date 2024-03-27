class Language {
  /// the country code (FR,MR..)
  String code;

  /// the locale (fr, ar)
  String locale;

  /// the full name of language (French, Arabic..)
  String language;

  /// map of keys used based on industry type (service worker, route etc)
  Map<String, String>? dictionary;

  Language({
    required this.code,
    required this.locale,
    required this.language,
    this.dictionary,
  });
}
