# DiarioUp — Manuale di test su dispositivo Android

Questa procedura valida le Fasi 1.4 e 1.5 su un telefono fisico Android 9 o
successivo. Usare esclusivamente account e dati per i quali si dispone
dell'autorizzazione. Password, token, cookie e chiavi di firma non devono essere
copiati nel report di test.

## 1. Preparazione

1. Installare Flutter e Android SDK, quindi verificare `flutter doctor`.
2. Sul telefono attivare **Opzioni sviluppatore** e **Debug USB**.
3. Collegare il telefono via USB, accettare l'impronta del computer e verificare
   che `adb devices` lo mostri come `device`.
4. Verificare che sia disponibile localmente il keystore descritto in
   `android/signing/README.md`. Il certificato deve usare l'identità pubblica
   prevista dal progetto; file privato e password non vanno inseriti nel
   repository.
5. Impostare nella sessione PowerShell le quattro variabili di firma:
   `DIARIOUP_ANDROID_KEYSTORE_PATH`,
   `DIARIOUP_ANDROID_KEYSTORE_PASSWORD`, `DIARIOUP_ANDROID_KEY_ALIAS` e
   `DIARIOUP_ANDROID_KEY_PASSWORD`.
6. Per la build `production`, impostare anche
   `DIDUP_OAUTH_CLIENT_ID`, `DIDUP_REDIRECT_URI` e `DIDUP_CLIENT_VERSION` con i
   valori approvati. Non usare parametri copiati dall'app ufficiale.

## 2. Creazione e installazione dell'APK

Da VS Code eseguire il task **DiarioUp: APK release per sideload**. In
alternativa, dalla radice del progetto:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tool\build_sideload_release.ps1 -Environment production
```

Lo script interrompe il processo se firma o configurazione DidUP mancano e
verifica l'APK con `apksigner`. L'artefatto finale si trova in
`dist/DiarioUp-<ambiente>-release-sideload.apk`.

Installare o aggiornare l'app:

```powershell
adb install -r .\dist\DiarioUp-production-release-sideload.apk
```

Per un collaudo da installazione pulita, prima disinstallare DiarioUp dal
telefono. Questa operazione elimina i dati locali dell'app: eseguirla soltanto
se non devono essere conservati.

L'installazione con `adb install` non richiede l'abilitazione delle origini
sconosciute. Se invece si apre l'APK da un file manager, Android richiede di
autorizzare **Installa app sconosciute** soltanto per quell'app sorgente. Il
Debug USB serve esclusivamente all'installazione e alla diagnostica via ADB,
non al normale funzionamento di DiarioUp.

## 3. Percorso funzionale

Registrare per ogni passaggio **OK**, **KO** e una nota priva di dati personali.

1. **Onboarding e accesso**
   - Aprire l'app e completare onboarding e login.
   - Verificare che il campo password non venga ripopolato dopo essere usciti e
     rientrati nell'app.
   - In ambiente reale, verificare che una sessione scaduta richieda nuovamente
     l'accesso lasciando consultabile il diario locale.
2. **Agenda e filtri**
   - Verificare le sezioni Oggi, Domani, Prossimi giorni e Senza scadenza.
   - Controllare le etichette `Oggi`, `Domani`, `Tra N giorni` e gli stati
     scaduti cambiando le date dei compiti manuali.
   - Alternare i filtri **Da fare** e **Completati** e verificare che nessun
     compito compaia nel gruppo errato.
3. **Checklist e Annulla**
   - Spuntare un compito e verificare il messaggio di conferma.
   - Toccare **Annulla** nello snackbar e verificare il ripristino immediato.
   - Spuntarlo di nuovo, chiudere e riaprire l'app: deve restare completato.
4. **Materie**
   - Aprire la scheda **Materie**.
   - Verificare colore, numero totale e numero di compiti da fare.
   - Espandere ogni materia e aprire uno dei compiti associati.
5. **Dettaglio compito**
   - Verificare testo completo, data sorgente, scadenza, origine e ultimo
     aggiornamento.
   - Inserire una nota personale, salvarla, chiudere e riaprire il dettaglio.
   - Eseguire una sincronizzazione: la nota e la checklist non devono cambiare.
6. **Inserimento manuale**
   - Creare una materia con un colore distinto.
   - Creare un compito manuale associato, con scadenza e nota.
   - Verificare la comparsa immediata sia in Agenda sia in Materie.
   - Attivare la modalità aereo, chiudere e riaprire l'app: materia, compito,
     nota e stato della checklist devono restare disponibili.
7. **Correzioni di interfaccia**
   - Nel dettaglio verificare, anche con testo grande e schermo stretto, che
     `Data sorgente`, `Scadenza`, `Origine` e `Ultimo aggiornamento` non siano
     spezzati a metà parola.
   - Spuntare un compito e, mentre lo snackbar è visibile, verificare che il
     pulsante **Salva nota** resti accessibile.
   - Aprire la tastiera nella nota personale, scorrere il contenuto e salvare:
     campo e pulsante non devono essere coperti.
   - Verificare nel launcher Android che sia mostrato il logo DiarioUp e non
     l'icona Flutter.

## 4. Promemoria locali

I promemoria sono disattivati per impostazione iniziale. Non deve comparire
alcuna richiesta di permesso durante onboarding o login.

1. Creare un compito non completato con scadenza domani. Aprire
   **Impostazioni**, attivare **Promemoria** e concedere il permesso quando
   Android lo richiede. Su Android 13 o successivo la richiesta runtime è
   obbligatoria; sulle versioni precedenti lo stato dipende dalle impostazioni
   di sistema.
2. Impostare temporaneamente l'orario a 2-5 minuti nel futuro, sempre fra le
   07:00 e le 20:59. Portare l'app in background e bloccare lo schermo. Gli
   allarmi sono intenzionalmente non esatti: con Doze o risparmio energetico la
   consegna può avvenire con alcuni minuti di ritardo.
3. Verificare che titolo e testo siano soltanto `DiarioUp` e
   `Hai attività da controllare in DiarioUp`: materia, testo del compito, nome
   dello studente e altri dati scolastici non devono apparire nella schermata
   bloccata.
4. Completare l'unico compito interessato prima dell'orario scelto: il relativo
   promemoria non deve arrivare. Annullare il completamento e verificare che la
   pianificazione venga ricreata.
5. Cambiare l'orario nelle impostazioni e ripetere la prova. Gli orari nella
   fascia di quiete 21:00-07:00 devono essere rifiutati.
6. Negare il permesso oppure disattivarlo dalle impostazioni Android. Agenda,
   checklist e sincronizzazione devono continuare a funzionare; DiarioUp deve
   mostrare lo stato negato e offrire l'apertura delle impostazioni di sistema,
   senza riproporre automaticamente il dialogo.
7. Riavviare il telefono con un promemoria futuro pianificato e verificare che
   venga ripristinato. Cambiare fuso orario, riaprire DiarioUp e verificare che
   l'orario resti riferito all'ora locale del dispositivo.
8. Verificare che compiti completati, scaduti o privi di scadenza non generino
   avvisi. Se il produttore applica restrizioni aggressive in background,
   annotare modello e impostazioni di risparmio energetico nel report.

## 5. Verifiche di qualità sul dispositivo

- Aumentare la dimensione del testo dalle impostazioni Android e controllare che
  i contenuti principali restino leggibili senza sovrapposizioni.
- Attivare la rimozione delle animazioni e verificare che il flusso resti
  comprensibile.
- Provare orientamento verticale, schermo piccolo e tema chiaro/scuro.
- Con TalkBack, verificare nomi e stato dei controlli della checklist, dei
  filtri e dei pulsanti di creazione.
- Disattivare la rete durante una sincronizzazione: i dati già presenti non
  devono scomparire e deve essere disponibile un'azione di nuovo tentativo.

## 6. Esito del collaudo

Annotare: modello telefono, versione Android, versione DiarioUp, ambiente,
data/ora, esito dei percorsi funzionali e dei promemoria, stato del permesso e
riferimento all'eventuale segnalazione. Allegare screenshot solo dopo aver
oscurato nomi, scuola, testi dei compiti e altri dati personali.

Il collaudo è superato quando non ci sono crash o perdite di dati, le operazioni
offline persistono dopo il riavvio, tutti i percorsi della sezione 3 risultano
OK e i casi permesso negato, consegna, completamento, reboot e cambio fuso della
sezione 4 sono stati verificati. Il collaudo DidUP deve usare esclusivamente un
account autorizzato e dati opportunamente minimizzati nel report.
