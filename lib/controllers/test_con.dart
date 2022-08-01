import 'package:get/get.dart';

class TestController extends GetxController{
  var proList = [].obs;
  var request = ''.obs;


  totalPrice(){
    RxDouble sum = 0.0.obs;
    for (var i = 0; i < proList.length; i++){
      sum.value = (sum + (proList[i].sale_price - proList[i].discount_amount) * proList[i].quantity).toDouble();
    }
    return sum.toStringAsFixed(2);
  }
}