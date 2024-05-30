class Ball {
  final int id;
  final int number;
  final String tag;
  final bool isCreated;
  final String status; // status: latest | recent | default

  Ball(
      {required this.id,
      required this.number,
      required this.tag,
      required this.isCreated,
      required this.status});
}
