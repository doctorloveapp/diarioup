abstract final class AppCopy {
  static const String appName = 'DiarioUp';
  static const String independentService = 'App indipendente da Argo';
  static const String onboardingEyebrow = 'LA TUA AGENDA SCOLASTICA';
  static const String onboardingTitle = 'I compiti, finalmente in ordine.';
  static const String onboardingBody =
      'DiarioUp raccoglie le consegne in una vista essenziale, leggibile e '
      'disponibile anche quando la rete non collabora.';
  static const String onboardingPrivacy =
      'Le credenziali restano sul dispositivo e la password non viene salvata.';
  static const String onboardingOffline =
      'L’ultimo diario sincronizzato rimane consultabile offline.';
  static const String start = 'Inizia';
  static const String loginTitle = 'Collega DidUP';
  static const String loginBody =
      'Usa le credenziali Famiglia. DiarioUp le usa solo per questo accesso.';
  static const String schoolCode = 'Codice scuola';
  static const String username = 'Nome utente';
  static const String password = 'Password';
  static const String login = 'Accedi';
  static const String requiredField = 'Campo obbligatorio';
  static const String demoTitle = 'Modalità demo';
  static const String demoBody =
      'Nessun dato viene inviato: inserisci valori di prova per vedere il flusso.';
  static const String profileSelection = 'Scegli il profilo';
  static const String profileSelectionBody =
      'Questo accesso contiene più studenti. Seleziona quello da usare.';
  static const String agenda = 'Agenda';
  static const String subjects = 'Materie';
  static const String settings = 'Impostazioni';
  static const String signOut = 'Disconnetti profilo';
  static const String dashboardGreeting = 'Bentornato';
  static const String today = 'Oggi';
  static const String tomorrow = 'Domani';
  static const String nextDays = 'Prossimi giorni';
  static const String overdue = 'Scaduti';
  static const String demoEmptyTitle = 'La base è pronta';
  static const String demoEmptyBody =
      'La sincronizzazione popolerà qui i compiti. In demo usiamo soltanto dati sintetici.';
  static const String syncStatus = 'Agenda locale aggiornata';
  static const String syncInProgress = 'Sincronizzazione in corso';
  static const String syncError = 'Sincronizzazione non riuscita';
  static const String retry = 'Riprova';
  static const String agendaLoadError =
      'Non è stato possibile leggere l’agenda locale.';
  static const String changedAfterCompletion =
      'Modificato dopo il completamento';
  static const String identityReview = 'Verifica richiesta';
  static const String completionUpdateError =
      'Impossibile aggiornare il completamento. Riprova.';
  static const String allToDo = 'Da fare';
  static const String completed = 'Completati';
  static const String searchHomework = 'Cerca nei compiti';
  static const String searchHomeworkHint = 'Testo, materia o nota';
  static const String noFilteredHomework =
      'Nessun compito corrisponde al filtro selezionato.';
  static const String noDueDate = 'Senza scadenza';
  static const String unavailableDate = 'Non disponibile';
  static const String dueToday = 'Oggi';
  static const String dueTomorrow = 'Domani';
  static const String overdueYesterday = 'Scaduto ieri';
  static const String homeworkCompleted = 'Compito completato';
  static const String undo = 'Annulla';
  static const String newHomework = 'Nuovo compito';
  static const String newSubject = 'Nuova materia';
  static const String homeworkText = 'Testo del compito';
  static const String subject = 'Materia';
  static const String noSubject = 'Nessuna materia';
  static const String dueDate = 'Scadenza';
  static const String removeDueDate = 'Rimuovi scadenza';
  static const String personalNoteOptional = 'Nota personale (facoltativa)';
  static const String personalNote = 'Nota personale';
  static const String personalNoteHint =
      'Aggiungi un chiarimento, il materiale necessario o un promemoria.';
  static const String saveNote = 'Salva nota';
  static const String noteSaved = 'Nota salvata';
  static const String noteSaveError = 'Impossibile salvare la nota. Riprova.';
  static const String subjectName = 'Nome materia';
  static const String subjectColor = 'Colore materia';
  static const String save = 'Salva';
  static const String cancel = 'Annulla';
  static const String entrySaved = 'Elemento aggiunto al diario';
  static const String entrySaveError =
      'Impossibile aggiungere l’elemento. Riprova.';
  static const String subjectsBody =
      'Apri una materia per vedere tutti i compiti associati.';
  static const String noSubjects =
      'Nessuna materia. Puoi aggiungerne una con il pulsante in basso.';
  static const String noHomeworkForSubject = 'Nessun compito associato.';
  static const String homeworkDetail = 'Dettaglio compito';
  static const String homeworkNotAvailable =
      'Questo compito non è più disponibile.';
  static const String sourceDate = 'Data sorgente';
  static const String origin = 'Origine';
  static const String originArgo = 'DidUP';
  static const String originManual = 'Inserimento manuale';
  static const String lastUpdate = 'Ultimo aggiornamento';

  static String countdownInDays(int days) => 'Tra $days giorni';

  static String countdownPastDays(int days) => 'Scaduto da $days giorni';

  static String subjectHomeworkCount({
    required int pending,
    required int total,
  }) => '$pending da fare · $total totali';
  static const String genericLoginError =
      'Accesso non riuscito. Controlla i dati e riprova.';
}
