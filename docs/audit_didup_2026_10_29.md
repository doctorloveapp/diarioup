# Analisi compatibilità DidUP — 29 ottobre 2026

## Decisione

Aggiornare DiarioUp a **1.6.0+13**. Questa segnalazione richiede una modifica al
flusso OAuth in `DioDidupAuthService`: il codice precedente non raccoglieva i
cookie emessi dalla risposta del login SSO e inviava i cookie in base alla
posizione nella catena dei redirect, senza rispettarne host e percorso.
Il comportamento è incompatibile con il caso segnalato nel portale aggiornato.

## Evidenze upstream

[Diff completo esaminato](https://github.com/Rocciadura/didupAPI-wrapper/compare/03be218248fd6b5125df7e5f1a52bea6cf97ce90...999b74bb90e219db3356dd00fb5c522fe424e258).

| Avviso | Cambiamento | Impatto |
| --- | --- | --- |
| `didupwrapper/auth.py` | Raccolta cookie a ogni risposta, cookie per host/dominio, redirect dinamici fino a 10 e Location relative | Correzione applicata in DiarioUp |
| Issue #3 | Login browser riuscito, wrapper fermo al redirect 3 dopo aggiornamento del portale | Caso di regressione riprodotto con trasporto simulato |
| `didupwrapper/client.py` | Import e annotazioni Python | Nessun cambiamento richiesto |
| `didupwrapper/endpoints/registro.py` | Ordine import | Nessun cambiamento richiesto |
| `didupwrapper/exceptions.py` | Ordine esportazioni `__all__` | Nessun cambiamento richiesto |
| `didupwrapper/models.py` | Ordine esportazioni `__all__` | Nessun cambiamento richiesto |
| `tests/test_client.py` | Sintassi equivalente dei context manager | Nessun cambiamento richiesto |

Il commit [999b74b](https://github.com/Rocciadura/didupAPI-wrapper/commit/999b74bb90e219db3356dd00fb5c522fe424e258)
è la correzione del wrapper; l'[issue #3](https://github.com/Rocciadura/didupAPI-wrapper/issues/3)
risulta ancora aperta al momento della verifica, con ultimo aggiornamento
`2026-10-29T10:45:50Z`. Gli altri commit aggiungono lint, CI, pubblicazione PyPI,
test e versione del pacchetto. Endpoint di recupero compiti, payload dashboard,
modelli dei compiti e normalizzazione restano invariati: non occorre cambiare
`DidupClient` o il database.

## Implementazione e sicurezza

- CookieJar già presente tra le dipendenze, separato per tentativo OAuth,
  solo in memoria e cancellato nel `finally` sia dopo successo sia dopo errore.
- Cookie raccolti anche dopo il POST SSO e tutti i redirect. Dominio di origine
  validato, cookie host-only isolati e scope Domain/Path gestiti dal jar.
- Nessun invio di credenziali o cookie a host esterni all'allowlist.
- Fino a dieci GET intermedi, risoluzione delle Location relative e callback
  verificata per URI e `state`; nessun GET verso il callback personalizzato.
- Nessun nuovo log HTTP: diagnostica limitata a stadio e status, senza query,
  cookie, codici OAuth o credenziali. Nessuna password persistita.
- Stesso application ID e keystore; build number incrementato da 12 a 13 per
  permettere l'aggiornamento sopra la release precedente senza disinstallazione.

## Verifiche

`flutter analyze`: nessuna segnalazione. `flutter test`: **67 test superati**.

APK release generato con `tool/build_sideload_release.ps1`: firma v2 verificata,
versionName `1.6.0`, versionCode `13`, certificato identico alla release `1.5.0`.
Controlli asset Flutter e icona promemoria superati, APK non debuggable e senza
fixture, test, file di firma o `.env` nell'archivio. Il compilatore Kotlin ha
usato il fallback dopo un errore delle cache incrementali tra unità C: e W:;
la compilazione finale è terminata con codice 0.

Artefatto: `dist/DiarioUp-1.6.0+13-release.apk`.
SHA-256: `FD8CE5581CCA89C3F34A4A575C2CCAD9D8FFAE547F1FB149DC7607885557542B`.

Il test del cookie SSO falliva prima della correzione e passa con la nuova
implementazione. I test verificano host/dominio/percorso, sostituzione cookie,
redirect relativi e più lunghi, limite massimo, host non autorizzati, `state`
errato, tentativi indipendenti, profili multipli e rinnovo sessione.
La suite completa ha inoltre evidenziato un overflow preesistente nel dettaglio
compito con countdown lunghi su viewport da 360 px. Materia e badge di scadenza
ora usano un layout a capo, verificato dal test di navigazione completo.
Si tratta di test simulati: il login live con credenziali reali richiede il
collaudo sul dispositivo e non è attestato da questo documento.

La scansione delle fonti alle `2026-10-29T12:18:25Z` ha rilevato esattamente i
sette avvisi ricevuti. Baseline aggiornata al commit esaminato e all'orario
della scansione, senza modificare gli altri repository o la versione App Store.
Nuovi commit o aggiornamenti dell'issue restano monitorati.
