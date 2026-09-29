import '../../domain/auth/student_gender.dart';
import '../l10n/app_copy.dart';

String studentGreeting({
  required String displayLabel,
  required StudentGender gender,
}) {
  final resolvedGender = gender == StudentGender.unknown
      ? _inferGenderFromDisplayLabel(displayLabel)
      : gender;
  return resolvedGender == StudentGender.female
      ? AppCopy.dashboardGreetingFemale
      : AppCopy.dashboardGreeting;
}

StudentGender _inferGenderFromDisplayLabel(String displayLabel) {
  final tokens = displayLabel
      .trim()
      .toUpperCase()
      .split(RegExp(r'[^A-ZÀ-ÖØ-Þ]+'))
      .where((token) => token.isNotEmpty);
  return tokens.any(_commonFemaleNames.contains)
      ? StudentGender.female
      : StudentGender.unknown;
}

const Set<String> _commonFemaleNames = <String>{
  'ALESSANDRA',
  'ALICE',
  'ANNA',
  'AURORA',
  'BEATRICE',
  'BENEDETTA',
  'BIANCA',
  'CAMILLA',
  'CARLOTTA',
  'CATERINA',
  'CHIARA',
  'ELENA',
  'ELISA',
  'EMMA',
  'FEDERICA',
  'FRANCESCA',
  'GAIA',
  'GIORGIA',
  'GIULIA',
  'GRETA',
  'ILARIA',
  'LAURA',
  'LUDOVICA',
  'MARGHERITA',
  'MARTA',
  'MARTINA',
  'MATILDE',
  'MELISSA',
  'NOEMI',
  'REBECCA',
  'SARA',
  'SERENA',
  'SOFIA',
  'VALENTINA',
  'VIOLA',
};
