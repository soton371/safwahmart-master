import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/select_location.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/date_time.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/controllers/sidebar_con.dart';
import 'package:grocery/locals/database/login_db.dart';
import 'package:grocery/locals/model/login_model.dart';
import 'package:grocery/models/get_area.dart';
import 'package:grocery/views/account/getx_auth/login_scr.dart';
import 'package:grocery/views/front_screen.dart';
import 'package:new_version/new_version.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class AnimatedSplashScreen extends StatefulWidget {
  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  late Animation<double> animation;

  var loginController   = Get.put(LoginController());
  var locController     = Get.put(LocationController());
  var sidebarController = Get.put(SidebarController());
  var cartController    = Get.put(CartController());
  var timeController    = Get.put(DateTimeController());


  startTime() async {
    var _duration = const Duration(milliseconds: 1000);
    return Timer(_duration, _loadUserInfo);
  }

  _loadUserInfo() async {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const FrontScreen()), (route) => false);
  }

  ///for update notify
  void checkVersion()async{
    final newVersion = NewVersion(
      androidId: 'com.smartsoftware.sarabosorekrate',
    );

    final status = await newVersion.getVersionStatus();
    print('local version: ${status!.localVersion}');
    print('store version: ${status.storeVersion}');
    if(status.canUpdate){

      Future<void> launchAppStore(String appStoreLink) async {
        debugPrint(appStoreLink);
        if (await canLaunch(appStoreLink)) {
          await launch(appStoreLink);
        } else {
          throw 'Could not launch appStoreLink';
        }
      }

      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_)=>AlertDialog(
            title: const Text('Update Available'),
            content: Text('You can now update Sara Bosor ekrate from ${status.localVersion} to ${status.storeVersion}'),
            actions: [
              TextButton(
                  onPressed: (){
                    launchAppStore('https://play.google.com/store/apps/details?id=com.smartsoftware.sarabosorekrate');
                  },
                  child: const Text('Update')
              ),
              TextButton(
                  onPressed: ()=> Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const FrontScreen()), (route) => false),
                  child: const Text('Maybe Later')
              ),
            ],
          )
      );

    }else{
      startTime();
    }

  }

  ///for update notify
  // void getLocation()async{
  //   showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (context)=> AlertDialog(
  //         content:  Column(
  //           children: [
  //             Container(
  //               margin: const EdgeInsets.only(bottom: 8, top: 8),
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(2),
  //                   color: MyColors.shadow
  //               ),
  //               child: DropdownSearch<String>(
  //                 dropdownSearchBaseStyle: const TextStyle(fontSize: 18),
  //                 popupShape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8)),
  //                 mode: Mode.DIALOG,
  //                 showSearchBox: true,
  //                 dropdownSearchDecoration: const InputDecoration(
  //                   hintStyle: TextStyle(fontSize: 16),
  //                   hintText: 'Select Area *',
  //                   border: InputBorder.none,
  //                   enabledBorder: InputBorder.none,
  //                   focusedBorder: InputBorder.none,
  //                   isDense: true,
  //                   contentPadding: EdgeInsets.only(left: 10, top: 12),
  //                 ),
  //                 items: [
  //                   for(int i=0; i < areaList.length;i++)...{
  //                     areaList[i].name.toString()
  //                   },
  //                 ],
  //                 onChanged: (newVal) {
  //                   setState(() {
  //                     areaValue = newVal.toString();
  //                     int index = areaList.indexWhere((element) => element.name == newVal);
  //
  //                     areaId      = areaList.elementAt(index).id;
  //                     areaValue   = areaList.elementAt(index).name;
  //                   });
  //                 },
  //               ),
  //             ),
  //
  //             //for date
  //             InkWell(
  //               onTap: (){
  //                 timeController.selectDate(context);
  //                 setState((){});
  //               },
  //               child: Container(
  //                 padding: const EdgeInsets.symmetric(horizontal: 15),
  //                 height: 45,
  //                 alignment: Alignment.centerLeft,
  //                 color: MyColors.shadow,
  //                 child: Row(
  //                   children: [
  //                     Icon(Icons.calendar_today_outlined,color: Colors.black.withOpacity(0.5),size: 16,),
  //                     const SizedBox(width: 15,),
  //                     Obx(() => Text(timeController.dateIs == 'true' ? "${timeController.selectDates}".split(' ')[0] : 'Select Date *', style: TextStyle(
  //                         fontSize: 16,
  //                         color: Colors.black.withOpacity(0.6)
  //                     ),),),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //
  //             //select time
  //             Container(
  //               margin: const EdgeInsets.only(bottom: 8, top: 8),
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(2),
  //                   color: MyColors.shadow
  //               ),
  //               child: DropdownSearch<String>(
  //                 dropdownSearchBaseStyle: const TextStyle(fontSize: 18),
  //                 popupShape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8)),
  //                 mode: Mode.DIALOG,
  //                 showSearchBox: true,
  //                 dropdownSearchDecoration: const InputDecoration(
  //                   hintStyle: TextStyle(fontSize: 16),
  //                   hintText: 'Select Time *',
  //                   border: InputBorder.none,
  //                   enabledBorder: InputBorder.none,
  //                   focusedBorder: InputBorder.none,
  //                   isDense: true,
  //                   contentPadding: EdgeInsets.only(left: 10, top: 12),
  //                 ),
  //                 items: [
  //                   for(int i=0; i < timeController.timeList.length;i++)...{
  //                     '${timeController.timeList[i]['starting_time']} - ${timeController.timeList[i]['ending_time']}'
  //                   },
  //                 ],
  //                 onChanged: (newVal) {
  //                   setState(() {
  //                     timeController.selectTime = newVal.toString();
  //                     int index = timeController.timeList.indexWhere((element) => element.name == newVal);
  //
  //                     timeController.timeId      = timeController.timeList.elementAt(index).id;
  //                     timeController.selectTime  = timeController.timeList.elementAt(index).name;
  //                   });
  //                 },
  //               ),
  //             ),
  //
  //           ],
  //         ),
  //
  //         actions: [
  //           //Cancel
  //           TextButton(
  //               onPressed: ()=>Navigator.pop(context),
  //               child: Text('Cancel', style: TextStyle(color: MyColors.red),)
  //           ),
  //
  //           //Save
  //           TextButton(
  //               onPressed: () {
  //                 final login = Login(
  //                   token       : '${loginController.loginToken() ?? ''}',
  //                   name        : '${loginController.loginName() ?? ''}',
  //                   email       : '${loginController.loginEmail() ?? ''}',
  //                   phone       : '${loginController.loginPhone() ?? ''}',
  //                   user_id     : int.parse(loginController.loginUserId() ?? 0),
  //                   customer_id : int.parse(loginController.loginCustomerId() ?? 0),
  //                   district_id : int.parse('${locController.districtId}'),
  //                   district    : '${locController.districtValue}',
  //                   area_id     : areaId ?? int.parse('${loginController.loginAreaId() ?? '0'}'),
  //                   area        : areaValue ?? '${loginController.loginArea() ?? ''}',
  //                   address     : '${loginController.loginAddress() ?? ''}',
  //                   zip_code    : '${loginController.loginZipCode()}',
  //                 );
  //
  //                 LoginDatabase.instance.createLogin(context, login).then((value) {
  //                   loginController.refreshLogin();
  //                   loginController.loginToken();
  //                   loginController.loginName();
  //                   loginController.loginEmail();
  //                   loginController.loginPhone();
  //                   loginController.loginDistrictId();
  //                   loginController.loginDistrict();
  //                   loginController.loginAreaId();
  //                   loginController.loginArea();
  //                   loginController.loginAddress();
  //                   loginController.loginZipCode();
  //                   loginController.loginUserId();
  //                   loginController.loginCustomerId();
  //                   Navigator.pop(context);
  //                 });
  //               },
  //               child: const Text('Save',)
  //           ),
  //         ],
  //       )
  //   );
  // }


  //for cache delete
  // Future<void> _deleteCacheDir() async {
  //   var tempDir = await getTemporaryDirectory();
  //
  //   if (tempDir.existsSync()) {
  //     tempDir.deleteSync(recursive: true);
  //   }
  // }
  //
  // Future<void> _deleteAppDir() async {
  //   var appDocDir = await getApplicationDocumentsDirectory();
  //
  //   if (appDocDir.existsSync()) {
  //     appDocDir.deleteSync(recursive: true);
  //   }
  // }

  ///test location
  // var areaValue, areaId;
  // List areaList = [];
  // Future<dynamic> Areas(districtId)async {
  //   String url = '$baseUrl/get-areas/${districtId ?? 58}';
  //   var response = await http.get(Uri.parse(url));
  //   if (response.statusCode == 200) {
  //     GetAreaList area = getAreaListFromJson(response.body);
  //     List areaData = area.data.areas;
  //     for (var i = 0; i <= areaData.length; i++) {
  //       setState(() {
  //         areaList = areaData;
  //       });
  //     }
  //     return areaList;
  //   }
  // }


  @override
  void initState() {
    // _deleteCacheDir();
    // _deleteAppDir();
    checkVersion();
    // getLocation();
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();
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
    loginController.loginUserId();
    locController.Districts();
    locController.districtList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Padding(padding: EdgeInsets.only(bottom: 30.0),child:Text("Developed By Smart Software Ltd.")),

            ],),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: const AssetImage('assets/images/splash.png',),
                width: animation.value * 250,
                height: animation.value * 250,),
            ],
          ),
        ],
      ),
    );
  }
}