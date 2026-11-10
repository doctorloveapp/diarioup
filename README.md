# DiarioUp

DiarioUp è un'agenda Flutter indipendente che organizza i compiti DidUP in un
database locale cifrato. La UI legge esclusivamente dal database locale e resta
utilizzabile offline. Password, contenuti scolastici e log tecnici non vengono
inviati a servizi di analisi.

Versione corrente: **1.7.1+16**.

Il login SSO gestisce cookie temporanei per host/dominio e fino a quindici
passaggi, incluse le pagine HTML di consenso e i redirect relativi del portale.
Le pagine vengono interpretate senza eseguire JavaScript; il consenso resta
limitato al portale autorizzato e agli scope già richiesti.

## Installazione dell'APK

Il dispositivo deve usare Android 9 o successivo.

**Installazione**

1. Scarica il file **DiarioUpVer(x.x.x).apk** allegato nell'ultima release disponibile.
2. Trasferisci il file sul tuo dispositivo Android (versione minima richiesta: Android 9).

3. **Attiva le Opzioni sviluppatore** (necessarie su alcuni dispositivi):
   - Apri le **Impostazioni**.
   - Vai su **Informazioni sul telefono** (o **Informazioni sul dispositivo** / **Info sul software**).
   - Scorri fino a **Numero build** (o **Versione MIUI** / **Numero build** a seconda del produttore).
   - Tocca **7 volte** di seguito il **Numero build**.
   - Apparirà un messaggio che conferma l’attivazione delle **Opzioni sviluppatore**.
   - Torna indietro nelle Impostazioni: ora troverai la voce **Opzioni sviluppatore** (di solito in fondo o nella sezione Sistema).

4. **Autorizza l’installazione da fonti sconosciute**:
   - Vai su **Impostazioni → App → Accesso speciale → Installa app sconosciute**  
     *(oppure cerca “Installa app sconosciute”)*.
   - Seleziona l’app con cui aprirai l’APK (es. **File**, **Download**, **Chrome**, **Gestore file**).
   - Attiva **Consenti da questa fonte**.

5. Apri il file APK scaricato e procedi con l’installazione.
6. Al primo avvio inserisci le tue credenziali DidUP.

**Sicurezza**  
L’app è stata testata per garantire la sicurezza dei dati: le tue credenziali restano esclusivamente sul tuo dispositivo.

In alternativa, con Android Platform Tools e Debug USB abilitato:

```text
adb install -r dist/DiarioUp-production-release-sideload.apk
```

DiarioUp non contiene una modalità demo: ogni accesso viene verificato dal
servizio DidUP. Una nuova installazione parte con il diario vuoto. Dopo il primo
accesso, la sessione viene ripristinata dal Secure Storage: la password non viene
salvata e non deve essere reinserita a ogni apertura.

## Uso e condivisione

Dopo onboarding e accesso, la scheda **Diario** mostra i compiti per scadenza;
**Materie** li raggruppa per materia, **Orario** mostra la settimana scolastica
e **Impostazioni** gestisce foto profilo, sfondo del diario, colori dell'app,
promemoria, aggiornamenti, privacy ed esportazione dati.

Nella scheda **Orario**, toccare una lezione per associarle la materia e un
colore. Il selettore in alto alterna i nomi dei professori e delle materie; le
modifiche restano disponibili offline nel database cifrato. Il pulsante **X**
torna rapidamente al Diario.

Il controllo aggiornamenti è attivo per impostazione predefinita e consulta in
background soltanto la release pubblica più recente su GitHub. Se esiste una
versione successiva, DiarioUp propone il link ufficiale senza bloccare l'avvio.
Il controllo può essere disattivato in **Impostazioni**.

Per condividere i compiti, toccare l'icona **Condividi** nella Dashboard,
scegliere **Settimana corrente**, **Settimana prossima**, giorno o materia e
confermare **Crea e condividi PDF**. La settimana prossima comprende le
scadenze dal prossimo lunedì alla domenica successiva.
Con **Materia specifica** si possono scegliere più materie, anche con
**Seleziona tutte** / **Deseleziona tutte**. Il PDF le raggruppa in sezioni,
con nome della materia ripetuto sulle pagine successive e compiti in ordine di
scadenza dentro ciascuna sezione. Non ci sono limiti di data: sono inclusi
compiti passati, presenti, futuri e senza scadenza, inclusi quelli completati.
Titolo e nome file indicano esplicitamente l'intero storico di tutte le settimane;
il titolo include la data di creazione. Ogni PDF riporta classe e sezione del
profilo interessato, recuperate da Argo e conservate nel secure storage per
la condivisione offline. Se assenti, compare «Classe non disponibile».
Settimana e Giorno mantengono l'ordine cronologico e includono anche i completati.
Le note personali restano sempre escluse. Il PDF
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

Il Watchdog esclude esclusivamente gli aggiornamenti dell'issue
`Rocciadura/didupAPI-wrapper#3`, affrontata nelle release `1.6.0+13` e `1.6.1+14`.
L'esclusione è dichiarata in `IGNORED_ISSUES` in `scripts/monitor_didup.py`:
le altre issue, anche quelle con numero 3 in repository diversi, i cambiamenti
ai file e le nuove versioni DidUP restano monitorati. Per riprendere gli avvisi
di quell'issue, rimuovere la sua coppia repository/numero dall'elenco.

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
