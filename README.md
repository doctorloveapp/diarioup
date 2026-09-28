# DiarioUp

Questo repository contiene il client Flutter DiarioUp e l'adattatore isolato
in sola lettura verso DidUP. Le Fasi 1.0 e 1.1 includono protocollo, test,
routing, design system, onboarding, login e shell della dashboard. Il database
locale e la sincronizzazione completa arrivano nelle fasi successive.

Il modulo rispetta la direzione delle dipendenze `Presentation -> Domain <- Data`:

- `lib/src/domain`: entita, errori, contratti e casi d'uso privi di dipendenze
  Flutter, Dio o storage;
- `lib/src/data`: protocollo DidUP, rete Dio, cookie temporanei, secure storage,
  parsing e repository;
- `test`: fixture esclusivamente sintetiche e test del percorso critico.

## Stato del progetto

Il gate tecnico 1.0 e chiuso. La cronologia pubblica documenta due incidenti
compatibili in 24 mesi, non una rottura radicale ricorrente. Le verifiche
legali/live restano gate pre-release. Nessun client ID dell'app ufficiale,
password reale o versione client viene incorporato nel progetto.

Eseguire:

```text
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=DIARIOUP_ENV=demo
```

Su Windows, una toolchain Flutter installata in un percorso contenente spazi puo
esporre un difetto del build hook `objective_c` usato transitivamente dal secure
storage. In quel caso eseguire SDK e workspace tramite unita `subst` temporanee
o collocarli in percorsi senza spazi; non disabilitare i native assets richiesti
dal plugin.

La configurazione runtime deve fornire client OAuth/redirect e versione del
protocollo verificati. In assenza di questi valori l'adattatore non effettua
login.
