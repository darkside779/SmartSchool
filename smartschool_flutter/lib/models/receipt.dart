import 'base_model.dart';

class Receipt extends BaseModel {
  final double amountPaid;
  final double balance;
  final String year;

  Receipt({
    required super.id,
    required this.amountPaid,
    required this.balance,
    required this.year,
    super.createdAt,
    super.updatedAt,
  });

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      amountPaid: double.parse(json['amount_paid'].toString()),
      balance: double.parse(json['balance'].toString()),
      year: json['year'],
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount_paid': amountPaid,
      'balance': balance,
      'year': year,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  double get totalAmount => balance + amountPaid;

  bool get isFullyPaid => balance == 0;

  String get formattedAmountPaid =>
      amountPaid.toStringAsFixed(2);

  String get formattedBalance =>
      balance.toStringAsFixed(2);

  String get formattedTotalAmount =>
      totalAmount.toStringAsFixed(2);
}
