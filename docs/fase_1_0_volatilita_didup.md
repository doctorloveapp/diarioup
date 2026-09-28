# Volatilita del protocollo DidUP - analisi storica

**Finestra osservata:** 27 settembre 2024 - 27 settembre 2026  
**Esito:** volatilita bassa-moderata, con due incidenti compatibili in 24 mesi.

## Metodo e limiti del campione

Sono stati letti tutti i commit raggiungibili dai branch e tag pubblici e tutte
le issue pubbliche, escluse le pull request automatiche, di:

- [`Rocciadura/didupAPI-wrapper`](https://github.com/Rocciadura/didupAPI-wrapper),
  4 commit nel periodo ma storia pubblica iniziata il 31 maggio 2026;
- [`DTrombett/portaleargo-api`](https://github.com/DTrombett/portaleargo-api),
  37 commit nel periodo e storia pubblica dal 31 marzo 2023;
- [`fcaloro-beep/argo-family-dashboard`](https://github.com/fcaloro-beep/argo-family-dashboard),
  19 commit nel periodo ma storia pubblica compresa fra 5 e 14 giugno 2026.

Il repository longitudinalmente significativo e `portaleargo-api`. Gli altri
due danno conferme recenti e casi reali, ma non coprono da soli 24 mesi. Sono
state contate come rotture soltanto le segnalazioni o correzioni che dimostrano
un login o un recupero dati non piu funzionante per un cambiamento richiesto da
Argo. Refactor, bump di dipendenze, packaging e difetti del consumer non sono
stati trasformati in falsi incidenti di protocollo.

## Incidenti confermati

| Data | Superficie | Evidenza | Natura e impatto |
|---|---|---|---|
| 18 febbraio - 19 marzo 2025 | Login/sessione applicativa | [`portaleargo-api` #261](https://github.com/DTrombett/portaleargo-api/issues/261) e [commit `4025238`](https://github.com/DTrombett/portaleargo-api/commit/40252382bf685dc93095297928fa641ec47116dc) | Argo rifiutava la vecchia `argo-client-version` con il messaggio di aggiornare l'app. La correzione effettiva e stata una riga, da `1.24.0` a `1.27.0`; il manutentore non ha trovato altri cambiamenti del protocollo. Rottura totale temporanea del login per configurazione obsoleta, ma cambiamento piccolo. |
| 21 settembre 2026 - aperto al 27 settembre | Login riuscito, costruzione profilo/entita fallita | [`argo-family-dashboard` #4](https://github.com/fcaloro-beep/argo-family-dashboard/issues/4) | Il reporter ha dovuto aggiornare `APP_VERSION` a `1.30.2`; il login restituiva due righe ma il consumer non trovava `profilo`/`alunno` nella risposta e non creava entita. E un aggiustamento di versione e di assunzione sullo schema, non un nuovo sistema di autenticazione. L'adattatore DiarioUp e meno esposto perche legge il profilo dal relativo endpoint invece di richiederlo nella riga `login`. |

**Conteggio:** 2 incidenti confermati / 24 mesi, cioe circa uno ogni 12 mesi.
Non e un evento trimestrale. Il campione non giustifica neppure la promessa
"quasi mai": entrambi gli incidenti hanno potuto interrompere una funzione, ma
sono rimasti compatibili con OAuth2/PKCE, endpoint applicativi e dashboard gia
noti.

## Cambiamenti osservati ma non classificati come rottura Argo

- Il 12 ottobre 2024 `portaleargo-api` ha portato la versione dichiarata da
  `1.21.0` a `1.24.0` dentro un aggiornamento dipendenze; nessuna issue o diff
  dimostra che fosse la risposta a un guasto.
- I commit del 27-28 novembre 2024 riscrivono gestione cookie, redirect e
  dispatcher HTTP, ma mantengono OAuth2/PKCE, SSO, token, header e base API. Sono
  refactor del client, non evidenza di un cambio lato Argo.
- Il 20 febbraio 2026 la versione passa a `1.29.1` e viene modernizzato `undici`;
  non esiste una segnalazione di protocollo associata.
- `didupwrapper` 0.1.2 corregge rinnovo locale della sessione, gestione di
  risposte non JSON e diagnostica del 410. Il suo stesso diff mostra bug e
  hardening del wrapper, non un nuovo protocollo Argo.
- [`argo-family-dashboard` #1](https://github.com/fcaloro-beep/argo-family-dashboard/issues/1)
  ha aggiunto la scelta multi-studente e corretto l'ordinamento/troncamento dei
  compiti. Il formato sorgente funzionava: erano lacune e bug applicativi.

Non sono emerse introduzioni di Cloudflare/captcha, cambio totale del formato
dei compiti, sostituzione di OAuth2/PKCE o migrazione integrale degli endpoint.
La pressione operativa osservata e concentrata sulla versione client accettata
e su assunzioni troppo rigide intorno a campi opzionali o collocazione del
profilo.

## Valutazione della resilienza

La struttura prevista dalla sezione 7 resta appropriata: adattatore isolato,
versione client in configurazione, parser tollerante, test sintetici, ultimo dato
offline e rilascio controllato sono proporzionati agli incidenti reali.

E invece sovradimensionato trattare una scansione ogni sei ore come requisito
operativo del MVP. La storia indica la seguente politica:

- controllo giornaliero dei soli file P1/P2 e delle issue, con allarme immediato
  quando una versione viene rifiutata o cresce la classe 410/compatibilita;
- controllo mensile dell'albero e delle dipendenze per scoprire file spostati;
- test di contratto a ogni modifica e prima di ogni release;
- triage on-demand alla prima segnalazione riproducibile, senza aggiornamento
  automatico di versione, endpoint o codice.

La scansione ogni sei ore puo essere attivata durante il pilota o un incidente,
ma non e una condizione di fattibilita. Il rischio residuo e una breve
interruzione corretta tramite configurazione/parser e revisione store; la
"rottura totale" resta possibile in astratto, ma non e il comportamento
storico prevalente.

## Decisione del gate

La Fase 1.0 e **chiusa con esito tecnico positivo**. Le precedenti condizioni
bloccanti diventano monitoraggio standard e attivita pre-release. Le evidenze
pubbliche non conferiscono diritti sull'API o sul marchio e una verifica delle
condizioni applicabili resta dovuta prima della distribuzione pubblica, ma non
blocca la costruzione del client locale, della modalita demo e della UX.
