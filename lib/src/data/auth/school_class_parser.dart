/// Reads only class metadata from the authenticated /profilo response.
/// Structure: portaleargo-api/src/schemas/index.ts, scheda.classe.
abstract final class SchoolClassParser {
  static String? parse(Map<String, Object?> profile) {
    final sheet = profile['scheda'];
    if (sheet is! Map<Object?, Object?>) return null;
    final schoolClass = sheet['classe'];
    if (schoolClass is! Map<Object?, Object?>) return null;
    var year = _clean(schoolClass['desDenominazione']);
    final section = _clean(schoolClass['desSezione']);
    if (year == null) return null;
    year = year.replaceFirst(RegExp(r'^classe\s+', caseSensitive: false), '');
    // Some schools include the section in both fields. Do not print "I B B".
    if (section != null &&
        (year.toUpperCase().endsWith(' ${section.toUpperCase()}') ||
            RegExp(
              '^\\d+${RegExp.escape(section)}\$',
              caseSensitive: false,
            ).hasMatch(year))) {
      final withoutSection = year
          .substring(0, year.length - section.length)
          .trim();
      if (withoutSection.isNotEmpty) year = withoutSection;
    }
    year =
        const {'1': 'I', '2': 'II', '3': 'III', '4': 'IV', '5': 'V'}[year] ??
        year;
    return [year, ?section].join(' ');
  }

  static String? _clean(Object? value) {
    if (value is! String) return null;
    final text = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    return text.isEmpty || text.length > 120 ? null : text;
  }
}
