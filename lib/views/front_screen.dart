import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/views/account/account_screen.dart';
import 'package:grocery/views/account/getx_auth/login_scr.dart';
import 'package:grocery/views/category/category_screen.dart';
import 'package:grocery/views/store/new_store_screen.dart';

class FrontScreen extends StatefulWidget {
  const FrontScreen({Key? key}) : super(key: key);

  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {

  var cartController = Get.put(CartController());
  var loginController = Get.put(LoginController());


  dynamic pageController;
  var getPageIndex = 0;

  @override
  void initState(){
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();

  }


  whenPageChange(int pageIndex){
    setState((){
      getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex){
    pageController.animateToPage(pageIndex,duration: const Duration(milliseconds: 400),curve: Curves.ease);
  }

  //for back press to exit
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        final differ = DateTime.now().difference(timeBackPressed);
        final exitWarning = differ >= const Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if(exitWarning){
          MyComponents().exitAlertDialog(context);
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
        body: PageView(
          children: [
            // NewStoreScreen(),
            const NewStoreScreen(),
            const CategoryScreen(),
            loginController.loginToken() != ''?const AccountScreen() : LoginScreen(),
          ],
          controller: pageController,
          onPageChanged: whenPageChange,
          physics: const NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: CupertinoTabBar(
          border: const Border(top: BorderSide.none),
            currentIndex: getPageIndex,
            onTap: onTapChangePage,
            activeColor: MyColors.primary,
            inactiveColor: MyColors.inactive,
            backgroundColor: Colors.white,
            items:  const [
              BottomNavigationBarItem(icon: Icon(Icons.home,size: 25,),label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.list,size: 20,),label: 'Categories'),
              BottomNavigationBarItem(icon: Icon(Icons.person,size: 20,),label: 'My Account'),
              // BottomNavigationBarItem(icon: Icon(Icons.telegram,size: 20,),label: 'Test'),
            ]
        ),
      ),
    );
  }
}