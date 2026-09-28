# Fase 1.4 — Prodotto principale

Stato: **implementata; collaudo hardware guidato predisposto**.

## Funzioni consegnate

- Agenda reattiva alimentata soltanto dal database Drift, con ricerca per testo,
  materia o nota e filtri separati **Da fare** / **Completati**.
- Raggruppamento per Oggi, Domani, Prossimi giorni e Senza scadenza; countdown a
  giorni di calendario senza introdurre orari fittizi.
- Vista Materie con colore, conteggi e compiti associati.
- Dettaglio del compito con testo completo, data sorgente, scadenza, origine,
  ultimo aggiornamento, checklist e nota personale.
- Creazione locale di materie e compiti, disponibile anche quando DidUP o la
  rete non sono raggiungibili.
- Conferma tramite snackbar con azione **Annulla** dopo il completamento.

## Persistenza e sincronizzazione

Lo schema Drift v2 aggiunge `personalNote` a `HomeworkItems`. Il valore viene
preservato negli upsert remoti, come il completamento che rimane nella tabella
separata `Completions`. Materie e compiti manuali usano UUID locali e
`origin=manual`; non vengono inviati a DidUP.

Le query di agenda, dettaglio e materie sono stream Drift esposti al livello
Presentation tramite provider Riverpod tipizzati. La UI non interroga la rete e
continua quindi a mostrare i dati consolidati durante errori o assenza di rete.

## Verifiche

La suite automatica copre countdown, creazione manuale, nota, checklist,
conteggi per materia, conservazione della nota dopo sync e migrazione v1→v2 con
dati esistenti. Il task VS Code **DiarioUp: APK release per sideload** invoca
`tool/build_sideload_release.ps1`, richiede la firma release e verifica
l'artefatto con `apksigner`.

Il test su telefono richiede il keystore privato, che per policy non è incluso
nel repository. La procedura e i criteri di superamento sono descritti in
`docs/manuale_test_dispositivo.md`.
