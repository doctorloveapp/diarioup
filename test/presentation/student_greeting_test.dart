import 'package:diarioup/src/domain/auth/student_gender.dart';
import 'package:diarioup/src/presentation/formatters/student_greeting.dart';
import 'package:diarioup/src/presentation/l10n/app_copy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('usa il saluto femminile per Giulia anche senza genere esplicito', () {
    expect(
      studentGreeting(
        displayLabel: 'ROSSI GIULIA',
        gender: StudentGender.unknown,
      ),
      AppCopy.dashboardGreetingFemale,
    );
  });

  test('il genere esplicito ha precedenza sul nome', () {
    expect(
      studentGreeting(
        displayLabel: 'Profilo studente',
        gender: StudentGender.female,
      ),
      AppCopy.dashboardGreetingFemale,
    );
    expect(
      studentGreeting(displayLabel: 'Giulia', gender: StudentGender.male),
      AppCopy.dashboardGreeting,
    );
  });
}
