# Audit compatibilità DidUP — 13 novembre 2026

## Esito

Il diff segnalato **non introduce una rottura del protocollo**: endpoint,
parametri OAuth/PKCE, formato dei compiti e selezione dei profili non cambiano.
Introduce tolleranza ai server lenti e una classificazione degli errori di
trasporto. DiarioUp non dipende dal pacchetto Python: non occorre sostituire
il nostro login con quello upstream.

La release richiesta **1.7.2+17** adotta il miglioramento di resilienza con
una politica di ripetizione conservativa, esplicita e testata.

## Fonti analizzate

[Diff del wrapper](https://github.com/Rocciadura/didupAPI-wrapper/compare/4642af88e347f69364e700d55fbd3d9dc41c2f61...e74b1aad67e956913d4398319b30869a66e8d149),
verificato integralmente tramite API GitHub:

- `369907994622fc80b55a40b8aa69ba2ececa13e8`: versione pacchetto 0.2.1;
- `e74b1aad67e956913d4398319b30869a66e8d149`: timeout configurabile, default
  60 secondi, conversione degli errori di trasporto in `NetworkError` o
  `RequestTimeoutError`, retry con attese 1/2 secondi su rete e 502/503/504;
  nuovi test in `tests/test_rete.py` e gestione di questi errori nel poller;
- nessuna variazione a redirect URI, client ID, payload di login o compiti.

Sono state controllate anche le altre fonti della sentinella:

- App Store: **1.30.2**, invariata; mantenuta la configurazione di produzione
  già usata da DiarioUp. Il default 1.29.2 del wrapper non viene copiato;
- [portaleargo-api](https://github.com/DTrombett/portaleargo-api/compare/df846555471f95836450c8af84e4efde11e3cb08...d77c406e89a8b2601fec49b4c4c71f6a6a13caa3):
  aggiornamento di dipendenze di sviluppo nel lockfile, senza modifiche al
  protocollo TypeScript;
- Home Assistant: HEAD `c1384792a66d3ad27a767908fb94c51218c8bffc`, invariata.

## Modifiche DiarioUp

- Timeout di ricezione da 20 a **60 secondi**, anche nel trasporto OAuth;
  connessione 10 secondi e invio 20 secondi rimangono invariati.
- `DidupReadRetry`, isolato nel Data layer e iniettabile nei test: al massimo
  due nuovi tentativi dopo il primo, con attese 1 e 2 secondi, **solo** su
  timeout, errore di connessione e HTTP 502/503/504.
- Il retry è attivato esplicitamente per dashboard (POST di sola lettura)
  e profilo (GET), anche quando si carica il profilo dopo il login.
- Nessun replay automatico di credenziali SSO, consenso, authorization code,
  login applicativo o refresh token. Queste operazioni possono avere effetti
  sullo stato della sessione o consumare valori monouso.
- 400/401/403/404/410/429, HTTP 500/501, certificati non validi,
  cancellazioni e destinazioni non ammesse non sono ritentati dalla politica.
  Il flusso esistente di rinnovo dopo 401 rimane distinto e limitato.
- Il backoff è cancellabile e il timer viene sempre rimosso.
- `RequestTimeoutFailure` distingue server lento da credenziali rifiutate;
  i dettagli Dio, URL, token, cookie e payload non arrivano a UI o diagnostica.
- Timeout e guasti temporanei non eliminano la sessione salvata. I rifiuti
  espliciti del rinnovo conservano invece il comportamento di invalidazione.
- Nessuna modifica a database, normalizzazione, PDF, personalizzazioni,
  notifiche, profili multipli o configurazione pubblica OAuth.

## Sentinella

La baseline avanza ai commit esaminati e alla scansione completa delle
`2026-11-13T14:01:31Z`. Non si escludono file o future modifiche: si riconoscono
solo gli SHA già analizzati. Il monitoraggio live ripetuto con la nuova baseline
non produce più i tre avvisi della mail. Nessuna email è stata inviata nel
corso dell'audit.

`tests/test_rete.py` è ora ad alta priorità; issue relative a timeout,
502/503/504 ed errori di rete sono classificate come alte. L'eccezione
per la sola `Rocciadura/didupAPI-wrapper#3` resta invariata. Nessun cambiamento
a Secrets SMTP, permessi GitHub Actions o schedulazione del workflow.

## Verifiche

- Suite Flutter completa: **106 test superati**.
- Analisi statica senza errori, warning o info; `dart format` verificato.
- Test Python della sentinella: **13 superati**.
- Test di retry transitorio/persistente, limite tentativi, backoff e cancellazione.
- Test di assenza retry su rifiuti, rate limit, errori TLS e operazioni OAuth
  monouso; timeout nel rinnovo senza cancellare la sessione.
- Test di login, PKCE/state, cookie, recupero profilo senza ripetere OAuth,
  distinzione dei messaggi UI e mancata autenticazione su errore.
- Restano inclusi i test di persistenza cifrata, migrazioni, condivisione
  storico, PDF, classe specifica per figlio e notifiche.

Non è stato eseguito un login live con credenziali personali o un collaudo
su dispositivo fisico. I test simulano il trasporto senza salvare password.

## APK consegnata

- `dist/DiarioUp-1.7.2+17-release.apk`, 73.317.245 byte.
- Package `it.diarioup.diarioup`, versionName `1.7.2`, versionCode `17`.
- Firma v2 valida e certificato confrontato con `dist/DiarioUp1.7.1.apk`:
  SHA-256 `125217f5e46081a75f4e9decf0bd0f29c4ab204f9aefe5018f4047b952533fad`.
- APK non debuggable; controlli del bundle Flutter, Inter, Material Icons,
  NativeAssetsManifest e icona Android dei promemoria superati.
- Nessun fixture, test, PDF di prova, `.env`, keystore o file di firma
  nell'archivio. La nuova gestione dei timeout è presente nel binario ARM64.
- SHA-256 APK:
  `746A0D42643667666B83E1D3741592FA0D6B104BE321D80E9BE5C21A507C9FA6`.

La build ha completato il fallback automatico del compilatore Kotlin dopo
l'errore delle cache incrementali fra i percorsi C:/W:; lo script è terminato
con successo e firma/asset sono stati verificati successivamente. Nessuna
configurazione Gradle versionata, dipendenza o chiave di firma è stata cambiata.

L'APK può essere installata sopra la versione precedente senza disinstallare.
Baseline e regole del watchdog sono aggiornate **localmente**: per applicarle
alle esecuzioni GitHub Actions occorre pubblicare anche le modifiche ai sorgenti
del repository. Durante questa attività non sono stati eseguiti commit, push
o pubblicazioni di release su GitHub.
