import 'base_model.dart';
import 'receipt.dart';

class PaymentRecord extends BaseModel {
  final String title;
  final double amount;
  final String refNo;
  final String method;
  final int? myClassId;
  final String? description;
  final String year;
  final List<Receipt>? receipts;

  PaymentRecord({
    required super.id,
    required this.title,
    required this.amount,
    required this.refNo,
    required this.method,
    required this.year,
    this.myClassId,
    this.description,
    this.receipts,
    super.createdAt,
    super.updatedAt,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    return PaymentRecord(
      id: json['id'],
      title: json['title'],
      amount: double.parse(json['amount'].toString()),
      refNo: json['ref_no'],
      method: json['method'],
      myClassId: json['my_class_id'],
      description: json['description'],
      year: json['year'],
      receipts: json['receipts'] != null
          ? (json['receipts'] as List)
              .map((receipt) => Receipt.fromJson(receipt))
              .toList()
          : null,
      createdAt: BaseModel.parseDateTime(json['created_at']),
      updatedAt: BaseModel.parseDateTime(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'ref_no': refNo,
      'method': method,
      'my_class_id': myClassId,
      'description': description,
      'year': year,
      'receipts': receipts?.map((receipt) => receipt.toJson()).toList(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  double get totalPaid {
    if (receipts == null || receipts!.isEmpty) return 0;
    return receipts!.fold(0, (sum, receipt) => sum + receipt.amountPaid);
  }

  double get balance {
    return amount - totalPaid;
  }
}
