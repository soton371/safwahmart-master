import 'package:get/get.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/models/get_company.dart';
import 'package:http/http.dart' as http;

class CompanyController extends GetxController{
  var hotline = ''.obs;
  var email = ''.obs;
  var website = ''.obs;
  var logo = ''.obs;
  var message = ''.obs;

  @override
  void onInit() {
    fetchCompany();
    super.onInit();
  }

  Future fetchCompany()async{
    var url = Uri.parse('$baseUrl/get-company');
    var res = await http.get(url);

    final getCompany = getCompanyFromJson(res.body);

    if(getCompany.status==1){
      var data = getCompany.data.company;
      hotline.value = data.hotline.toString();
      email.value = data.email.toString();
      website.value = data.website.toString();
      logo.value = data.logo.toString();
    }else{
      message.value = getCompany.message.toString();

    }


  }

}