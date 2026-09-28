# Fase 1.0 - Fattibilita e condizioni d'accesso

**Stato del gate:** chiuso con esito tecnico positivo il 27 settembre 2026.

Il prototipo copre con fixture sintetiche login, profili multipli, sessione,
rinnovo, lettura dashboard e normalizzazione dei compiti. L'analisi dei 24 mesi
precedenti ha rilevato due incidenti compatibili, circa annuali, senza cambio
radicale di OAuth2/PKCE o del formato dei compiti. Il dettaglio verificabile e
in `docs/fase_1_0_volatilita_didup.md`. Il codice non costituisce autorizzazione
all'uso delle API; condizioni applicabili e prove live restano attivita
pre-release, non blocchi alla costruzione della Fase 1.

## Evidenze tecniche

Riferimenti osservati dal piano:

- [`Rocciadura/didupAPI-wrapper`](https://github.com/Rocciadura/didupAPI-wrapper)
  al commit `e98a9a67f4d1770ecda271e7a981efadd4d26e20` e pacchetto PyPI 0.1.1;
- [`DTrombett/portaleargo-api`](https://github.com/DTrombett/portaleargo-api)
  al commit `df846555471f95836450c8af84e4efde11e3cb08`;
- sezioni 3, 4, 5, 7 e 10 di `piano_diarioup_fasi.md`.

Il flusso osservato e modellato e:

1. authorization request OAuth2 con PKCE S256, `state` e `nonce` casuali;
2. login SSO con password trattata solo in memoria;
3. callback validata per schema/host/path e corrispondenza dello `state`;
4. scambio del code per access token ed eventuale refresh token;
5. login applicativo `appfamiglia` per ottenere i contesti con `x-auth-token`,
   `x-cod-min`, username di rinnovo e opzioni;
6. richiesta `profilo` per ogni contesto, da cui provengono identificativo
   scheda, alias studente e anno scolastico;
7. richiesta della sola dashboard necessaria e lettura della sezione registro;
8. rinnovo applicativo single-flight, sostituzione atomica della sessione e una
   sola ripetizione della richiesta che ha ricevuto 401.

Il client ID e il redirect dell'app ufficiale non sono copiati nel progetto.
`DidupProtocolConfig` richiede valori verificati e autorizzati per DiarioUp,
insieme alla versione client. Gli endpoint HTTPS osservati sono configurabili,
ma ogni richiesta e limitata all'allowlist derivata dalla configurazione.

Il tipo pubblico di `portaleargo-api` descrive un solo contesto, mentre
`argo-family-dashboard` #1 documenta e verifica un account con piu studenti.
L'adattatore non seleziona il primo elemento in silenzio e risolve ogni contesto
tramite `profilo`, riducendo anche l'esposizione all'incidente di settembre 2026
causato da assunzioni sui campi `profilo`/`alunno` nella risposta `login`.

## Dati di sessione

Il secure storage contiene un unico documento versionato con:

- access token, refresh token, tipo, scope e scadenza;
- codice scuola e username soltanto per il rinnovo osservato;
- per ogni profilo: identificativo sorgente, `x-auth-token`, `x-cod-min`,
  opzioni e metadati minimi dell'anno scolastico.

La password non appartiene al modello di sessione, non e serializzabile e non
viene conservata per un nuovo login. Cookie OAuth/SSO e cookie applicativi usano
un `CookieJar` esclusivamente in memoria, cancellato al termine del login.
Nessun interceptor HTTP di logging e installato.

Su iOS il secure storage usa `unlocked_this_device`: i segreti sono leggibili
solo a dispositivo sbloccato e non migrano su un altro dispositivo. Su Android
si usano i cifrari predefiniti correnti di `flutter_secure_storage`; quando
verra creato il modulo applicativo completo, il manifest dovra disabilitare il
backup o escludere esplicitamente le preferenze del plugin.

## Semantica dati adottata

- Il record registro conserva `pk`, operazione, revisione e giorno.
- Solo `operazione=D` produce una cancellazione. Un delta senza compiti non
  cancella dati locali.
- `rimuoviDatiLocali`, `ricaricaDati` e `profiloDisabilitato` diventano
  direttive distinte; il prototipo non cancella checklist.
- Le date scolastiche sono `SchoolDate` senza ora o conversione UTC implicita.
- Il testo viene reso inerte: paragrafi e ritorni a capo sono conservati, tag
  HTML rimossi e nessun contenuto remoto e caricato.
- L'hash di testo e scadenza rappresenta la revisione, non l'identita.
- Un ID sorgente del compito ha priorita. In sua assenza il prototipo usa una
  mappa record-padre/posizione e segnala per revisione una variazione ambigua.
  La mappa corrente e volatile: la Fase 1.2 deve implementare il contratto
  `HomeworkIdentityRegistry` nel database cifrato.

## Asset e firma Android esaminati

`assets/logo_diarioup.png` e un PNG ARGB 582 x 582 con trasparenza reale
(angolo alpha 0). E leggibile come sorgente, ma non e ancora stato validato alle
cinque densita Android e non va copiato automaticamente nei mipmap: testo e
dettagli sottili richiedono un controllo a dimensione launcher. Le directory
`assets/icons/source`, `assets/icons/android/mipmap-*` e
`android/app/src/main/res/mipmap-*` sono predisposte ma vuote.

La firma prevista e documentata come
`CN=Dan King, STREET=Via Roma 1, L=Roma, C=IT`. Sono metadati pubblici del
certificato. Non e stato generato alcun keystore e non e stata aggiunta una
password. Il modulo Gradle applicativo non esiste ancora; la configurazione di
firma andra aggiunta nella fase di base progetto usando variabili CI o un
`key.properties` locale ignorato da Git.

## Verifiche automatiche

La suite copre:

- PKCE, callback/state e login applicativo multiprofilo;
- assenza della password dalla sessione serializzata e da `toString()`;
- timeout, cookie temporanei, allowlist host e assenza di logger Dio;
- rinnovo di sessione scaduta, rotazione token e invalidazione se respinto;
- parsing di compiti, materia, date, HTML, modifica e cancellazione esplicita;
- delta vuoto senza cancellazioni implicite.

## Monitoraggio standard e verifiche pre-release

1. Controllare giornalmente file P1/P2 e issue upstream; passare temporaneamente
   a sei ore durante un incidente o il pilota.
2. Mantenere `argo-client-version`, client OAuth e redirect esterni al codice e
   approvarne ogni variazione tramite diff e test di contratto.
3. Su account volontari, senza consegna password al team, misurare durata token,
   rinnovo, profili multipli e versione accettata prima della beta.
4. Confrontare compiti e date con DidUP e osservare modifica, cancellazione e
   reset quando avvengono naturalmente; non creare dati scolastici artificiali.
5. Completare titolarita, privacy, termini, marchi e autorizzazioni prima della
   distribuzione pubblica. Sono gate di rilascio e non di coding locale/demo.
6. Conservare agenda e modalita manuale se una futura incompatibilita sospende
   temporaneamente la sincronizzazione.

L'esito e **fattibilita tecnica dimostrata con rischio di manutenzione
ordinario**. La Fase 1.1 puo procedere; nessun client ID ufficiale o password
reale viene incorporato nel progetto.
