import 'package:flutter_test/flutter_test.dart';
import 'package:core/models/product_model.dart';
import 'package:core/models/dimension_model.dart';
import 'package:core/models/review_model.dart';

void main() {
  group('ProductModel', () {
    final Map<String, dynamic> json = {
      "id": 1,
      "title": "Essence Mascara Lash Princess",
      "description": "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects.",
      "category": "beauty",
      "price": 9.99,
      "discountPercentage": 7.17,
      "rating": 4.94,
      "stock": 5,
      "tags": ["beauty", "mascara"],
      "brand": "Essence",
      "sku": "RCHCH9NE",
      "weight": 2,
      "dimensions": {
        "width": "23.17",
        "height": "14.43",
        "depth": "28.01"
      },
      "warrantyInformation": "1 month warranty",
      "shippingInformation": "Ships in 1 month",
      "availabilityStatus": "In Stock",
      "reviews": [
        {
          "rating": 2,
          "comment": "Very unhappy with my purchase!",
          "date": "2024-05-23T08:56:21.618Z",
          "reviewerName": "John Doe",
          "reviewerEmail": "john.doe@x.dummyjson.com"
        }
      ],
      "returnPolicy": "30 days return policy",
      "minimumOrderQuantity": 24,
      "meta": "some meta data",
      "images": [
        "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png"
      ],
      "thumbnail": "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png"
    };

    test('fromJson should return a valid ProductModel', () {
      final product = ProductModel.fromJson(json);

      expect(product.id, 1);
      expect(product.title, "Essence Mascara Lash Princess");
      expect(product.dimensions, isA<DimensionModel>());
      expect(product.dimensions.width, "23.17");
      expect(product.reviews, isA<List<ReviewModel>>());
      expect(product.reviews.length, 1);
      expect(product.reviews.first.reviewerName, "John Doe");
    });
  });

  group('DimensionModel', () {
    test('fromJson should return a valid DimensionModel', () {
      final json = {"width": "10.0", "height": "20.0", "depth": "30.0"};
      final dimensions = DimensionModel.fromJson(json);
      expect(dimensions.width, "10.0");
      expect(dimensions.height, "20.0");
      expect(dimensions.depth, "30.0");
    });
  });

  group('ReviewModel', () {
    test('fromJson should return a valid ReviewModel', () {
      final json = {
        "rating": 5,
        "comment": "Great product!",
        "date": "2024-01-01",
        "reviewerName": "Alice",
        "reviewerEmail": "alice@test.com"
      };
      final review = ReviewModel.fromJson(json);
      expect(review.rating, 5);
      expect(review.reviewerName, "Alice");
    });
  });
}
