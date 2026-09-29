# DiarioUp

DiarioUp è un'agenda Flutter indipendente che organizza i compiti DidUP in un
database locale cifrato. La UI legge esclusivamente dal database locale e resta
utilizzabile offline. Password, contenuti scolastici e log tecnici non vengono
inviati a servizi di analisi.

Versione corrente: **1.3.1+6**.

## Installazione dell'APK

Il dispositivo deve usare Android 9 o successivo.

1. Scaricare sul telefono l'APK release fornito dal team DiarioUp.
2. Aprire il file dal gestore download o file.
3. Se Android lo richiede, consentire temporaneamente **Installa app
   sconosciute** solo all'app con cui si sta aprendo l'APK.
4. Confermare l'installazione e poi revocare il permesso, se non serve più.

In alternativa, con Android Platform Tools e Debug USB abilitato:

```text
adb install -r dist/DiarioUp-production-release-sideload.apk
```

DiarioUp non contiene una modalità demo: ogni accesso viene verificato dal
servizio DidUP. Una nuova installazione parte con il diario vuoto. Dopo il primo
accesso, la sessione viene ripristinata dal Secure Storage: la password non viene
salvata e non deve essere reinserita a ogni apertura.

## Uso e condivisione

Dopo onboarding e accesso, la scheda **Agenda** mostra i compiti per scadenza;
**Materie** li raggruppa per materia e **Impostazioni** gestisce foto profilo,
sfondo del diario, colori dell'app, promemoria, privacy ed esportazione dati.

Per condividere i compiti, toccare l'icona **Condividi** nella Dashboard,
scegliere settimana, giorno o materia e confermare **Crea e condividi PDF**.
La condivisione include anche i compiti segnati come completati, perché lo stato
della checklist è personale; le note personali restano sempre escluse. Il PDF
mostra il giorno della settimana accanto a ogni scadenza e usa un nome file
descrittivo basato sulla selezione. Viene creato nell'area temporanea dell'app e
cancellato quando il foglio di condivisione si chiude.

## Segnalazione bug

Aprire una segnalazione nelle
[GitHub Issues](https://github.com/doctorloveapp/diarioup/issues) indicando:

- versione DiarioUp visibile in **Impostazioni → Info & Privacy**;
- modello del dispositivo e versione Android/iOS;
- passaggi essenziali per riprodurre il problema;
- ultimo errore mostrato nel **Log di diagnostica**, se presente.

Non pubblicare password, cookie, token, codici scuola, nomi di studenti o testi
dei compiti. Prima di allegare uno screenshot, oscurare ogni dato personale.

## Sviluppo e verifiche

Il progetto segue `Presentation → Domain ← Data`; Drift cifrato è la single
source of truth. Per la verifica locale:

```text
flutter pub get
flutter analyze
flutter test
```

L'esecuzione dell'app richiede i Dart define `DIDUP_OAUTH_CLIENT_ID`,
`DIDUP_REDIRECT_URI` e `DIDUP_CLIENT_VERSION`, forniti tramite configurazione
locale o CI e mai incorporati nel repository.

Per creare un APK release firmato, impostare i segreti descritti in
`android/signing/README.md` e avviare:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tool\build_sideload_release.ps1 -Environment production
```

La procedura estesa di collaudo è in `docs/manuale_test_dispositivo.md`. Le
verifiche legali e live indicate nel piano restano gate necessari prima di una
distribuzione pubblica.
