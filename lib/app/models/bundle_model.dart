class BundleModel {
  int? id;
  String? title;
  String? type;
  String? description;
  String? price;
  String? status;
  String? createdAt;

  BundleModel({
    this.id,
    this.title,
    this.type,
    this.description,
    this.price,
    this.status,
    this.createdAt,
  });

  BundleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    description = json['description'];
    price = json['price']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['description'] = description;
    data['price'] = price;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
