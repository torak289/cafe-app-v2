class CoffeeModel {
  String name;
  String? description;

  CoffeeModel({required this.name, this.description});
  
  factory CoffeeModel.fromJson(Map<String, dynamic> data) {
    return CoffeeModel(
      name: data['name'],
      description: data['description'],
    );
  }
}
