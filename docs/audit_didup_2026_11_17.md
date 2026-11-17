# Compatibilità DidUP — DiarioUp 1.8.0+18

## Decisione

[App Store](https://itunes.apple.com/lookup?bundleId=it.argosoft.didup.famiglia.new)
verificato il 17 novembre 2026: DidUP **1.30.3**. La release
aggiorna il parametro di build `DIDUP_CLIENT_VERSION` da 1.30.2 a 1.30.3,
quindi l'header `argo-client-version`. È un aggiornamento preventivo:
non è stato dimostrato che Argo rifiuti già la versione precedente.
Non cambiano endpoint, credenziali, OAuth/PKCE, refresh o dati dei compiti.

## Diff esaminato

[Confronto upstream](https://github.com/Rocciadura/didupAPI-wrapper/compare/e74b1aad67e956913d4398319b30869a66e8d149...1a0ffaf83786128679d856998250ab3e3451ac5c).

Il commit `1a0ffaf83786128679d856998250ab3e3451ac5c` aggiunge download
degli allegati di bacheca e hardening. Non modifica il protocollo dei compiti:

- nuovo endpoint per gli allegati, download HTTPS e isolamento dei token:
  non necessari a DiarioUp, che non implementa il download della bacheca;
- `ComunicazioneBacheca.pk`: non riguarda il modello dei compiti;
- password, token e verifier esclusi dalle rappresentazioni Python:
  le nostre credenziali sono già redatte e le sessioni Dart non stampano campi;
- HTTPS, cookie limitati al dominio e challenge URL-encoded: già implementati
  nel nostro login. Aggiunti test espliciti di regressione;
- validazione numerica della versione esterna: adottata nel monitor Python,
  nel controllo preliminare della build e nel client Dart prima degli header;
- eccezioni di download senza query firmate: il nostro codice non include
  URL o payload autenticati negli errori. Nessuna estensione dell'allowlist.

La validazione accetta da 2 a 4 componenti numeriche ASCII, massimo 32
caratteri; rifiuta testo, whitespace, CR/LF e tentativi di header injection.
La versione resta fornita tramite ambiente/dart-define, non hardcodata nel
codice dell'app. Client ID e redirect URI restano quelli della release precedente.

## Sentinella

Scansione completa: `2026-11-17T15:51:44Z`.

- wrapper: `1a0ffaf83786128679d856998250ab3e3451ac5c`;
- portaleargo-api: `d77c406e89a8b2601fec49b4c4c71f6a6a13caa3`, invariato;
- argo-family-dashboard: `c1384792a66d3ad27a767908fb94c51218c8bffc`, invariato;
- versione ufficiale: 1.30.3.

La baseline riconosce solo quanto analizzato, senza ignorare futuri commit.
Il controllo live ripetuto con la nuova baseline non genera ulteriori avvisi.
Restano invariati l'esclusione della sola issue #3 e i permessi del workflow.
La baseline deve essere committata e pubblicata su GitHub per avere effetto
sulla sentinella remota: non sono stati eseguiti commit, push o invii SMTP.

## Verifiche

111 test Flutter e 14 test Python superati; analisi statica senza segnalazioni
e formattazione Dart verificate. Sintassi Python compatibile con 3.10.
I nuovi test verificano versione 1.30.3 negli header applicativi, rifiuto delle
versioni malformate, blocco del downgrade HTTP su host Argo, cookie TLD respinti,
challenge con caratteri speciali e assenza di segreti nelle rappresentazioni.
Restano inclusi i test di database cifrato, persistenza sessione, profili,
condivisione e PDF. Nessuna modifica al loro codice funzionale o allo stile.

Non è stato eseguito un login live con credenziali personali né un test su
dispositivo fisico. Il keystore esistente non viene modificato o rigenerato.

## APK

- File: `dist/DiarioUp-1.8.0+18-release.apk`, 73.317.245 byte.
- Package `it.diarioup.diarioup`, versionName `1.8.0`, versionCode `18`.
- Client DidUP 1.30.3 verificato anche nel binario ARM64.
- Firma v2 valida e certificato confrontato con la release 1.7.2:
  `125217f5e46081a75f4e9decf0bd0f29c4ab204f9aefe5018f4047b952533fad`.
- APK non debuggable; asset Flutter, Inter, NativeAssetsManifest e icona
  promemoria verificati. Nessun test, fixture, PDF di prova, `.env` o file di firma.
- SHA-256 APK:
  `0F3579562A147FE620EC38A043EC1F9EAB4B18BED80ECCEB218A8ABEA1671798`.

Compilazione completata in 171,4 secondi. Le sole opzioni locali temporanee
Kotlin in-process / no incremental sono state rimosse al termine: nessuna
modifica residua a Gradle o alle dipendenze. Installabile sopra la 1.7.2 senza
disinstallazione. APK e keystore rimangono esclusi dal repository.
