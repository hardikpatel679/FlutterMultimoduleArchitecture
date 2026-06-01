import 'dimension_model.dart';
import 'review_model.dart';

class ProductModel {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final int weight;
  final DimensionModel dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ReviewModel> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final String thumbnail;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.thumbnail,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: (json['id'] ?? 0) as int,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      discountPercentage: double.tryParse(json['discountPercentage']?.toString() ?? '0') ?? 0.0,
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      stock: (json['stock'] ?? 0) as int,
      tags: List<String>.from(json['tags'] ?? []),
      brand: json['brand']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      weight: (json['weight'] ?? 0) as int,
      dimensions: DimensionModel.fromJson(json['dimensions'] ?? {}),
      warrantyInformation: json['warrantyInformation']?.toString() ?? '',
      shippingInformation: json['shippingInformation']?.toString() ?? '',
      availabilityStatus: json['availabilityStatus']?.toString() ?? '',
      reviews: (json['reviews'] as List? ?? [])
          .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      returnPolicy: json['returnPolicy']?.toString() ?? '',
      minimumOrderQuantity: (json['minimumOrderQuantity'] ?? 0) as int,
      thumbnail: json['thumbnail']?.toString() ?? '',
      images: List<String>.from(json['images'] ?? []),
    );
  }
}