# Personalizzazione locale

La foto profilo e lo sfondo del diario sono funzioni esclusivamente locali. La
galleria fornisce i byte dell'immagine, non un percorso da conservare. Il
repository applica orientamento, ridimensiona il lato maggiore a 512 px per il
profilo o 1920 px per lo sfondo, rimuove i metadati tramite ricodifica JPEG e
salva il risultato nella `ApplicationDocumentsDirectory`.

Il database cifrato conserva soltanto un percorso relativo sotto
`personalization/`. Le preferenze sono separate per profilo dentro il campo
`LocalUsers.preferencesJson` già disponibile; per questo non è necessario
incrementare `schemaVersion = 2`. Percorsi assoluti e attraversamenti `../`
sono rifiutati dal repository.

La sostituzione scrive prima il nuovo file, aggiorna poi Drift e rimuove il
precedente soltanto dopo il commit. Se la scrittura nel database fallisce, il
nuovo file viene eliminato. La rimozione azzera prima il riferimento persistito
e cancella quindi il file locale.

La Dashboard osserva Drift tramite Riverpod. Avatar e sfondo cambiano senza
riavvio; un'immagine assente o illeggibile produce un placeholder. Lo sfondo è
coperto da un overlay derivato dal tema per mantenere leggibili testi e
controlli.
