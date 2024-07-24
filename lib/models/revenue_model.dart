class RevenueModel {
  final String? title;
  final List<Details>? details;
  final String? totalRevenue;

  RevenueModel({
    this.title,
    this.details,
    this.totalRevenue,
  });

  RevenueModel.fromJson(Map<String, dynamic> json)
    : title = json['title'] as String?,
      details = (json['details'] as List?)?.map((dynamic e) => Details.fromJson(e as Map<String,dynamic>)).toList(),
      totalRevenue = json['total_revenue'] as String?;

  Map<String, dynamic> toJson() => {
    'title' : title,
    'details' : details?.map((e) => e.toJson()).toList(),
    'total_revenue' : totalRevenue
  };
}

class Details {
  final String? title;
  final String? amount;

  Details({
    this.title,
    this.amount,
  });

  Details.fromJson(Map<String, dynamic> json)
    : title = json['title'] as String?,
      amount = json['amount'] as String?;

  Map<String, dynamic> toJson() => {
    'title' : title,
    'amount' : amount
  };
}