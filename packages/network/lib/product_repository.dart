import 'package:dio/dio.dart';
import 'package:core/models/product_model.dart';

class ProductRepository {
  final Dio dio;
  static const String _apiUrl = 'https://dummyjson.com/products';

  ProductRepository({required this.dio});

  Future<List<ProductModel>> fetchProducts() async {
    try {
      final response = await dio.get(_apiUrl);

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> productJsonList = response.data['products'] as List<dynamic>;
        return productJsonList
            .map((jsonItem) => ProductModel.fromJson(Map<String, dynamic>.from(jsonItem)))
            .toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}