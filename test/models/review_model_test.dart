import 'package:flutter_test/flutter_test.dart';
import 'package:pka_food/models/review_model.dart';

void main() {
  group('ReviewModel Serialization', () {
    test('toJson and fromJson round-trip matches original values', () {
      final review = ReviewModel(
        id: 1,
        userId: 2,
        productId: 3,
        orderId: 'order-123',
        stars: 5,
        comment: 'Mon an rat ngon!',
        createdAt: DateTime(2026, 5, 21, 15, 0, 0),
      );

      final jsonMap = review.toJson();
      final roundTripReview = ReviewModel.fromJson(jsonMap);

      expect(roundTripReview.id, review.id);
      expect(roundTripReview.userId, review.userId);
      expect(roundTripReview.productId, review.productId);
      expect(roundTripReview.orderId, review.orderId);
      expect(roundTripReview.stars, review.stars);
      expect(roundTripReview.comment, review.comment);
      expect(roundTripReview.createdAt, review.createdAt);
    });
  });
}
