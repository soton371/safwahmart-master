import 'dart:async';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/views/account/getx_auth/login_scr.dart';
import 'package:grocery/views/account/new_password_screen.dart';
import 'package:grocery/views/account/update_customer/new_edit_profile.dart';
import 'package:grocery/views/account/update_password.dart';
import 'package:grocery/views/order/orderScreen.dart';
import 'package:grocery/views/stock_request/stock_request.dart';
import 'package:grocery/views/wishlist/wish_list.dart';
import 'package:grocery/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_sizes.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:grocery/widgets/drawer_widget.dart';
import 'package:get/get.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  var loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Sara Bosor ekrate',
        linkUrl: 'https://play.google.com/store/apps/details?id=com.smartsoftware.sarabosorekrate',
        chooserTitle: 'Sara Bosor ekrate'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: DrawerWidget(),
      body: Padding(
        padding: EdgeInsets.all(MySizes.bodyPadding),
        child: GridView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 15),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10
          ),
          children: [
            Column(
              children: [
                Image.asset('assets/images/user.png',height: 45,
                  color: MyColors.primary,),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Obx(() => Text(loginController.loginName().toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),),
                )
              ],
            ),
            const Text(''),

        loginController.loginToken() != ''
                ?
            InkWell(
              onTap: (){
                MyComponents().showLoaderDialog(context);
                loginController.LogoutValue(context);
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
              },
              child: Column(
                children: [
                  Image.asset('assets/images/logout.png',color: MyColors.primary,height: 45,),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('Log Out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            )
                :
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
              },
              child: Column(
                children: [
                  Image.asset('assets/images/login.png',color: MyColors.primary,height: 30,),
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text('Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),


            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>loginController.loginToken() != '' ? UpdateCustomerScreen(): LoginScreen()));
              },
              child: Column(
                children: [
                  Image.asset('assets/images/1000_F_239277786_ECErblLv6fA7Rx7SUvzso9MQyhWOg8ik-removebg-preview.png',height: 50,),
                  const Text('Edit Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> loginController.loginToken() != '' ? OrderScreen(customerId: loginController.loginCustomerId()) : LoginScreen()));
                  },
                    child: Image.asset('assets/images/ezgif.com-gif-maker__1_-removebg-preview.png', height: 50,)),
                const Text('My Orders',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=> loginController.loginToken() != '' ? const WishlistScreen(): LoginScreen()));
                  },
                    child: Image.asset('assets/images/shopping-cart.png', height: 50,)),
                const Text('Wishlist',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),


            //for stock request
            Column(
              children: [
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> loginController.loginToken() != '' ? const StockRequestScreen(): LoginScreen()));
                    },
                    child: Image.asset('assets/images/team.png', height: 50,)),
                const Text('Stock Request',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            //for change password
            Column(
              children: [
                InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_)=> loginController.loginToken() != '' ? UpdatePasswordScreen(userId: loginController.loginUserId().toString(),userName: loginController.loginName().toString(),): LoginScreen()));
                    },
                    child: Image.asset('assets/images/key.png', height: 50,)),
                const Text('Change Password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),


            ///for order returns
            // Column(
            //   children: [
            //     InkWell(
            //         onTap: (){
            //           //Navigator.push(context, MaterialPageRoute(builder: (_)=> loginController.loginToken() != '' ? NewPasswordScreen(userId: loginController.loginUserId().toString(),): LoginScreen()));
            //         },
            //         child: Image.asset('assets/images/return.png', height: 50,)),
            //     const Text('Order Returns',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ],
            // ),


            //for refer a friend
            GestureDetector(
              onTap: (){
                share();
              },
              child: Column(
                children: [
                  Image.asset('assets/images/refer-a-friend-line-icon-share-sign-vector-22945769-removebg-preview.png', height: 50,),
                  const Text('Refer A Friend',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),



          ],
        ),
      )
    );
  }
}

