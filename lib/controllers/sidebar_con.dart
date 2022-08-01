import 'dart:convert';
import 'package:get/get.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:http/http.dart' as http;


class SidebarController extends GetxController{
  var sidebarItems = [].obs;

  @override
  void onInit() {
    fetchSidebar();
    super.onInit();
  }

  Future fetchSidebar() async{
    var url = Uri.parse('$baseUrl/get-common-section-data');
    var res = await http.get(url);

    var status = json.decode(res.body)['status'];
    var sidebarCategories = json.decode(res.body)['data']['sidebarCategories'];

    switch(status){
      case 1:
        {
          sidebarItems.value = sidebarCategories;
        }
        break;
      case 0:
        {
          print('something wrong get-common-section-data');
        }
    }

  }

}