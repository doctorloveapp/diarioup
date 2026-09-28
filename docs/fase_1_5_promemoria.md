# Fase 1.5 — Promemoria locali

## Stato

Implementazione tecnica completata. La chiusura formale della fase richiede il
collaudo su hardware dei casi consegna, permesso negato, riavvio e cambio fuso
descritti in `manuale_test_dispositivo.md`.

## Comportamento implementato

- Promemoria locale riepilogativo alle 18:00 del giorno precedente, con orario
  modificabile e fascia di quiete 21:00-07:00.
- Opt-in esplicito dalle impostazioni. Il permesso non viene richiesto durante
  onboarding o login e un rifiuto non limita agenda, checklist o sync.
- Piano di 14 giorni, massimo 32 notifiche e raggruppamento per data di
  scadenza. Compiti completati, scaduti o senza scadenza sono esclusi.
- Ricalcolo dopo avvio, sincronizzazione, modifica di nota o stato, inserimento
  manuale, cambio preferenze e ritorno in foreground.
- Allarmi Android non esatti, canale `Promemoria compiti` e ripristino dopo
  reboot. Non sono richiesti permessi di exact alarm e non esistono timer
  permanenti.
- Pianificazione basata sul fuso IANA del dispositivo, con fallback
  `Europe/Rome`.
- Testo privo di dati scolastici: `Hai attività da controllare in DiarioUp`.
  Nessun nome, materia o contenuto del compito è inserito nella notifica o nel
  payload.

Le preferenze sono conservate nel database locale cifrato. Il database resta la
fonte di verità; il sistema operativo riceve soltanto richieste locali derivate
dai dati già consolidati. Non sono presenti push remote, FCM, backend o
credenziali Argo in background.

## Verifiche automatiche

I test coprono raggruppamento, orario predefinito, orizzonte, esclusione dei
compiti non idonei, permesso negato, cambio orario e cancellazione dopo il
completamento. Il widget test del flusso principale copre anche opt-in,
impostazioni e salvataggio della nota mentre lo snackbar è visibile.

## Limiti residui

La consegna dipende dalle politiche del sistema: Doze, risparmio energetico,
Focus e personalizzazioni del produttore possono ritardare un allarme non
esatto. I promemoria riguardano soltanto compiti già presenti localmente; non
scoprono nuovi dati DidUP mentre l'app resta chiusa. Le push remote restano
fuori dal perimetro della Fase 1.5.
