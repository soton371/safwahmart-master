
// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

//Table Name
var tableNameHome = 'homes';

//Field Name in database
class HomeFields{

  static final List<String> values = [
    id, product_id, product_name, unit_tag, image, purchase_price, sale_price, description, view_quantity, vat_amount, measurement,
    discount_amount, maximum_quantity, current_stock, weight, sku, category_id, measurement_sku, measurement_title, measurement_value
  ];

  static String id                  = 'id';
  static String product_id          = 'product_id';
  static String product_name        = 'product_name';
  static String unit_tag            = 'unit_tag';
  static String image               = 'image';
  static String purchase_price      = 'purchase_price';
  static String sale_price          = 'sale_price';
  static String description         = 'description';
  static String view_quantity       = 'view_quantity';
  static String vat_amount          = 'vat_amount';
  static String discount_amount     = 'discount_amount';
  static String maximum_quantity    = 'maximum_quantity';
  static String current_stock       = 'current_stock';
  static String weight              = 'weight';
  static String sku                 = 'sku';
  static String category_id         = 'category_id';
  static String measurement_sku     = 'measurement_sku';
  static String measurement_title   = 'measurement_title';
  static String measurement_value   = 'measurement_value';
  static String measurement         = 'measurement';
}

//Model for send/get data from database
class Home{
  var id;
  var product_id;
  var product_name;
  var unit_tag;
  var image;
  var purchase_price;
  var sale_price;
  var description;
  var view_quantity;
  var vat_amount;
  var discount_amount;
  var maximum_quantity;
  var current_stock;
  var weight;
  var sku;
  var category_id;
  var measurement_sku;
  var measurement_title;
  var measurement_value;
  var measurement;

  Home({
    this.id,
    this.product_id,
    this.product_name,
    this.unit_tag,
    this.image,
    this.purchase_price,
    this.sale_price,
    this.description,
    this.view_quantity,
    this.vat_amount,
    this.discount_amount,
    this.maximum_quantity,
    this.current_stock,
    this.weight,
    this.sku,
    this.category_id,
    this.measurement_sku,
    this.measurement_title,
    this.measurement_value,
    this.measurement,
  });

  Home copy({
    int? id,
    int? product_id,
    String? product_name,
    String? unit_tag,
    String? image,
    double? purchase_price,
    double? sale_price,
    String? description,
    String? view_quantity,
    double? vat_amount,
    double? discount_amount,
    double? maximum_quantity,
    double? current_stock,
    double? weight,
    String? sku,
    String? category_id,
    String? measurement_sku,
    String? measurement_title,
    String? measurement_value,
    List? measurement,

  }) => Home(
    id                  : id ?? this.id,
    product_id          : product_id ?? this.product_id,
    product_name        : product_name ?? this.product_name,
    unit_tag            : unit_tag ?? this.unit_tag,
    image               : image ?? this.image,
    purchase_price      : purchase_price ?? this.purchase_price,
    sale_price          : sale_price ?? this.sale_price,
    description         : description ?? this.description,
    view_quantity       : view_quantity ?? this.view_quantity,
    vat_amount          : vat_amount ?? this.vat_amount,
    discount_amount     : discount_amount ?? this.discount_amount,
    maximum_quantity    : maximum_quantity ?? this.maximum_quantity,
    current_stock       : current_stock ?? this.current_stock,
    weight              : weight ?? this.weight,
    sku                 : sku ?? this.sku,
    category_id         : category_id ?? this.category_id,
    measurement_sku     : measurement_sku ?? this.measurement_sku,
    measurement_title   : measurement_title ?? this.measurement_title,
    measurement_value   : measurement_title ?? this.measurement_value,
    measurement         : measurement ?? this.measurement,
  );
  static Home fromJson(Map<String, Object?> json) => Home(
    id                  : json[HomeFields.id] as int?,
    product_id          : json[HomeFields.product_id] as int?,
    product_name        : json[HomeFields.product_name] as String?,
    unit_tag            : json[HomeFields.unit_tag] as String?,
    image               : json[HomeFields.image] as String,
    purchase_price      : json[HomeFields.purchase_price] as double,
    sale_price          : json[HomeFields.sale_price] as double,
    description         : json[HomeFields.description] as String,
    view_quantity       : json[HomeFields.view_quantity] as String,
    vat_amount          : json[HomeFields.vat_amount] as double,
    discount_amount     : json[HomeFields.discount_amount] as double,
    maximum_quantity    : json[HomeFields.maximum_quantity] as double,
    current_stock       : json[HomeFields.current_stock] as double,
    weight              : json[HomeFields.weight] as double,
    sku                 : json[HomeFields.sku] as String,
    category_id         : json[HomeFields.category_id] as String,
    measurement_sku     : json[HomeFields.measurement_sku] as String,
    measurement_title   : json[HomeFields.measurement_title] as String,
    measurement_value   : json[HomeFields.measurement_value] as String,
    measurement         : json[HomeFields.measurement] as String,
  );

  Map<String, Object?> toJson() => {
    HomeFields.id                   : id,
    HomeFields.product_id           : product_id,
    HomeFields.product_name         : product_name,
    HomeFields.unit_tag             : unit_tag,
    HomeFields.image                : image,
    HomeFields.purchase_price       : purchase_price,
    HomeFields.sale_price           : sale_price,
    HomeFields.description          : description,
    HomeFields.view_quantity        : view_quantity,
    HomeFields.vat_amount           : vat_amount,
    HomeFields.discount_amount      : discount_amount,
    HomeFields.maximum_quantity     : maximum_quantity,
    HomeFields.current_stock        : current_stock,
    HomeFields.weight               : weight,
    HomeFields.sku                  : sku,
    HomeFields.category_id          : category_id,
    HomeFields.measurement_sku      : measurement_sku,
    HomeFields.measurement_title    : measurement_title,
    HomeFields.measurement_value    : measurement_value,
    HomeFields.measurement          : measurement,
  };
}