import 'package:get/get.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/locals/database/db_helper.dart';
import 'package:grocery/models/get_area.dart';
import 'package:grocery/models/get_district.dart';
import 'package:http/http.dart' as http;


class LocationController extends GetxController{

  var districtValue   = 'Dhaka'.obs;
  var districtId      = 58.obs;
  var shippingCharge  = 19.0.obs;
  var districtList    = [].obs;

  var receiverDistrictValue   = 'Dhaka'.obs;
  var receiverDistrictId      = 58.obs;
  var receiverShippingCharge  = 19.0.obs;
  var receiverDistrictList    = [].obs;

  Future<dynamic> Districts()async{
    String url = '$baseUrl/get-common-section-data';
    var response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      GetDistrictList district = getDistrictListFromJson(response.body);
      List districtData = district.data.districts;
      for (var i=0; i <= districtData.length; i++){
          districtList.value = districtData;
          receiverDistrictList.value = districtData;
        }
      return districtData;
    }
  }

  @override
  void onInit() {
    super.onInit();
    Districts();
  }
}