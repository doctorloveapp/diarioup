import 'package:diarioup/src/data/auth/school_class_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String? parse(Object? year, Object? section) => SchoolClassParser.parse({
    'scheda': {
      'classe': {'desDenominazione': year, 'desSezione': section},
    },
  });

  test('formatta classe e sezione senza duplicazioni', () {
    expect(parse('1', ' B '), 'I B');
    expect(parse('III', 'C'), 'III C');
    expect(parse('Classe I B', 'B'), 'I B');
    expect(parse('1B', 'B'), 'I B');
    expect(parse('III', 'I'), 'III I');
  });

  test('non inventa classi da dati assenti o malformati', () {
    expect(SchoolClassParser.parse({}), isNull);
    expect(SchoolClassParser.parse({'scheda': 'non valida'}), isNull);
    expect(parse(null, 'B'), isNull);
    expect(parse('', 'B'), isNull);
    expect(parse(1, 'B'), isNull);
    expect(parse('I', null), 'I');
  });
}
