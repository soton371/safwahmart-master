import 'dart:async';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/locals/database/login_db.dart';
import 'package:grocery/locals/model/login_model.dart';
import 'package:grocery/models/get_area.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/select_location.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:lottie/lottie.dart';

class UpdateCustomerScreen extends StatefulWidget {
  const UpdateCustomerScreen({Key? key}) : super(key: key);

  @override
  State<UpdateCustomerScreen> createState() => _UpdateCustomerScreenState();
}

class _UpdateCustomerScreenState extends State<UpdateCustomerScreen> {
  //add for check realtime internet
  bool status = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription _streamSubscription;

  void checkRealtimeConnection() {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile) {
        status = true;
      } else if (event == ConnectivityResult.wifi) {
        setState(() {
          status = true;
        });
      } else {
        status = false;
      }
      setState(() {});
    });
  }

  Widget noInternetConnection() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/json_files/100597-wifi-no-internet.json',
                height: 200),
            const Text('There is no Internet connection')
          ],
        ),
      ),
    );
  }

  //for update user profile
  var loginController = Get.put(LoginController());

  var fullName, email, address, zipCode, phone;
  getUserInfo() {
    setState((){
      fullName  = TextEditingController(text: loginController.loginName().toString());
      email     = TextEditingController(text: loginController.loginEmail().toString());
      address   = TextEditingController(text: loginController.loginAddress().toString());
      zipCode   = TextEditingController(text: loginController.loginZipCode().toString());
      phone     = TextEditingController(text: loginController.loginPhone().toString());
    });
  }

  var locController  = Get.put(LocationController());

  var areaValue, areaId;
  List areaList     = [];
  Future<dynamic> Areas(districtId)async{
    String url = '$baseUrl/get-areas/${districtId ?? locController.districtId}';
    var response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      GetAreaList area = getAreaListFromJson(response.body);
      List areaData = area.data.areas;
      for (var i=0; i <= areaData.length; i++){
        setState(() {
          areaList = areaData;
        });}
      return areaData;
    }
  }

  @override
  void initState() {
    getUserInfo();
    loginController.refreshLogin();
    loginController.login;
    loginController.loginArea();
    Areas(locController.districtId);
    checkRealtimeConnection();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xfffafafa),
              titleSpacing: 0,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
            ),
            body: Center(
              child: ListView(
                shrinkWrap: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                children: [
                  const Text(
                    '\nUpdate your profile',
                    textAlign: TextAlign.center,
                  ),

                  //input section
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 50),
                    child: Container(
                      decoration: BoxDecoration(
                          color: MyColors.background,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 8.0,
                                color: MyColors.shadow,
                                offset: const Offset(0, 3)),
                          ]),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Name",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.all(15),
                            ),
                            autofocus: false,
                            controller: fullName,
                          ),
                          Divider(
                            color: MyColors.shadow,
                            height: 0.5,
                          ),

                          //for email
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.all(15),
                            ),
                            autofocus: false,
                            controller: email,
                          ),
                          Divider(
                            color: MyColors.shadow,
                            height: 0.5,
                          ),
                          //for Phone number
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            readOnly: true,
                            decoration: const InputDecoration(
                              hintText: "Phone number",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.all(15),
                            ),
                            autofocus: false,
                            controller: phone,
                          ),
                          Divider(
                            color: MyColors.shadow,
                            height: 0.5,
                          ),

                          //for District id
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                ),
                            child: DropdownSearch<String>(
                              dropdownSearchBaseStyle:
                                  const TextStyle(fontSize: 18),
                              popupShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              dropdownSearchDecoration: InputDecoration(
                                hintStyle: const TextStyle(fontSize: 16),
                                hintText: '${loginController.loginDistrict() != '' ? loginController.loginDistrict() : locController.districtValue}',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.only(left: 15,top: 10),
                              ),
                              items: [
                                for(int i=0; i<locController.districtList.length;i++)...{
                                  locController.districtList[i].name.toString(),
                                },
                              ],
                              onChanged: (newVal) {
                                setState(() {
                                  locController.districtValue.value = newVal!;
                                  int index = locController.districtList.indexWhere((element) => element.name == newVal);
                                  locController.districtId.value        = locController.districtList.elementAt(index).id;
                                  locController.districtValue.value     = locController.districtList.elementAt(index).name;
                                  Areas(locController.districtList.elementAt(index).id);
                                });
                              },
                            ),
                          ),

                          //for area id
                          Divider(
                            color: MyColors.shadow,
                            height: 0.5,
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: DropdownSearch<String>(
                              dropdownSearchBaseStyle:
                              const TextStyle(fontSize: 18),
                              popupShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              mode: Mode.DIALOG,
                              showSearchBox: true,
                              dropdownSearchDecoration:  InputDecoration(
                                hintStyle: const TextStyle(fontSize: 16),
                                hintText: '${loginController.loginArea() != '' ? loginController.loginArea() : 'Select Area*'}',
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(left: 15,top: 10),
                              ),
                              items:  [
                                for(int i=0; i<areaList.length;i++)...{
                                  areaList[i].name.toString(),
                                },
                              ],
                              onChanged: (newVal) {
                                setState(() {
                                  areaValue = newVal;
                                  int index = areaList.indexWhere((element) => element.name == newVal);
                                  areaId        = areaList.elementAt(index).id;
                                  areaValue     = areaList.elementAt(index).name;
                                });
                              },
                            ),
                          ),

                          Divider(
                            color: MyColors.shadow,
                            height: 0.5,
                          ),
                          //for Address
                          TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Address",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.all(15),
                            ),
                            autofocus: false,
                            controller: address,
                          ),
                          Divider(
                            color: MyColors.shadow,
                            height: 0.5,
                          ),


                          //for zip code
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "Zip Code",
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.all(15),
                            ),
                            autofocus: false,
                            controller: zipCode,
                          ),

                        ],
                      ),
                    ),
                  ),

                  //button section
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15, top: 35),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(48)),
                        boxShadow: [
                          BoxShadow(
                            color: MyColors.primary.withAlpha(80),
                            blurRadius: 5,
                            offset: const Offset(
                                0, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(primary: MyColors.primary),
                        onPressed: () async {
                          MyComponents().showLoaderDialog(context);
                          updateCustomer(context, fullName.text, email.text, address.text, locController.districtId.toString(),
                          '${areaId ?? loginController.loginAreaId()}', zipCode.text, 'Bangladesh', loginController.loginToken(), phone.text);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: <Widget>[
                            const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "UPDATE"),
                            ),
                            Positioned(
                              right: 16,
                              child: ClipOval(
                                child: Container(
                                  color: MyColors.secondary,
                                  // button color
                                  child: SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: MyColors.background,
                                        size: 15,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,)
                ],
              ),
            ),
          )
        : noInternetConnection();
  }
}
