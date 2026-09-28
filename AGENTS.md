# DiarioUp — Regole di progetto

Questo file è vincolante per ogni futura iterazione del progetto. In caso di conflitto, queste regole prevalgono sulle convenzioni locali non documentate; ogni eccezione deve essere motivata nella code review e aggiornata qui.

## Principi operativi

- Privilegiare codice leggibile, prevedibile, testabile e resiliente rispetto a scorciatoie o astrazioni premature.
- Mantenere le modifiche piccole e coerenti con il perimetro della richiesta.
- Non introdurre codice funzionale, dipendenze o configurazioni di produzione senza verificare l'impatto su sicurezza, performance, accessibilità e manutenibilità.
- Ogni comportamento non ovvio deve essere documentato vicino al codice o nella documentazione tecnica del progetto.

## Standard di codice

### Flutter e Dart

- Usare Flutter e Dart con null safety obbligatoria e analisi statica senza errori o warning introdotti dalla modifica.
- Rispettare `dart format` e le regole di `analysis_options.yaml`; evitare `dynamic`, cast non necessari e soppressioni degli analyzer.
- Preferire widget piccoli, immutabili e composabili. Separare la logica di presentazione dai widget quando supera la responsabilità di rendering e interazione locale.
- Usare `const` dove possibile e gestire esplicitamente loading, empty, error e retry state.
- Rendere le stringhe visibili all'utente localizzabili; non hardcodare copy ripetuto nei widget.
- Ogni nuova funzionalità deve prevedere test adeguati al livello interessato: unit, provider/notifier, widget o integrazione.

### Riverpod

- Riverpod è il meccanismo standard per dependency injection e gestione dello stato.
- Dichiarare provider tipizzati e con responsabilità singola; preferire `Notifier`/`AsyncNotifier` per stato e side effect strutturati.
- Mantenere i provider indipendenti dai widget e iniettabili nei test.
- Non usare stato globale mutabile al di fuori di Riverpod e non leggere direttamente servizi concreti dalla Presentation layer.
- Gestire esplicitamente cancellazione, invalidazione, errori e lifecycle dei provider asincroni.

### Architettura pulita a strati

Il progetto segue una separazione a strati con dipendenze dirette verso l'interno:

```text
Presentation → Domain ← Data
```

- **Domain**: entità, value object, contratti dei repository e use case. Non dipende da Flutter, Riverpod, database o API.
- **Data**: DTO/model, datasource locali/remoti, implementazioni dei repository e mapping verso il Domain. Gli errori tecnici vengono tradotti in errori di dominio significativi.
- **Presentation**: pagine, widget, controller/notifier Riverpod e stato di UI. Coordina use case e non contiene query, parsing o regole di business.
- Le dipendenze attraversano i contratti, non le implementazioni concrete. Evitare import verso livelli esterni che invertano questa direzione.

## Design System DiarioUp

Questi valori sono la fonte di verità visiva del prodotto. Non introdurre colori, font, spaziature o transizioni ad hoc senza aggiornare prima questa sezione.

### Palette

| Token | Valore | Uso |
| --- | --- | --- |
| `indaco` | `#4F46E5` | Azioni primarie, link, focus e identità principale |
| `inchiostro` | `#111827` | Testo principale, titoli e superfici ad alto contrasto |
| `verdePetrolio` | `#0F766E` | Esiti positivi, conferme e stati di successo |
| `ambra` | `#F59E0B` | Attenzione, stato in revisione e callout non distruttivi |
| `sfondo` | `#F8FAFC` | Sfondo principale chiaro |
| `superficie` | `#FFFFFF` | Card, modali e contenitori |
| `testoSecondario` | `#475569` | Informazioni secondarie e descrizioni |
| `bordo` | `#CBD5E1` | Divisori e bordi a basso contrasto |

I colori devono essere esposti tramite Theme/Design Tokens, non copiati come literal nei widget. Garantire contrasto WCAG AA per testo e controlli interattivi; non usare il solo colore per comunicare uno stato.

### Tipografia

- Font primario obbligatorio: **Inter**.
- Usare una gerarchia coerente: `display`/titoli per la navigazione, `title` per sezioni, `body` per contenuto, `label` per controlli e metadati.
- Preferire i pesi Inter 400 (regular), 500 (medium), 600 (semibold) e 700 (bold). Evitare pesi arbitrari.
- Definire gli stili nel tema tipografico centrale; non impostare dimensioni e pesi isolati senza una motivazione di design.

### Spaziatura e layout

Usare esclusivamente la scala di spaziatura: **4 / 8 / 12 / 16 / 24 / 32 px**.

- 4 px: correzioni ottiche e distanze minime.
- 8 px: gap tra elementi strettamente correlati.
- 12 px: padding compatto e controlli secondari.
- 16 px: padding standard e separazione tra gruppi.
- 24 px: sezioni e card.
- 32 px: margini di layout e separazione tra aree principali.

Preferire layout adattivi e vincoli leggibili; evitare valori magici non appartenenti alla scala.

### Animazioni e reduce motion

- Micro-interazioni: **120 ms**.
- Transizioni standard: **200 ms**.
- Transizioni di enfasi o cambio schermata: **300 ms**.
- Usare curve `easeOut` per l'ingresso, `easeIn` per l'uscita ed `easeInOut` per trasformazioni continue. Non usare rimbalzi o animazioni decorative come default.
- Ogni animazione deve comunicare causa-effetto e non bloccare l'interazione.
- Rispettare le preferenze di accessibilità del sistema (`MediaQuery.disableAnimations`/equivalente): con reduce motion attivo, sostituire movimento e parallax con cambi di stato immediati o dissolvenze minime.
- Le animazioni devono essere testabili e non contenere timer non cancellabili o loop perpetui non richiesti.

## Policy di sicurezza

- **Divieto assoluto di loggare dati sensibili**: mai password, token, chiavi, cookie, dati personali, contenuti diari, payload autenticati o identificativi non necessari. Redigere o omettere i valori anche nei log di debug e negli error report.
- **Vietato hardcodare chiavi o segreti** nel codice, negli asset, nella configurazione versionata, nei test o nella documentazione operativa. Usare variabili d'ambiente, secret manager o secret store CI.
- Usare obbligatoriamente `flutter_secure_storage` per segreti e credenziali memorizzati sul dispositivo.
- Usare un database cifrato per dati locali persistenti sensibili; le chiavi di cifratura devono essere gestite tramite `flutter_secure_storage` o un secret manager, mai salvate insieme al database.
- Applicare il principio del minimo privilegio, validare input ai confini del sistema e non includere dati sensibili nelle URL, nei nomi file o nei messaggi di eccezione.
- Il keystore Android, le password di firma e ogni certificato privato sono segreti: mantenerli solo in locale sicuro o nella CI e mai nel repository.
- Prima del merge, verificare diff, dipendenze e artefatti generati alla ricerca di segreti accidentalmente inclusi.

## Identità di firma Android

L'identità prevista per il certificato di firma dell'APK è:

- Nome: **Dan King**
- Indirizzo: **Via Roma 1**
- Località: **Roma**
- Paese: **IT**

Questi dati sono metadati pubblici del certificato, non sostituiscono il keystore privato. La generazione del certificato e l'iniezione dei segreti devono avvenire in ambiente protetto o in CI.

## Asset e loghi

- Le sorgenti del logo vanno in `assets/icons/source/` in formato SVG e/o PNG.
- Le varianti Android raster vanno in `assets/icons/android/mipmap-<density>/` e, quando sarà presente il modulo Android, nelle corrispondenti cartelle `android/app/src/main/res/mipmap-<density>/`.
- Densità supportate: `mdpi`, `hdpi`, `xhdpi`, `xxhdpi`, `xxxhdpi`.
- Non sovrascrivere una variante senza verificare trasparenza, dimensioni, leggibilità a piccole dimensioni e coerenza cromatica con questa guida.

## Tone of voice

Il linguaggio del progetto è professionale, essenziale e orientato alla resilienza del codice: comunicare fatti, impatti e azioni; evitare enfasi superflua, ambiguità e promesse non verificabili. Errori e stati vuoti devono guidare l'utente verso una prossima azione chiara, senza colpevolizzarlo.
