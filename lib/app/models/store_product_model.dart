class StoreProductModel {
  int? id;
  String? title;
  String? type;
  String? description;
  String? price;
  String? discount;
  int? status;
  String? createdAt;

  StoreProductModel({
    this.id,
    this.title,
    this.type,
    this.description,
    this.price,
    this.discount,
    this.status,
    this.createdAt,
  });

  StoreProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    type = json['type'];
    description = json['description'];
    price = json['price']?.toString();
    discount = json['discount']?.toString();
    status = json['status'];
    createdAt = json['created_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['type'] = type;
    data['description'] = description;
    data['price'] = price;
    data['discount'] = discount;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}
