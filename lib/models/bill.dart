import 'dart:convert';

class SplitDetail {
  String user;
  double amount;

  SplitDetail({
    required this.user,
    required this.amount,
  });

  // Convert a SplitDetail object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'amount': amount,
    };
  }

  // Convert a Map object into a SplitDetail object
  factory SplitDetail.fromMap(Map<String, dynamic> map) {
    return SplitDetail(
      user: map['user'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }

  // Convert a SplitDetail object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a SplitDetail object
  factory SplitDetail.fromJson(String source) => SplitDetail.fromMap(json.decode(source));
}

class Bill {
  double totalAmount;
  List<SplitDetail> splitDetails;
  String? description;
  String? proofOfBillPayment;
  double paidPercentage;
  DateTime createdAt;

  Bill({
    required this.totalAmount,
    required this.splitDetails,
    this.description,
    this.proofOfBillPayment,
    this.paidPercentage = 0.0,
    required this.createdAt,
  });

  // Convert a Bill object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'totalAmount': totalAmount,
      'splitDetails': splitDetails.map((x) => x.toMap()).toList(),
      'description': description,
      'proofOfBillPayment': proofOfBillPayment,
      'paidPercentage': paidPercentage,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Convert a Map object into a Bill object
  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      totalAmount: map['totalAmount']?.toDouble() ?? 0.0,
      splitDetails: List<SplitDetail>.from(
        map['splitDetails']?.map((x) => SplitDetail.fromMap(x)) ?? [],
      ),
      description: map['description'],
      proofOfBillPayment: map['proofOfBillPayment'],
      paidPercentage: map['paidPercentage']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  // Convert a Bill object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a Bill object
  factory Bill.fromJson(String source) => Bill.fromMap(json.decode(source));
}