
//Table Name
var tableNameLogin = 'login';

//Field Name in database
class LoginFields{

  static final List<String> values = [
    id, token, name, email, phone, user_id, customer_id, district_id, district, area_id,
    area, address, zip_code
  ];

  static String id           = 'id';
  static String token        = 'token';
  static String name         = 'name';
  static String email        = 'email';
  static String phone        = 'phone';
  static String user_id      = 'user_id';
  static String customer_id  = 'customer_id';
  static String district_id  = 'district_id';
  static String district     = 'district';
  static String area_id      = 'area_id';
  static String area         = 'area';
  static String address      = 'address';
  static String zip_code     = 'zip_code';
}

//Model for send/get data from database
class Login{
  var id;
  var token;
  var name;
  var email;
  var phone;
  var user_id;
  var customer_id;
  var district_id;
  var district;
  var area_id;
  var area;
  var address;
  var zip_code;

  Login({
    this.id,
    this.token,
    this.name,
    this.email,
    this.phone,
    this.user_id,
    this.customer_id,
    this.district_id,
    this.district,
    this.area_id,
    this.area,
    this.address,
    this.zip_code,
  });

  Login copy({
    int? id,
    String? token,
    String? name,
    String? email,
    String? phone,
    int? user_id,
    int? customer_id,
    int? district_id,
    String? district,
    int? area_id,
    String? area,
    String? address,
    String? zip_code,

  }) => Login(
    id          : id ?? this.id,
    token       : token ?? this.token,
    name        : name ?? this.name,
    email       : email ?? this.email,
    phone       : phone ?? this.phone,
    user_id     : user_id ?? this.user_id,
    customer_id : customer_id ?? this.customer_id,
    district_id : district_id ?? this.district_id,
    district    : district ?? this.district,
    area_id     : area_id ?? this.area_id,
    area        : area ?? this.area,
    address     : address ?? this.address,
    zip_code    : zip_code ?? this.zip_code,
  );
  static Login fromJson(Map<String, Object?> json) => Login(
    id          : json[LoginFields.id] as int,
    token       : json[LoginFields.token] as String,
    name        : json[LoginFields.name] as String,
    email       : json[LoginFields.email] as String,
    phone       : json[LoginFields.phone] as String,
    user_id     : json[LoginFields.user_id] as int,
    customer_id : json[LoginFields.customer_id] as int,
    district_id : json[LoginFields.district_id] as int,
    district    : json[LoginFields.district] as String,
    area_id     : json[LoginFields.area_id] as int,
    area        : json[LoginFields.area] as String,
    address     : json[LoginFields.address] as String,
    zip_code    : json[LoginFields.zip_code] as String,
  );

  Map<String, Object?> toJson() => {
    LoginFields.id          : id,
    LoginFields.token       : token,
    LoginFields.name        : name,
    LoginFields.email       : email,
    LoginFields.phone       : phone,
    LoginFields.user_id     : user_id,
    LoginFields.customer_id : customer_id,
    LoginFields.district_id : district_id,
    LoginFields.district    : district,
    LoginFields.area_id     : area_id,
    LoginFields.area        : area,
    LoginFields.address     : address,
    LoginFields.zip_code    : zip_code,
  };
}