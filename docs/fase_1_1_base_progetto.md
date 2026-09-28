# Fase 1.1 - UX e base di progetto

**Stato:** implementata e verificata su Flutter 3.38.5 / Dart 3.10.4.

## Flusso

`go_router` espone tre destinazioni con guardie basate su stato Riverpod:

```text
/onboarding -> /login -> /dashboard
```

La dashboard richiede un profilo selezionato. Un account multiprofilo resta
nella schermata di login finche l'utente non sceglie esplicitamente lo studente.
Il logout cancella la sessione sicura tramite il repository e torna al login.

## Ambienti

La build predefinita usa `DIARIOUP_ENV=demo`: nessuna richiesta di rete, nessuna
persistenza degli input e profilo sintetico. Le build `development` e
`production` collegano il repository reale soltanto quando ricevono:

```text
--dart-define=DIARIOUP_ENV=development
--dart-define=DIDUP_OAUTH_CLIENT_ID=...
--dart-define=DIDUP_REDIRECT_URI=...
--dart-define=DIDUP_CLIENT_VERSION=...
```

Questi valori non sono presenti nel repository. La UI dipende dal caso d'uso
`AuthenticateWithDidup`, che a sua volta dipende dal contratto di dominio; non
importa Dio, secure storage o DTO Argo.

## Design system

Colori, spaziatura e durate sono centralizzati in
`lib/src/presentation/design_system`. Il tema espone varianti chiara e scura,
Material 3, target di tocco da almeno 48 px e il font Inter incorporato. Il font
non viene scaricato a runtime; licenza e sorgente sono in
`assets/fonts/inter/`.

## Piattaforme e firma

- Android 9+ (`minSdk 28`), backup e traffico HTTP in chiaro disabilitati;
- iOS 16+ configurato, compilazione demandata a macOS/CI;
- release Android mai firmata automaticamente con la chiave debug;
- keystore e password arrivano esclusivamente dalle variabili
  `DIARIOUP_ANDROID_KEYSTORE_PATH`, `DIARIOUP_ANDROID_KEYSTORE_PASSWORD`,
  `DIARIOUP_ANDROID_KEY_ALIAS`, `DIARIOUP_ANDROID_KEY_PASSWORD`.

La CI usa action fissate a SHA, esegue format, analyzer, test, APK debug e build
iOS senza firma. L'identita del certificato resta quella documentata in
`android/signing/README.md`; nessun materiale privato e stato generato.
