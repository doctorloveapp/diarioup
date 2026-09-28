# DiarioUp — Manuale di test su dispositivo Android

Questa procedura valida la Fase 1.4 su un telefono fisico Android 9 o
successivo. Usare esclusivamente account e dati per i quali si dispone
dell'autorizzazione. Password, token, cookie e chiavi di firma non devono essere
copiati nel report di test.

## 1. Preparazione

1. Installare Flutter e Android SDK, quindi verificare `flutter doctor`.
2. Sul telefono attivare **Opzioni sviluppatore** e **Debug USB**.
3. Collegare il telefono via USB, accettare l'impronta del computer e verificare
   che `adb devices` lo mostri come `device`.
4. Preparare localmente il keystore descritto in `android/signing/README.md`.
   Il certificato deve usare l'identità pubblica prevista dal progetto; il file
   privato e le password non vanno inseriti nel repository.
5. Impostare nella sessione PowerShell le quattro variabili di firma:
   `DIARIOUP_ANDROID_KEYSTORE_PATH`,
   `DIARIOUP_ANDROID_KEYSTORE_PASSWORD`, `DIARIOUP_ANDROID_KEY_ALIAS` e
   `DIARIOUP_ANDROID_KEY_PASSWORD`.
6. Per una build `development` o `production`, impostare anche
   `DIDUP_OAUTH_CLIENT_ID`, `DIDUP_REDIRECT_URI` e `DIDUP_CLIENT_VERSION` con i
   valori approvati. Non usare parametri copiati dall'app ufficiale.

## 2. Creazione e installazione dell'APK

Da VS Code eseguire il task **DiarioUp: APK release per sideload**. Il task usa
l'ambiente `demo`. In alternativa, dalla radice del progetto:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\tool\build_sideload_release.ps1 -Environment demo
```

Per il collaudo autorizzato dell'integrazione sostituire `demo` con
`development`. Lo script interrompe il processo se la firma manca e verifica
l'APK con `apksigner`. L'artefatto finale si trova in
`dist/DiarioUp-<ambiente>-release-sideload.apk`.

Installare o aggiornare l'app:

```powershell
adb install -r .\dist\DiarioUp-demo-release-sideload.apk
```

Per un collaudo da installazione pulita, prima disinstallare DiarioUp dal
telefono. Questa operazione elimina i dati locali dell'app: eseguirla soltanto
se non devono essere conservati.

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

## 4. Verifiche di qualità sul dispositivo

- Aumentare la dimensione del testo dalle impostazioni Android e controllare che
  i contenuti principali restino leggibili senza sovrapposizioni.
- Attivare la rimozione delle animazioni e verificare che il flusso resti
  comprensibile.
- Provare orientamento verticale, schermo piccolo e tema chiaro/scuro.
- Con TalkBack, verificare nomi e stato dei controlli della checklist, dei
  filtri e dei pulsanti di creazione.
- Disattivare la rete durante una sincronizzazione: i dati già presenti non
  devono scomparire e deve essere disponibile un'azione di nuovo tentativo.

## 5. Esito del collaudo

Annotare: modello telefono, versione Android, versione DiarioUp, ambiente,
data/ora, esito dei quattro percorsi principali e riferimento all'eventuale
segnalazione. Allegare screenshot solo dopo aver oscurato nomi, scuola, testi
dei compiti e altri dati personali.

Il collaudo è superato quando non ci sono crash o perdite di dati, le operazioni
offline persistono dopo il riavvio e tutti i percorsi della sezione 3 risultano
OK. Una prova con dati demo non sostituisce il successivo test autorizzato del
protocollo DidUP.
