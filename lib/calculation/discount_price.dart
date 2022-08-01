
//Price Show
discountPrice({salePrice, productMeasurement, productMeasurementValue, discounts, discountPercent, discountEndDate}){
  var price       = double.parse('${salePrice ?? 0.0}') * double.parse('${productMeasurement.length > 0 ? productMeasurementValue : 1.0}');
  var discount    = price * (double.parse('${discounts != null ? discountPercent : 0.0}') / 100);
  var endDate     = discounts != null ? DateTime(int.parse(discountEndDate.toString().split('-')[0]), int.parse(discountEndDate.toString().split('-')[1]), int.parse(discountEndDate.toString().split('-')[2])) : null;
  var currentDate = DateTime.now();
  var difference  = currentDate.difference(endDate ?? DateTime.now()).inDays;

  var finalPrice = difference < 0 ? (price - discount) : price;
  return finalPrice;
}