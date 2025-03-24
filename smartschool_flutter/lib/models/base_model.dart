abstract class BaseModel {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseModel({
    required this.id,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson();

  static DateTime? parseDateTime(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date);
  }
}
