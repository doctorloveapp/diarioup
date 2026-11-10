# Condivisione per materie — DiarioUp 1.7.0+15

> Documento storico della 1.7.0. L'esclusione dei completati qui descritta è
> stata rimossa nella [correzione 1.7.1+16](condivisione_materie_1_7_1.md),
> che condivide l'intero storico e aggiunge la data di creazione al titolo.

## Comportamento

| Scelta | Intervallo | Completati | Ordinamento PDF |
| --- | --- | --- | --- |
| Settimana corrente / prossima | Settimana selezionata, lunedì-domenica | Inclusi, come prima | Cronologico |
| Giorno specifico | Giorno scelto | Inclusi, come prima | Cronologico |
| Materia specifica, singola o multipla | Nessun limite di data, inclusi passati e senza scadenza | Esclusi | Materie alfabetiche, scadenze all'interno di ogni materia, senza scadenza in fondo |

Il pannello offre caselle per tutte le materie, Seleziona tutte / Deseleziona
tutte e conferma disabilitata quando non è selezionata alcuna materia.
Con selezioni vuote o solo compiti completati non viene condiviso un PDF vuoto.
Le note personali restano escluse in tutte le modalità.

La selezione è immutabile nel Domain. Il filtro determina i compiti prima della
generazione; il generatore applica lo stesso filtro alle esportazioni per
materia anche quando viene invocato direttamente. Nessuna query o regola di
business è introdotta nei widget. Database e rete non cambiano.

## Stile preservato

Inter, logo, A4, margini, palette indaco, righe alternate, date con giorno della
settimana e footer restano quelli del PDF esistente. Le sezioni per materia
usano due colonne (Testo / Scadenza), evitando di ripetere la materia in ogni
riga; il nome della materia è evidenziato nell'intestazione e si ripete quando
la sezione prosegue su un'altra pagina. La tabella cronologica mantiene le sue
tre colonne originali. Per gli storici per materia il limite tecnico di
paginazione è esteso da 20 a 200 pagine.

Il nome del file singolo resta `materia_<nome>_dal_<data>.pdf`; con più materie
è `materie_<numero>_selezionate_dal_<data>.pdf`. I file condivisi restano
temporanei e sono eliminati dal servizio di condivisione esistente.

## Verifiche

- Analisi statica senza segnalazioni; formattazione controllata.
- Suite Flutter completa: **83 test superati**.
- Test del filtro su materie multiple, completati, altre materie, date storiche,
  odierne, future e assenti; test di selezione vuota e contenuto passato al PDF.
- Widget test su viewport 360×640 con 12 materie, seleziona/deseleziona tutte,
  selezione del primo e ultimo elemento e conferma sempre accessibile.
- PDF campione di 5 pagine con 71 compiti: tutte le pagine renderizzate con
  Poppler e ispezionate visivamente. Controllati font, allineamenti, separatori,
  paginazione e passaggio fra materie, senza sovrapposizioni o testo tagliato.
- Testo estratto dal PDF: 71 elementi unici, gruppi contigui, intestazioni e
  footer presenti; completato e nota personale sintetici assenti; date 2024,
  2030 e scadenza assente conservate.
- Test aggiuntivo di generazione con 400 compiti e storico superiore a 20 pagine.

Per rigenerare i soli campioni sintetici di controllo (non usano dati utente):

```text
flutter test test/data/sharing/diarioup_pdf_generator_test.dart --dart-define=DIARIOUP_PDF_REVIEW=true
```

I campioni sono scritti sotto `tmp/pdfs/`, esclusa da Git. Le regole permanenti
di conservazione dello stile e dell'intervallo temporale sono in `AGENTS.md`.

## APK

`dist/DiarioUp-1.7.0+15-release.apk`: versionName `1.7.0`, versionCode `15`,
firma v2 valida e certificato identico alla 1.6.1. APK non debuggable,
asset Flutter e icona promemoria verificati; nessun test, fixture, PDF di prova,
file `.env` o materiale di firma incluso. Nessuna nuova migrazione database.

SHA-256: `9F8A35923C68075FF521DAE0742E6CC8646FB1A63E437B6EC0F13FC572506D48`.
La compilazione locale usa temporaneamente Kotlin in-process senza cache
incrementali; le opzioni sono rimosse dopo la build e non cambiano Gradle
versionato. I campioni temporanei di verifica sono stati rimossi.
