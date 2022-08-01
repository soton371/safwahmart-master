import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/locals/database/login_db.dart';
import 'package:grocery/views/front_screen.dart';


class LoginController extends GetxController{
  var login       = [].obs;


  @override
  void onInit() {
    super.onInit();
    refreshLogin();
  }

  @override
  void dispose(){
    LoginDatabase.instance.close();
    super.dispose();
  }

  Future refreshLogin() async{
    login.value = await LoginDatabase.instance.viewLogin();
  }


  loginToken(){
    RxString token = ''.obs;
    for (var i = 0; i < login.length; i++){
      token.value = login[i].token.toString();
    }
    return token;
  }

  loginName(){
    RxString name = ''.obs;
    for (var i = 0; i < login.length; i++){
      name.value = login[i].name;
    }
    return name;
  }

  loginEmail(){
    RxString email = ''.obs;
    for (var i = 0; i < login.length; i++){
      email.value = login[i].email;
    }
    return email;
  }

  loginPhone(){
    RxString phone = ''.obs;
    for (var i = 0; i < login.length; i++){
      phone.value = login[i].phone;
    }
    return phone;
  }

  loginDistrictId(){
    RxString districtId = ''.obs;
    for (var i = 0; i < login.length; i++){
      districtId.value = login[i].district_id.toString();
    }
    return districtId;
  }

  loginDistrict(){
    RxString district = ''.obs;
    for (var i = 0; i < login.length; i++){
      district.value = login[i].district;
    }
    return district;
  }

  loginAreaId(){
    RxString areaId = ''.obs;
    for (var i = 0; i < login.length; i++){
      areaId.value = login[i].area_id.toString();
    }
    return areaId;
  }

  loginArea(){
    RxString area = ''.obs;
    for (var i = 0; i < login.length; i++){
      area.value = login[i].area;
    }
    return area;
  }

  loginAddress(){
    RxString address = ''.obs;
    for (var i = 0; i < login.length; i++){
      address.value = login[i].address;
    }
    return address;
  }

  loginZipCode(){
    RxString zipCode = ''.obs;
    for (var i = 0; i < login.length; i++){
      zipCode.value = login[i].zip_code;
    }
    return zipCode;
  }

  loginCustomerId(){
    RxString customerId = ''.obs;
    for (var i = 0; i < login.length; i++){
      customerId.value = login[i].customer_id.toString();
    }
    return customerId.toString();
  }

  loginUserId(){
    RxString userId = ''.obs;
    for (var i = 0; i < login.length; i++){
      userId.value = login[i].user_id.toString();
    }
    return userId.toString();
  }


  LogoutValue(BuildContext context){
    for(var i = 0; i<login.length; i++){
      LoginDatabase.instance.deleteLogin(login[i].phone);
    }
    MyComponents().mySnackBar(context, 'Log out success');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const FrontScreen()));
  }
}