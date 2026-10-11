# Analisi compatibilità DidUP — 11 ottobre 2026

## Decisione

Nessuna modifica al client Dio e nessuna nuova release necessaria per questo
avviso. Il commit upstream aggiunge una funzionalità mancante nel wrapper
Python; non introduce un cambiamento del protocollo Argo.

## Evidenze upstream

- [Diff esaminato](https://github.com/Rocciadura/didupAPI-wrapper/compare/e98a9a67f4d1770ecda271e7a981efadd4d26e20...03be218248fd6b5125df7e5f1a52bea6cf97ce90).
- Il commit `03be218248fd6b5125df7e5f1a52bea6cf97ce90` conserva tutti gli elementi
  di `POST login`, aggiunge `Profilo`, `get_profili()` e `seleziona_profilo()`.
- Ogni figlio viene letto con `GET profilo`, usando il suo `x-auth-token` e
  `x-cod-min`; il cambio figlio invalida la cache della dashboard. La selezione
  viene mantenuta quando il wrapper ripete il login.
- I test aggiunti verificano enumerazione, selezione, ambiguità dei nomi e
  mantenimento del figlio selezionato dopo un nuovo login.
- [Issue #2](https://github.com/Rocciadura/didupAPI-wrapper/issues/2) chiusa come
  completata; ultimo aggiornamento `2026-10-11T11:23:06Z`. Questa chiusura spiega
  il nuovo avviso relativo a un'issue già esaminata il 3 ottobre.
- Il diff non modifica OAuth/PKCE, endpoint di login/dashboard, richiesta dei
  compiti o formato delle risposte Argo. L'aggiunta di `GET profilo` nel wrapper
  usa un endpoint già esistente e già utilizzato da DiarioUp.

## Confronto con DiarioUp

`DioDidupAuthService.login()` itera già tutti i contesti di login, carica ogni
profilo con il relativo token e conserva le sessioni per ID del profilo.
`DidupRepositoryImpl` salva e ripristina il profilo scelto; `DidupClient` usa il
token del profilo richiesto per la dashboard. Il rinnovo OAuth usa
`DidupSession.copyWith()`, che mantiene la mappa dei profili e `activeProfileId`.

I test esistenti in `auth_flow_test.dart` verificano due figli con token
distinti, scelta/ripristino del secondo profilo e assenza della password dalla
sessione persistita. `didup_client_test.dart` verifica rinnovo, rifiuto del
rinnovo e retry dopo HTTP 401. Sono verifiche con trasporto simulato, non un
collaudo live con credenziali reali.

## Presa in carico del watchdog

Scansione effettuata alle `2026-10-11T12:13:04Z`: solo i tre avvisi ricevuti;
nessuna variazione segnalata per App Store o gli altri repository monitorati.
Baseline aggiornata al commit esaminato e all'orario della scansione.
Ulteriori commit o aggiornamenti delle issue restano soggetti a segnalazione.
Per rendere effettiva la presa in carico su GitHub, pubblicare la baseline e
avviare eventuali controlli manuali con un nuovo run sul branch aggiornato.
