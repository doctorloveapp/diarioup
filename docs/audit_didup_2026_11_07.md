# Analisi compatibilità DidUP — 7 novembre 2026

## Decisione

Aggiornamento necessario del login: release DiarioUp **1.6.1+14**.
Il portale può rispondere HTTP 200 con una pagina di consenso HTML anziché
proseguire esclusivamente con redirect HTTP. La release 1.6.0 gestiva cookie
e redirect, ma si arrestava davanti a questa pagina intermedia.

## Diff upstream esaminato

[Confronto completo](https://github.com/Rocciadura/didupAPI-wrapper/compare/999b74bb90e219db3356dd00fb5c522fe424e258...4642af88e347f69364e700d55fbd3d9dc41c2f61).

- `87eb31335f481dfad1c62a79728979afefa7fc54`: gestione del consenso HTML,
  form, link Continua, meta refresh e redirect JavaScript letterali;
  limite della catena aumentato a 15. Impatta il nostro login.
- `f70fe112925b3084c51f9d72d4dd5552bc73ca27`: campi testuali delle note
  disciplinari (`desDescrizione`, `desNota`, ora e tipo), relativi test e chiave
  del poller. Non modifica il formato dei compiti. DiarioUp non implementa
  note disciplinari: non è necessario estenderne il dominio o il database.
- `4642af88e347f69364e700d55fbd3d9dc41c2f61`: aggiunta di `SECURITY.md`,
  nessuna modifica al protocollo.

## Implementazione

Nuovo `OAuthHtmlNavigator` isolato nel livello Data, basato su `html 0.15.7`
(parser Dart, nessun browser, esecuzione JavaScript o caricamento di risorse).
I form di consenso sono accettati solo sul percorso di consenso derivato dalla
configurazione SSO e devono inviare dati allo stesso origin/endpoint.
Le destinazioni di navigazione restano vincolate all'allowlist o all'esatto
callback configurato, con controllo dello `state` prima dello scambio del code.

Il parser conserva campi nascosti e ripetuti, CSRF e il solo pulsante positivo;
ignora controlli disabilitati e checkbox non selezionate, salvo gli scope già
richiesti. Scope ulteriori, form password e pulsanti di rifiuto non vengono
accettati. Il fallback senza form è ristretto all'esatto endpoint di consenso,
con challenge presente e mount HTML `#app` riconoscibile.

La catena conta anche i POST di consenso e resta limitata a 15 richieste.
Gli errori non includono titolo/contenuti HTML, cookie, URL autenticati o
descrizioni OAuth provenienti dal server. Le credenziali non vengono reinserite
nelle pagine intermedie; i cookie restano effimeri e isolati per tentativo.
Endpoint dashboard, normalizzazione compiti e schema DB rimangono invariati.

## Sentinella

- Baseline aggiornata al commit esaminato e alla scansione delle
  `2026-11-07T12:24:02Z`; altri repository e versione App Store invariati.
- Aggiunto `tests/test_auth.py` ai percorsi di priorità alta: il diff attuale
  contiene anche test significativi di autenticazione, oltre ai tre avvisi
  iniziali basati sulle regole precedenti.
- Il workflow esegue ora i test Python delle regole prima di interrogare le
  fonti e inviare mail. I segreti SMTP restano esposti solo al passo di invio.
- L'esclusione richiesta per `Rocciadura/didupAPI-wrapper#3` resta esatta e
  permanente. Non esclude i file o le altre issue.

## Verifica e consegna

Analisi statica `dart analyze --fatal-infos lib test`: nessuna segnalazione.
Suite Flutter completa: **77 test superati**. Formattazione verificata.

Test unitari del parser e del flusso completo HTTP simulato: consenso con
CSRF, campi ripetuti, cookie emessi dall'HTML, destinazioni e scope non
autorizzati, rifiuti, pagine password/manutenzione, meta/JS/link, controllo
`state`, errori OAuth senza dati personali e limite dei passaggi.
Test Python della sentinella: 11 superati.

Per il login live è necessario il collaudo sul dispositivo con credenziali
personali: i test automatici non attestano l'accesso reale al portale.
La release mantiene application ID e keystore; il build number cresce da 13
a 14 per consentire l'installazione come aggiornamento senza disinstallazione.

APK verificato: `dist/DiarioUp-1.6.1+14-release.apk` (73.300.861 byte).
Firma v2 valida e identica alla 1.6.0; versionName `1.6.1`, versionCode `14`,
flag debuggable assente. Controlli asset Flutter/icona promemoria e audit
archivio superati: nessun test, fixture, `.env` o file di firma incluso.
SHA-256: `60EEF47FEA730D5E9BC68EB429DD450C6C2912F59A1555CE079850F3635EBDA2`.

Per questa build locale il compilatore Kotlin è stato eseguito in-process
senza cache incrementali, evitando l'errore dei percorsi C:/W:. Le opzioni
temporanee sono state rimosse al termine; la configurazione Gradle versionata
non cambia.
