import 'dart:io';
import 'dart:typed_data';

import 'package:diarioup/diarioup.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path;

void main() {
  test(
    'ridimensiona, persiste percorsi relativi e rimuove i file sostituiti',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'diarioup-profile-images-',
      );
      final databaseFile = File(
        path.join(directory.path, 'preferences.sqlite'),
      );
      var database = AppDatabase(NativeDatabase(databaseFile));
      addTearDown(() async {
        await database.close();
        if (await directory.exists()) await directory.delete(recursive: true);
      });
      await database.storeProfiles(const <StudentProfile>[
        StudentProfile(
          sourceProfileId: 'profile-1',
          displayLabel: 'Profilo test',
          schoolMinistryCode: 'TEST0001',
          academicYear: '2026/2027',
        ),
      ]);
      var repository = LocalProfileCustomizationRepository(
        database: database,
        documentsDirectoryProvider: () async => directory,
      );

      await repository.saveImage(
        profileId: 'profile-1',
        kind: ProfileImageKind.profile,
        bytes: _imageBytes(width: 1200, height: 800, red: 30),
      );
      final first = await database.readProfileCustomization('profile-1');
      final firstPath = first.profileImagePath;
      expect(firstPath, isNotNull);
      expect(path.posix.isAbsolute(firstPath!), isFalse);
      expect(firstPath, isNot(contains(directory.path)));
      final firstFile = _relativeFile(directory, firstPath);
      expect(await firstFile.exists(), isTrue);
      final resized = image.decodeJpg((await repository.loadImage(firstPath))!);
      expect(resized, isNotNull);
      expect(resized!.width, 512);
      expect(resized.height, lessThanOrEqualTo(512));

      await database.writeReminderPreferences(
        'profile-1',
        const ReminderPreferences(enabled: true, hour: 19, minute: 15),
      );
      expect(
        (await database.readProfileCustomization('profile-1')).profileImagePath,
        firstPath,
      );

      await repository.saveImage(
        profileId: 'profile-1',
        kind: ProfileImageKind.profile,
        bytes: _imageBytes(width: 800, height: 1200, red: 90),
      );
      final replacement = await database.readProfileCustomization('profile-1');
      expect(replacement.profileImagePath, isNot(firstPath));
      expect(await firstFile.exists(), isFalse);
      expect(
        await database.readReminderPreferences('profile-1'),
        isA<ReminderPreferences>()
            .having((value) => value.enabled, 'enabled', isTrue)
            .having((value) => value.hour, 'hour', 19)
            .having((value) => value.minute, 'minute', 15),
      );

      await database.close();
      database = AppDatabase(NativeDatabase(databaseFile));
      repository = LocalProfileCustomizationRepository(
        database: database,
        documentsDirectoryProvider: () async => directory,
      );
      final restored = await database.readProfileCustomization('profile-1');
      expect(restored.profileImagePath, replacement.profileImagePath);
      expect(
        await repository.loadImage(restored.profileImagePath!),
        isNotEmpty,
      );

      final replacementFile = _relativeFile(
        directory,
        restored.profileImagePath!,
      );
      await repository.removeImage(
        profileId: 'profile-1',
        kind: ProfileImageKind.profile,
      );
      expect(
        (await database.readProfileCustomization('profile-1')).profileImagePath,
        isNull,
      );
      expect(await replacementFile.exists(), isFalse);
    },
  );

  test(
    'rifiuta immagini non valide e percorsi fuori dalla directory app',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'diarioup-profile-images-invalid-',
      );
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(() async {
        await database.close();
        if (await directory.exists()) await directory.delete(recursive: true);
      });
      await database.storeProfiles(const <StudentProfile>[
        StudentProfile(
          sourceProfileId: 'profile-1',
          displayLabel: 'Profilo test',
          schoolMinistryCode: 'TEST0001',
          academicYear: '2026/2027',
        ),
      ]);
      final repository = LocalProfileCustomizationRepository(
        database: database,
        documentsDirectoryProvider: () async => directory,
      );

      await expectLater(
        repository.saveImage(
          profileId: 'profile-1',
          kind: ProfileImageKind.diaryBackground,
          bytes: Uint8List.fromList(<int>[1, 2, 3]),
        ),
        throwsA(isA<InvalidCustomizationImage>()),
      );
      await expectLater(
        repository.loadImage('../outside.jpg'),
        throwsArgumentError,
      );
    },
  );
}

Uint8List _imageBytes({
  required int width,
  required int height,
  required int red,
}) {
  final source = image.Image(width: width, height: height);
  image.fill(source, color: image.ColorRgb8(red, 80, 160));
  return Uint8List.fromList(image.encodePng(source));
}

File _relativeFile(Directory root, String relativePath) {
  return File(
    path.joinAll(<String>[root.path, ...path.posix.split(relativePath)]),
  );
}
