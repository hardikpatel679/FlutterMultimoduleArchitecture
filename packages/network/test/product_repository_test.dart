import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:network/product_repository.dart';
import 'package:core/models/product_model.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ProductRepository repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = ProductRepository(dio: mockDio);
  });

  group('ProductRepository', () {
    final tProductResponse = {
      'products': [
        {
          "id": 1,
          "title": "Test Product",
          "description": "Desc",
          "category": "test",
          "price": 10.0,
          "discountPercentage": 1.0,
          "rating": 4.5,
          "stock": 10,
          "tags": ["tag"],
          "brand": "brand",
          "sku": "sku",
          "weight": 1,
          "dimensions": {"width": "1", "height": "1", "depth": "1"},
          "warrantyInformation": "info",
          "shippingInformation": "info",
          "availabilityStatus": "In Stock",
          "reviews": [],
          "returnPolicy": "policy",
          "minimumOrderQuantity": 1,
          "meta": "meta",
          "images": [],
          "thumbnail": "thumb"
        }
      ]
    };

    test('fetchProducts should return list of ProductModel on success', () async {
      // Arrange
      when(() => mockDio.get(any())).thenAnswer((_) async => Response(
            data: tProductResponse,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act
      final result = await repository.fetchProducts();

      // Assert
      expect(result, isA<List<ProductModel>>());
      expect(result.length, 1);
      expect(result.first.title, "Test Product");
    });

    test('fetchProducts should throw exception on non-200 status code', () async {
      // Arrange
      when(() => mockDio.get(any())).thenAnswer((_) async => Response(
            data: null,
            statusCode: 404,
            requestOptions: RequestOptions(path: ''),
          ));

      // Act & Assert
      expect(() => repository.fetchProducts(), throwsException);
    });

    test('fetchProducts should throw exception on network error', () async {
      // Arrange
      when(() => mockDio.get(any())).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
      ));

      // Act & Assert
      expect(() => repository.fetchProducts(), throwsException);
    });
  });
}
