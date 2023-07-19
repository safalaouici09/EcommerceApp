import 'product_model.dart';

class Promotion {
  Product product;
  double score;

  Promotion({required this.product})
      : score = _calculatePromotionScore(product);

  // Calculate the promotion score based on the relevant attributes of the product
  static double _calculatePromotionScore(Product product) {
    double popularityWeight = 0.4;
    double searchWeight = 0.3;
    double ratingWeight = 0.2;
    double discountWeight = 0.1;

    double score = (popularityWeight * product.numberOfSales!) +
        (searchWeight * product.numberOfSearches!) +
        (ratingWeight * (product.averageRating ?? 0.0)) +
        (discountWeight *
            _calculateDiscountScore(product.discount, product.discountEndDate));

    return score;
  }

  static double _calculateDiscountScore(
      double discountPercentage, DateTime? discountEndDate) {
    if (discountEndDate == null || discountEndDate.isBefore(DateTime.now())) {
      return 0.0;
    }

    int remainingDays = discountEndDate.difference(DateTime.now()).inDays;
    return discountPercentage * (1 - (remainingDays / 30));
  }
}
