class InitialFundWalletResponse {
  final int? amount;
  final String? paymentMethod;
  final String? transactionRef;

  InitialFundWalletResponse({
    this.amount,
    this.paymentMethod,
    this.transactionRef,
  });

  InitialFundWalletResponse.fromJson(Map<String, dynamic> json)
    : amount = json['amount'] as int?,
      paymentMethod = json['payment_method'] as String?,
      transactionRef = json['transaction_ref'] as String?;

  Map<String, dynamic> toJson() => {
    'amount' : amount,
    'payment_method' : paymentMethod,
    'transaction_ref' : transactionRef
  };
}