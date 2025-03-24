class Grade {
  final int id;
  final String name;
  final int classTypeId;
  final double markFrom;
  final double markTo;
  final String? remark;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Grade({
    required this.id,
    required this.name,
    required this.classTypeId,
    required this.markFrom,
    required this.markTo,
    this.remark,
    this.createdAt,
    this.updatedAt,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      id: json['id'],
      name: json['name'],
      classTypeId: json['class_type_id'],
      markFrom: double.parse(json['mark_from'].toString()),
      markTo: double.parse(json['mark_to'].toString()),
      remark: json['remark'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'class_type_id': classTypeId,
      'mark_from': markFrom,
      'mark_to': markTo,
      'remark': remark,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool isInRange(double mark) {
    return mark >= markFrom && mark <= markTo;
  }
}
