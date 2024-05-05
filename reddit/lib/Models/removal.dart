class RemovalItem {
  RemovalItem({
    this.id,
    required this.title,
    required this.message,
  });

  String? id;
  String title;
  String message;

  void updateAll({
    String? id,
    required String title,
    required String message,
  }) {
    this.id = id;
    this.title = title;
    this.message = message;
  }
}
