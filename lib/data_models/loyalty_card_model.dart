class LoyaltyCardModel {
  String cafeName;
  int currentCount;
  int totalCount;

  LoyaltyCardModel({
    required this.cafeName,
    required this.currentCount,
    required this.totalCount,
  });

  factory LoyaltyCardModel.fromJson(Map<String, dynamic> data) {
    return LoyaltyCardModel(
      cafeName: data['cafename'],
      currentCount: data['currentcount'],
      totalCount: data['totalcount'],
    );
  }
}
