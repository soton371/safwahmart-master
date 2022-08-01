// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/controllers/test_con.dart';
import 'package:grocery/locals/database/db_helper.dart';
import 'package:grocery/locals/database/login_db.dart';
import 'package:grocery/locals/model/login_model.dart';
import 'package:grocery/models/get_banners.dart';
import 'package:grocery/models/get_blogs.dart';
import 'package:grocery/models/get_brands_model.dart';
import 'package:grocery/models/get_categories.dart';
import 'package:grocery/models/get_highlighted_brands_model.dart';
import 'package:grocery/models/get_highlighted_categories_model.dart';
import 'package:grocery/models/get_sliders_model.dart';
import 'package:grocery/views/front_screen.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';


String baseUrl = 'https://app.sarabosorekrate.com/api';
// String baseUrl = 'https://app.safwahmart.com/api';
// String baseUrl = 'https://appsafwahmart.hotelsetting.com/api';


String imgBaseUrl = 'https://app.sarabosorekrate.com';
// String imgBaseUrl = 'https://app.safwahmart.com';
// String imgBaseUrl = 'https://appsafwahmart.hotelsetting.com';


var loginController = Get.put(LoginController());
var testController  = Get.put(TestController());

//Login
Future login(BuildContext context, phone, password)async{

  var url = Uri.parse('$baseUrl/login');
  var res = await http.post(url,body: {
    'phone':phone,
    'password':password
  });

  var status = json.decode(res.body)['status'];
  var message = json.decode(res.body)['message'];

  var token, name, email, phones, userId, customerId, districtId, district, areaId, area, address, zipCode;
  switch(status){
    case 1:{

      var bodyData      = json.decode(res.body)['data'];
      var bodyUser      = json.decode(res.body)['data']['user'];
      var bodyCustomer  = json.decode(res.body)['data']['user']['customer'];

      token       = bodyData['token'] ?? '';
      name        = bodyUser['name'] ?? '';
      email       = bodyUser['email'] ?? '';
      phones      = bodyUser['phone'] ?? '';
      userId      = bodyUser['id'] ?? '0';
      customerId  = bodyCustomer['id'] ?? '0';
      districtId  = bodyCustomer['district'] != null ? bodyCustomer['district']['id'] : '0';
      district    = bodyCustomer['district'] != null ? bodyCustomer['district']['name'] : '';
      areaId      = bodyCustomer['area'] != null ? bodyCustomer['area']['id'] : '0';
      area        = bodyCustomer['area'] != null ? bodyCustomer['area']['name'] : '';
      address     = bodyCustomer['address'] ?? '';
      zipCode     = bodyCustomer['zip_code'] ?? '';

      final login = Login(
        token       : '$token',
        name        : '$name',
        email       : '$email',
        phone       : '$phones',
        user_id     : int.parse('$userId'),
        customer_id : int.parse('$customerId'),
        district_id : int.parse('$districtId'),
        district    : '$district',
        area_id     : int.parse('$areaId'),
        area        : '$area',
        address     : '$address',
        zip_code    : '$zipCode',
      );
      LoginDatabase.instance.createLogin(context, login).then((value) {
        loginController.refreshLogin();
        loginController.loginToken();
        loginController.loginName();
        loginController.loginEmail();
        loginController.loginPhone();
        loginController.loginDistrictId();
        loginController.loginDistrict();
        loginController.loginAreaId();
        loginController.loginArea();
        loginController.loginAddress();
        loginController.loginZipCode();
        loginController.loginCustomerId();
      });

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const FrontScreen()));
      MyComponents().mySnackBar(context, 'Login $message');
    }
    break;
    case 0:{
      Navigator.pop(context);
      MyComponents().wrongSnackBar(context, json.decode(res.body)['data'].toString());
    }
  }

}

//Register
Future register(BuildContext context, phone, password, name, email) async {

  var url = Uri.parse('$baseUrl/register');
  var res = await http.post(url,body: {
    'phone'   : phone.toString().replaceAll('+880', '0'),
    'password': password,
    'name'    : name,
    'email'   : email
  });
  var status = json.decode(res.body)['status'];
  var message = json.decode(res.body)['message'];

  switch(status){
    case 1:
      {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const FrontScreen()));
        MyComponents().mySnackBar(context, 'Register $message');

        final login = Login(
          token       : '${json.decode(res.body)['data']['token']}',
          name        : name,
          email       : email,
          phone       : phone,
          user_id     : 0,
          customer_id : 0,
          district_id : 0,
          district    : '',
          area_id     : 0,
          area        : '',
          address     : '',
          zip_code    : '',
        );
        LoginDatabase.instance.createLogin(context, login).then((value) {
          loginController.refreshLogin();
          loginController.loginToken();
          loginController.loginName();
          loginController.loginEmail();
          loginController.loginPhone();
          loginController.loginDistrictId();
          loginController.loginDistrict();
          loginController.loginAreaId();
          loginController.loginArea();
          loginController.loginAddress();
          loginController.loginZipCode();
          loginController.loginUserId();
        });

      }
      break;
    case 0:
      {
        var errorMessage = json.decode(res.body)['data'];
        MyComponents().wrongSnackBar(context, errorMessage.toString());
        Navigator.pop(context);
      }
  }

}

//Update Customer
Future updateCustomer(BuildContext context, name, email, address, districtId, areaId, zipCode, country, token, phone) async {

  var url = Uri.parse('$baseUrl/update-customer');
  var res = await http.post(url,body: {
    'name'        : name,
    'email'       : email,
    'address'     : address,
    'district_id' : districtId,
    'area_id'     : areaId,
    'zip_code'    : zipCode,
    'country'     : country,
    'phone'       : phone,
  },headers: {
    HttpHeaders.authorizationHeader: 'Bearer $token'
  });

  if(res.statusCode == 200){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const FrontScreen()));
    MyComponents().mySnackBar(context, 'Update Successfully');
    final login = Login(
      token       : '$token',
      name        : '$name',
      email       : '$email',
      phone       : '$phone',
      user_id     : loginController.loginUserId(),
      customer_id : loginController.loginCustomerId(),
      district_id : districtId,
      district    : '${loginController.loginDistrict()}',
      area_id     : areaId,
      area        : '${loginController.loginArea()}',
      address     : '${loginController.loginAddress()}',
      zip_code    : '$zipCode',
    );
    LoginDatabase.instance.createLogin(context, login).then((value) {
      loginController.refreshLogin();
      loginController.loginToken();
      loginController.loginName();
      loginController.loginEmail();
      loginController.loginPhone();
      loginController.loginDistrictId();
      loginController.loginDistrict();
      loginController.loginAreaId();
      loginController.loginArea();
      loginController.loginAddress();
      loginController.loginZipCode();
      loginController.loginUserId();
    });
  }
}

Future updatePassword(BuildContext context, String userId, String password)async{
  var url = Uri.parse('$baseUrl/update-password');
  var res = await http.post(url,body: {
    'user_id':userId,
    'password':password
  });

  var status = json.decode(res.body)['status'];
  var message = json.decode(res.body)['message'];

  switch(status){
    case 1:
      {
        AlertDialog alert=AlertDialog(
          content: ListView(
            shrinkWrap: true,
            children: [
              Lottie.asset('assets/json_files/33886-check-okey-done.json',height: 100),
              Text('\n$message',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        );
        showDialog(barrierDismissible: false,
          context:context,
          builder:(BuildContext context){
            Future.delayed(const Duration(milliseconds: 2500), () {
              return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FrontScreen()));
            });
            return alert;
          },
        );
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>FrontScreen()));
      }
      break;
    case 0:
      {
        MyComponents().wrongSnackBar(context, '$message');
      }
  }

}

//for get highlighted categories
Future fetchGetHighlightedCategories() async{
  var isCacheExist = await APICacheManager().isAPICacheKeyExist('highlighted_categories');
  if(!isCacheExist){
    var url = Uri.parse('$baseUrl/get-highlighted-categories');
    var res = await http.get(url);
    GetHighlightedCategoriesModel getData = getHighlightedCategoriesModelFromJson(res.body);
    switch(getData.status){
      case 1:
        {
          APICacheDBModel cacheDBModel = APICacheDBModel(key: 'highlighted_categories', syncData: res.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return getData.data.categories;
        }
      default:
        {
          return getData.message;
        }
    }
  }
  else{
    var cacheData = await APICacheManager().getCacheData('highlighted_categories');
    return getHighlightedCategoriesModelFromJson(cacheData.syncData).data.categories;
  }
}

// for get sliders
Future fetchGetSliders() async{
  var isCacheExist = await APICacheManager().isAPICacheKeyExist('get_sliders');
  if(!isCacheExist){
    var url = Uri.parse('$baseUrl/get-sliders');
    var res = await http.get(url);

    GetSlidersModel getData = getSlidersModelFromJson(res.body);

    switch(getData.status){
      case 1:
        {
          APICacheDBModel cacheDBModel = APICacheDBModel(key: 'get_sliders', syncData: res.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return getData.data.sliders;
        }
      default:
        {
          return getData.message;
        }
    }
  }
  else{
    var cacheData = await APICacheManager().getCacheData('get_sliders');
    return getSlidersModelFromJson(cacheData.syncData).data.sliders;
  }
}

//for highlighted brands
Future fetchGetHighlightedBrands() async{
  var url = Uri.parse('$baseUrl/get-highlighted-brands');
  var res = await http.get(url);
  GetHighlightedBrandsModel getData = getHighlightedBrandsModelFromJson(res.body);
  switch (getData.status){
    case 1:
      {
        return getData.data.brands;
      }
    case 0:
      {
        return getData.message;
      }
  }
}

//for all brands
Future fetchGetBrands() async{
  var url = Uri.parse('$baseUrl/get-brands');
  var res = await http.get(url);
  GetBrandsModel getData = getBrandsModelFromJson(res.body);
  switch (getData.status){
    case 1:
      {
        return getData.data.brands.data;
      }
    case 0:
      {
        return getData.message;
      }
  }
}



//for all categories
Future fetchGetCategories() async{
  var isCacheExist = await APICacheManager().isAPICacheKeyExist('categories');
  if(!isCacheExist){
    var url = Uri.parse('$baseUrl/get-categories');
    var res = await http.get(url);
    GetCategories getData = getCategoriesFromJson(res.body);
    switch(getData.status){
      case 1:
        {
          APICacheDBModel cacheDBModel = APICacheDBModel(key: 'categories', syncData: res.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return getData.data.categories.data;
        }
      default:
        {
          return getData.message;
        }
    }
  }
  else{
    var cacheData = await APICacheManager().getCacheData('categories');
    return getCategoriesFromJson(cacheData.syncData).data.categories.data;
  }
}

//for banners
Future fetchGetBanners() async{
  var isCacheExist = await APICacheManager().isAPICacheKeyExist('get_banners');
  if(!isCacheExist){
    var url = Uri.parse('$baseUrl/get-banners');
    var res = await http.get(url);
    GetBannersModel getData = getBannersModelFromJson(res.body);
    switch(getData.status){
      case 1:
        {
          APICacheDBModel cacheDBModel = APICacheDBModel(key: 'get_banners', syncData: res.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return getData.data.banners;
        }
      default:
        {
          return getData.message;
        }
    }
  }
  else{
    var cacheData = await APICacheManager().getCacheData('get_banners');
    return getBannersModelFromJson(cacheData.syncData).data.banners;
  }
}

//for blogs
Future fetchGetBlogs() async{

    var url = Uri.parse('$baseUrl/get-blogs');
    var res = await http.get(url);
    GetBlogsModel getData = getBlogsModelFromJson(res.body);
    switch(getData.status){
      case 1:
        {
          return getData.data.blogs.data;
        }
      default:
        {
          return getData.message;
        }
    }
}

//for today deals
Future fetchHighlightedProduct() async{
  var isCacheExist = await APICacheManager().isAPICacheKeyExist('highlight_product');
  if(!isCacheExist){
    var url = Uri.parse('$baseUrl/get-highlighted-products');
    var res = await http.get(url);
    var getData = json.decode(res.body);
    switch(res.statusCode){
      case 200:
        {
          APICacheDBModel cacheDBModel = APICacheDBModel(key: 'highlight_product', syncData: res.body);
          await APICacheManager().addCacheData(cacheDBModel);
          return getData;
        }
      default:
        {
          return 'Something Wrong Highlighted Products';
        }
    }
  }
  else{
    var cacheData = await APICacheManager().getCacheData('highlight_product');
    return json.decode(cacheData.syncData);
  }
}

//for category & brand wise product
Future fetchCategoryWiseProducts(String type, String slug) async{
  var url = Uri.parse('$baseUrl/category-or-brand-wise-products?type=$type&slug=$slug');
  var res = await http.get(url);
  var getData = json.decode(res.body);
  switch(res.statusCode){
    case 200:
      {
        return getData['products']['data'];
      }
    default:
      {
        return 'Something Wrong Category & Brand Wise Products';
      }
  }
}

//for related products
Future fetchRelatedProducts(String categoryId, String id) async{
  var url = Uri.parse('$baseUrl/get-related-products/$categoryId/$id');
  var res = await http.get(url);
  var getData = json.decode(res.body);
  switch(res.statusCode){
    case 200:
      {
        return getData['data']['products'];
      }
    default:
      {
        return 'Something Wrong Related Products';
      }
  }
}

//for search Products
Future searchProducts(name)async{
    var url = Uri.parse('$baseUrl/search-products?search=$name');
    var res = await http.get(url);

    var getProducts = json.decode(res.body)['products']['data'];

    switch(res.statusCode){
      case 200:
        {
          return getProducts;
        }
      default:
        {
          return 'Something Wrong With Search Products';
        }
    }
}


//for order
Future order(BuildContext context, {warehouseId, timeSlotId, couponId, deliveryDate, orderSource, paymentType, totalQuantity, subtotal, totalVatAmount,
    shippingCost, totalDiscountAmount, couponDiscountAmount, name, phone, email, address, areaId, districtId, zipCode, orderNote, shipToDifferentAddress,
    receiverName, receiverPhone, receiverEmail, receiverAddress, receiverAreaId, receiverDistrictId, receiverZipCode, receiverOrderNote, productId,
    purchasePrice, salePrice, quantity, vatPercent, vatAmount, discountPercent, discountAmount, localId, totalWeight, weight, measurementTitle, measurementValue, measurementSku}) async{

  var cartController = Get.put(CartController());


  var productIds         = json.decode(productId);
  var purchasePrices     = json.decode(purchasePrice);
  var salePrices         = json.decode(salePrice);
  var quantitys          = json.decode(quantity);
  var vatPercents        = json.decode(vatPercent);
  var vatAmounts         = json.decode(vatAmount);
  var discountPercents   = json.decode(discountPercent);
  var discountAmounts    = json.decode(discountAmount);
  var localIds           = json.decode(localId);
  var weights            = json.decode(weight);
  List measurementTitles = measurementTitle.toString().replaceAll('[', '').replaceAll(']', '').split(',');
  List measurementValues = measurementValue.toString().replaceAll('[', '').replaceAll(']', '').split(',');
  List measurementSkus   = measurementSku.toString().replaceAll('[', '').replaceAll(']', '').split(',');

  Map <String, String> data;

  data ={
    'warehouse_id'                : '$warehouseId',
    'time_slot_id'                : '$timeSlotId',
    'coupon_id'                   : '$couponId',
    'delivery_date'               : '$deliveryDate',
    'order_source'                : '$orderSource',
    'payment_type'                : '$paymentType',
    'total_quantity'              : '$totalQuantity',
    'total_weight'                : '$totalWeight',
    'subtotal'                    : '$subtotal',
    'total_vat_amount'            : '$totalVatAmount',
    'shipping_cost'               : '$shippingCost',
    'total_discount_amount'       : '$totalDiscountAmount',
    'coupon_discount_amount'      : '$couponDiscountAmount',
    'current_status'              : '1',
    'name'                        : '$name',
    'phone'                       : '$phone',
    'email'                       : '${email.toString().contains('┤') ? email.toString().split('┤')[1].split('├')[0].replaceAll(' ', '') : email}',
    'country'                     : 'Bangladesh',
    'address'                     : '$address',
    'area_id'                     : '$areaId',
    'district_id'                 : '$districtId',
    'zip_code'                    : '${zipCode.toString().contains('┤') ? zipCode.toString().split('┤')[1].split('├')[0].replaceAll(' ', '') : zipCode}',
    'order_note'                  : '$orderNote',
    'ship_to_different_address'   : shipToDifferentAddress ? 'Yes' : 'No',
    'receiver_name'               : '${shipToDifferentAddress ? receiverName : ''}',
    'receiver_phone'              : '${shipToDifferentAddress ? receiverPhone : ''}',
    'receiver_email'              : '${shipToDifferentAddress ? receiverEmail : ''}',
    'receiver_country'            : shipToDifferentAddress ? 'Bangladesh' : '',
    'receiver_address'            : '${shipToDifferentAddress ? receiverAddress : ''}',
    'receiver_area_id'            : '${shipToDifferentAddress ? receiverAreaId : ''}',
    'receiver_district_id'        : '${shipToDifferentAddress ? receiverDistrictId : ''}',
    'receiver_zip_code'           : '${shipToDifferentAddress ? receiverZipCode : ''}',
    'receiver_order_note'         : '${shipToDifferentAddress ? receiverOrderNote : ''}',
    'payment_status'              : '',
    'payment_method'              : '',
    'payment_tnx_no'              : '',
  };


  for(var i = 0; i < productIds.length; i++){
    data["product_id[$i]"]            = productIds[i].toString();
    data["purchase_price[$i]"]        = purchasePrices[i].toString();
    data["sale_price[$i]"]            = salePrices[i].toString();
    data["quantity[$i]"]              = quantitys[i].toString();
    data["vat_percent[$i]"]           = vatPercents[i].toString();
    data["vat_amount[$i]"]            = vatAmounts[i].toString();
    data["discount_percent[$i]"]      = discountPercents[i].toString();
    data["discount_amount[$i]"]       = discountAmounts[i].toString();
    data["weight[$i]"]                = weights[i].toString();
    data["product_variation_id[$i]"]  = '';
    data["measurement_title[$i]"]     = measurementTitles[i].toString();
    data["measurement_sku[$i]"]       = measurementSkus[i].toString();
    data["measurement_value[$i]"]     = measurementValues[i].toString();
  }

  var url = '$baseUrl/submit-order';
  var response = await http.post(Uri.parse(url),
      body: data
  );
  var status  = json.decode(response.body)['status'];
  var message = json.decode(response.body)['message'];

  if(status == 1){
    for (var i = 0; i < localIds.length; i ++){
      CartDatabase.instance.deleteCart(localIds[i]).then((value) {
          cartController.refreshCarts();
          cartController.carts;
        } );
    }

    AlertDialog alert=AlertDialog(
      content: ListView(
        shrinkWrap: true,
        children: [
          Lottie.asset('assets/json_files/100858-success.json',height: 100),
          Text('\n$message',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){

        return alert;
      },
    );

    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.pop(context);
      return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FrontScreen()));
    });
  }

  else{
    Navigator.pop(context);
    return MyComponents().wrongSnackBar(context, message);
  }
}


//for update order
Future updateOrders(BuildContext context, {orderId, name, phone, email, address, areaId, districtId, token, zipCode, orderNote, shippingCost, shipToDifferentAddress}) async{
  Map <String, String> data;
  // Map <String, String> differentData;

  data = {
    'name'                        : '$name',
    'email'                       : '${email.toString().contains('┤') ? email.toString().split('┤')[1].split('├')[0].replaceAll(' ', '') : email}',
    'phone'                       : '$phone',
    'address'                     : '$address',
    'area_id'                     : '$areaId',
    'district_id'                 : '$districtId',
    'zip_code'                    : '${zipCode.toString().contains('┤') ? zipCode.toString().split('┤')[1].split('├')[0].replaceAll(' ', '') : zipCode}',
    'order_note'                  : '$orderNote',
    'shipping_cost'               : '$shippingCost',
    'ship_to_different_address'   : shipToDifferentAddress ? 'Yes' : 'No',
  };


  var url = '$baseUrl/update-single-order/$orderId';
  var response = await http.post(Uri.parse(url),
      body: data,headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token'
      }
  );
  var status  = json.decode(response.body)['status'];
  var message = json.decode(response.body)['message'];

  if(status == 1){
    AlertDialog alert=AlertDialog(
      content: ListView(
        shrinkWrap: true,
        children: [
          Lottie.asset('assets/json_files/100858-success.json',height: 100),
          const Text('\nSuccess',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){

        return alert;
      },
    );

    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.pop(context);
      return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FrontScreen()));
    });
  }

  else{
    Navigator.pop(context);
    return MyComponents().wrongSnackBar(context, message);
  }
}



// //for fetch wishlist
Future fetchWishlist(String userId, String token)async{

  var url = Uri.parse('$baseUrl/get-customer-wishlists/$userId');
  // var url = Uri.parse('$baseUrl/get-wishlist/$userId');
  var res = await http.get(url,headers: {
    HttpHeaders.authorizationHeader: 'Bearer $token'
  });

  var getWishlist = json.decode(res.body)['data']['wishlists'];
  var status = json.decode(res.body)['status'];


  switch(status){
    case 1:
      {
        return getWishlist;
      }
    case 0:
      {
        debugPrint('object: something wrong fetch wishlist');
      }
  }

}


//for order list
Future orderList(BuildContext context, String customerId, token)async{
  var url = Uri.parse('$baseUrl/get-all-orders-by-customer/$customerId');
  var response = await http.get(url,headers: {
    HttpHeaders.authorizationHeader: 'Bearer $token'
  });

  var status = json.decode(response.body)['status'];
  switch(status){
    case 1:
      {
        var orderList = json.decode(response.body)['data']['orders'];
        return orderList;
      }
    case 0:
      {
        MyComponents().wrongSnackBar(context, 'Something went wrong');
      }
  }
}



//for products request
Future productRequest({required BuildContext context, required String customerId, required String productId, required String productVariationId, required String token})async{
  var url = Uri.parse('$baseUrl/store-stock-request');
  var res = await http.post(url,headers: {
    HttpHeaders.authorizationHeader: 'Bearer $token'
  },
    body: {
    'customer_id': customerId,
      'product_id': productId,
    }
  );

  var status = json.decode(res.body)['status'];

  switch(status){
    case 1:
      {
        //testController.request.value = 'false';
        MyComponents().mySnackBar(context, 'Success Product Request');
      }
      break;
    default:
      {
        MyComponents().wrongSnackBar(context, 'Something wrong');
      }
  }
}


//for get products request
Future getProductRequest({context,userId,token})async{
  var url = Uri.parse('$baseUrl/get-all-stock-requests-by-customer/$userId');
  var res = await http.get(url,headers: {
    HttpHeaders.authorizationHeader: 'Bearer $token'
  },
  );
  switch(res.statusCode){
    case 200:
      {
        dynamic data = json.decode(res.body);
        return data;
      }
    default:
      {
        debugPrint('something wrong get products rrequest: ${json.decode(res.body)}');
      }
  }

}