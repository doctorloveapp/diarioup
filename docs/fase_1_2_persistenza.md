# Fase 1.2 — Persistenza e sincronizzazione

Stato: **implementata e verificata**.

## Scelte implementative

- Drift è la sola sorgente dati della dashboard. La UI osserva query reattive e
  non usa direttamente i payload DidUP.
- Il runtime SQLite è `sqlite3` con sorgente `sqlite3mc`, selezionata dagli hook
  dichiarati nel `pubspec.yaml`.
- La chiave casuale a 256 bit viene creata una sola volta e conservata con
  `flutter_secure_storage`. Il database applica `PRAGMA key` prima di leggere lo
  schema e interrompe l'apertura se il runtime non espone `PRAGMA cipher`.
- Password, token e cookie non entrano nello schema. `ArgoConnections` conserva
  soltanto il riferimento logico al secret store.
- La checklist vive in `Completions`, separata dai dati remoti. Una nuova
  revisione del compito non modifica `isDone`; la UI espone invece lo stato
  `changedAfterCompletion` confrontando le revisioni.
- Le identità dei compiti DidUP privi di ID figlio sono stabilizzate dalla
  tabella `HomeworkIdentityMappings`, anch'essa cifrata.

## Atomicità della sincronizzazione

Download e rinnovo sessione avvengono prima della scrittura. Normalizzazione,
risoluzione delle identità, upsert dei record sorgente, materie, compiti,
scadenze e avanzamento di `SyncStates` avvengono nella stessa transazione Drift.
Un errore esegue il rollback e registra soltanto un codice di categoria privo di
dati sensibili; cursore e ultimo successo non avanzano.

Le cancellazioni remote sono soft-delete. In questo modo le relazioni locali e
i completamenti non vengono persi e restano recuperabili per riconciliazioni
successive.

## Schema e migrazioni

Lo schema corrente è `schemaVersion = 2`: la migrazione da v1 aggiunge la nota
personale al compito senza perdere contenuto o checklist. Gli snapshot
verificabili sono in `drift_schemas/app_database/`; `build.yaml` configura Drift
per produrre i successivi snapshot. Ogni aumento di versione deve:

1. aggiungere il passo esplicito in `AppDatabase.migration`;
2. eseguire `dart run drift_dev make-migrations`;
3. mantenere UUID e righe `Completions` durante la trasformazione;
4. aggiungere un test di upgrade dalla versione precedente;
5. eseguire `PRAGMA foreign_key_check`, già applicato dopo creazione e upgrade.

L'assenza di un passo esplicito causa un errore intenzionale: il database non
viene mai aggiornato implicitamente o ricreato perdendo dati.

Nota toolchain: la combinazione locale Flutter 3.38 / Dart 3.10 esegue app,
test e build native, ma `build_runner` non sa ancora compilare un build hook
Native Assets durante la rigenerazione. Le future modifiche allo schema vanno
quindi generate con Dart 3.11 o successivo; i sorgenti generati e lo snapshot
delle versioni 1 e 2 sono inclusi nel repository.

## Verifiche automatiche

- riapertura di un file SQLite3MC con la stessa chiave;
- persistenza di compiti, scadenze e checklist dopo la riapertura;
- assenza dell'header `SQLite format 3` nel file cifrato;
- sincronizzazione atomica con identità stabile;
- conservazione del completamento dopo una modifica remota;
- aggiornamento reattivo della dashboard tramite Riverpod e stream Drift.
