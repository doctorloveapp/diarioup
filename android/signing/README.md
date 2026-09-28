# Firma Android DiarioUp

Questa directory contiene solo documentazione e template non sensibili. Il keystore reale, le password e i file di proprietà locali devono restare fuori dal repository o essere forniti dalla CI tramite secret manager.

## Identità del certificato

Per il certificato di firma Android usare i seguenti metadati pubblici:

```text
CN=Dan King, STREET=Via Roma 1, L=Roma, C=IT
```

L'indirizzo è un attributo del certificato (`STREET`), non una chiave o una credenziale. Prima di una release verificare il subject del certificato e la corrispondenza con l'identità prevista.

## Regole operative

- Non committare mai `key.properties`, keystore, password, certificati privati o file esportati dalla CI.
- Fornire i percorsi e i segreti tramite variabili d'ambiente o secret store della pipeline.
- Mantenere separati keystore di debug, staging e produzione.
- Registrare in modo sicuro alias, fingerprint pubbliche e scadenze; non registrare mai le password.

La configurazione Gradle legge già le quattro variabili `DIARIOUP_ANDROID_*`.
Il task `DiarioUp: APK release per sideload` compila, verifica la firma e rifiuta
un certificato che non contenga tutti i metadati pubblici indicati sopra.
