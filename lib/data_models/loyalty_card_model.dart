class LoyaltyCardModel {
  String cafeName;
  int currentCount;
  int totalCount;
  bool hasCoffeeClaim;

  LoyaltyCardModel({
    required this.cafeName,
    required this.currentCount,
    required this.totalCount,
    required this.hasCoffeeClaim,
  });

  factory LoyaltyCardModel.fromJson(Map<String, dynamic> data) {
    return LoyaltyCardModel(
      cafeName: data['cafename'],
      currentCount: data['currentcount'],
      totalCount: data['totalcount'],
      hasCoffeeClaim: data['hascoffeeclaim'] ?? false,
    );
  }
}
