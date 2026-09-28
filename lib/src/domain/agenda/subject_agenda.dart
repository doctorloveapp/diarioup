final class SubjectAgenda {
  const SubjectAgenda({
    required this.id,
    required this.profileId,
    required this.name,
    required this.totalHomework,
    required this.pendingHomework,
    this.colorValue,
  });

  final String id;
  final String profileId;
  final String name;
  final int? colorValue;
  final int totalHomework;
  final int pendingHomework;
}
