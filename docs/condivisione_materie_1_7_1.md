# Correzione storico condiviso — DiarioUp 1.7.1+16

## Problema e correzione

La 1.7.0 applicava `!item.isDone` alle esportazioni per materia, sia nel
caso d'uso sia nel generatore PDF. La data odierna non era un filtro, ma se
gli altri compiti erano completati rimaneva nel PDF soltanto il compito da
fare oggi. Il test di regressione riproduce questo caso: il vecchio filtro
esporta **1 elemento invece dei 5 attesi**.

La 1.7.1 esporta tutti i compiti delle materie selezionate presenti nel
database del profilo attivo: passati, presenti, futuri, senza scadenza e
completati. Non applica la checklist personale, i filtri della Dashboard
o finestre temporali. Le note personali restano escluse. La correzione non
modifica sincronizzazione, protocollo di autenticazione, database o promemoria.

Una o più materie mantengono lo stesso comportamento: sezioni alfabetiche
con compiti cronologici al loro interno. Settimana corrente, Settimana
prossima e Giorno specifico rimangono invariati.

## Titolo e nome file

Intestazione, riepilogo e metadati del PDF per materie riportano:

> Materie selezionate (N) - Tutte le settimane · Intero storico · Creato il GG/MM/AAAA

Con una materia compare il suo nome. La data è quella di generazione locale,
non una data iniziale o finale del filtro. Il footer conserva data e ora.

Nomi file:

- `materia_<nome>_intero_storico_<gg_mm_aaaa>.pdf`;
- `materie_<numero>_intero_storico_<gg_mm_aaaa>.pdf`.

Font Inter, logo, colori, tabelle, separatori e numerazione restano quelli
approvati. Il pannello di condivisione esplicita l'inclusione dei completati.

## Verifiche

Classe e sezione sono lette da `scheda.classe.desDenominazione` e `desSezione`
del profilo autenticato, secondo lo
[schema di portaleargo-api](https://github.com/DTrombett/portaleargo-api/blob/main/src/schemas/index.ts).
Sono conservate per profilo nella sessione protetta da `flutter_secure_storage`,
con decodifica compatibile con le sessioni precedenti. Le vecchie sessioni
vengono arricchite chiamando `/profilo` alla condivisione; il client rinnova il
token se necessario e verifica l'identificativo del profilo ricevuto.
La cache non cambia il figlio attivo e non ripristina token obsoleti o una
sessione eliminata dal logout. In assenza di rete o metadati il PDF indica
«Classe non disponibile», senza usare dati di un altro figlio.

- Test integrato con normalizzazione, repository reale, Drift e generatore
  PDF reale: due materie, 5 compiti, 4 completati, solo quello odierno da fare.
  Tutti e 5 arrivano alla condivisione; selezionando la sola materia Italiano
  sono esportati tutti e 3 i suoi compiti, inclusi passato e futuro completati.
- Il test è stato eseguito con il filtro precedente: fallisce con 1 anziché
  5 compiti; ripristinata la correzione, passa.
- Suite completa: 92 test superati; analisi statica senza segnalazioni;
  formattazione e `git diff --check` del codice verificati. Le modifiche
  concomitanti dell'utente alle istruzioni di installazione nel README sono
  preservate, inclusi i due spazi Markdown per l'interruzione di riga.
- PDF campione multipagina: 72 attività uniche, compreso il completato;
  data passata 2024, futura 2030 e senza scadenza presenti; nota privata assente.
- Campioni reali generati dal codice Dart renderizzati con Poppler e controllati
  visivamente per stile, titolo con data, paginazione e transizione fra materie.
- Test su due figli di classi diverse, persistenza della classe nel codec di
  sessione, recupero per vecchie sessioni, refresh token, profilo errato,
  indisponibilità della rete e logout durante la richiesta. La classe è
  stampata nell'intestazione su ogni pagina e in tutte le modalità di export.

I campioni sono sintetici, facoltativi (`DIARIOUP_PDF_REVIEW=true`), temporanei
e non inclusi nell'APK. Non è stato eseguito un test su dispositivo fisico
durante questa correzione.

## Release verificata

- File: `dist/DiarioUp-1.7.1+16-release.apk`.
- Package `it.diarioup.diarioup`, versionName `1.7.1`, versionCode `16`.
- Firma APK v2 valida; stesso certificato delle release precedenti:
  SHA-256 `125217f5e46081a75f4e9decf0bd0f29c4ab204f9aefe5018f4047b952533fad`.
- APK non debuggable; asset obbligatori, font e icona dei promemoria verificati;
  nessun fixture, test, PDF di prova o materiale di firma nel pacchetto.
- SHA-256 APK:
  `7D832CD7ED0A952F633879CD2DEDBEBCCEC4BE8F4A52B44DBB5096173C1FA3EE`.

I campioni sintetici usati per la verifica visiva sono stati rimossi e possono
essere rigenerati con `DIARIOUP_PDF_REVIEW=true` nei test di repository/PDF.
