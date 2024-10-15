class CoffeeModel {
  String name;

  CoffeeModel({required this.name});

  factory CoffeeModel.fromJson(Map<String, dynamic> data) {
    return CoffeeModel(name: 'name');
  }
}
