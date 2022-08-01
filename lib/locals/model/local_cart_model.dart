
// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

//Table Name
var tableName = 'carts';

//Field Name in database
class CartFields{

  static final List<String> values = [
    id, product_id, product_name, unit_tag, image, purchase_price, sale_price, quantity, view_quantity, vat_amount,
    discount_amount, maximum_quantity, current_stock, weight, measurement_sku, measurement_title, measurement_value
  ];

  static String id              = 'id';
  static String product_id      = 'product_id';
  static String product_name    = 'product_name';
  static String unit_tag        = 'unit_tag';
  static String image           = 'image';
  static String purchase_price  = 'purchase_price';
  static String sale_price      = 'sale_price';
  static String quantity        = 'quantity';
  static String view_quantity   = 'view_quantity';
  static String vat_amount      = 'vat_amount';
  static String discount_amount = 'discount_amount';
  static String maximum_quantity= 'maximum_quantity';
  static String current_stock   = 'current_stock';
  static String weight          = 'weight';
  static String measurement_sku = 'measurement_sku';
  static String measurement_title = 'measurement_title';
  static String measurement_value = 'measurement_value';
}

//Model for send/get data from database
class AddtoCart{
  var id;
  var product_id;
  var product_name;
  var unit_tag;
  var image;
  var purchase_price;
  var sale_price;
  var quantity;
  var view_quantity;
  var vat_amount;
  var discount_amount;
  var maximum_quantity;
  var current_stock;
  var weight;
  var measurement_sku;
  var measurement_title;
  var measurement_value;

  AddtoCart({
    this.id,
    this.product_id,
    this.product_name,
    this.unit_tag,
    this.image,
    this.purchase_price,
    this.sale_price,
    this.quantity,
    this.view_quantity,
    this.vat_amount,
    this.discount_amount,
    this.maximum_quantity,
    this.current_stock,
    this.weight,
    this.measurement_sku,
    this.measurement_title,
    this.measurement_value,
  });

  AddtoCart copy({
    int? id,
    int? product_id,
    String? product_name,
    String? unit_tag,
    String? image,
    double? purchase_price,
    double? sale_price,
    int? quantity,
    String? view_quantity,
    double? vat_amount,
    double? discount_amount,
    double? maximum_quantity,
    double? current_stock,
    double? weight,
    String? measurement_sku,
    String? measurement_title,
    String? measurement_value,

  }) => AddtoCart(
    id                : id ?? this.id,
    product_id        : product_id ?? this.product_id,
    product_name      : product_name ?? this.product_name,
    unit_tag          : unit_tag ?? this.unit_tag,
    image             : image ?? this.image,
    purchase_price    : purchase_price ?? this.purchase_price,
    sale_price        : sale_price ?? this.sale_price,
    quantity          : quantity ?? this.quantity,
    view_quantity     : view_quantity ?? this.view_quantity,
    vat_amount        : vat_amount ?? this.vat_amount,
    discount_amount   : discount_amount ?? this.discount_amount,
    maximum_quantity  : maximum_quantity ?? this.maximum_quantity,
    current_stock     : current_stock ?? this.current_stock,
    weight            : weight ?? this.weight,
    measurement_sku   : measurement_sku ?? this.measurement_sku,
    measurement_title : measurement_title ?? this.measurement_title,
    measurement_value : measurement_value ?? this.measurement_value,
  );
  static AddtoCart fromJson(Map<String, Object?> json) => AddtoCart(
    id                : json[CartFields.id] as int?,
    product_id        : json[CartFields.product_id] as int?,
    product_name      : json[CartFields.product_name] as String?,
    unit_tag          : json[CartFields.unit_tag] as String?,
    image             : json[CartFields.image] as String,
    purchase_price    : json[CartFields.purchase_price] as double,
    sale_price        : json[CartFields.sale_price] as double,
    quantity          : json[CartFields.quantity] as int,
    view_quantity     : json[CartFields.view_quantity] as String,
    vat_amount        : json[CartFields.vat_amount] as double,
    discount_amount   : json[CartFields.discount_amount] as double,
    maximum_quantity  : json[CartFields.maximum_quantity] as double,
    current_stock     : json[CartFields.current_stock] as double,
    weight            : json[CartFields.weight] as double,
    measurement_sku   : json[CartFields.measurement_sku] as String,
    measurement_title : json[CartFields.measurement_title] as String,
    measurement_value : json[CartFields.measurement_value] as String,
  );

  Map<String, Object?> toJson() => {
    CartFields.id                 : id,
    CartFields.product_id         : product_id,
    CartFields.product_name       : product_name,
    CartFields.unit_tag           : unit_tag,
    CartFields.image              : image,
    CartFields.purchase_price     : purchase_price,
    CartFields.sale_price         : sale_price,
    CartFields.quantity           : quantity,
    CartFields.view_quantity      : view_quantity,
    CartFields.vat_amount         : vat_amount,
    CartFields.discount_amount    : discount_amount,
    CartFields.maximum_quantity   : maximum_quantity,
    CartFields.current_stock      : current_stock,
    CartFields.weight             : weight,
    CartFields.measurement_sku    : measurement_sku,
    CartFields.measurement_title  : measurement_title,
    CartFields.measurement_value  : measurement_value,
  };
}