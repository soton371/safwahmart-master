import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/views/account/forgot_password.dart';
import 'package:grocery/views/account/getx_auth/register_scr.dart';
import 'package:get/get.dart';
import 'package:grocery/views/checkout/checkout_otp.dart';
import 'package:grocery/views/new_otp/new_otp.dart';


class LoginScreen extends StatefulWidget {

  var where;
  LoginScreen({this.where});
  //const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // var loginController = Get.put(LoginController());
  dynamic phone, password, phoneGuest;
  bool hidePassword = true;

  ///for new otp
  dynamic myCode= '1122';
  void sendOtp() async{
    var url = Uri.parse('http://smpp.ajuratech.com:7788/sendtext?apikey=f2c0ed02a8a3ef97&secretkey=07a88429&callerID=SENDER_ID&toUser=$phone&messageContent=Your 4-Digit Verification OTP is $myCode');

    var response = await http.get(url);

    var text = json.decode(response.body)['Text'];


    switch(text){
      case 'ACCEPTD':{
        print("object: ACCEPTD");
        print("phone: $phoneGuest");
        Navigator.push(context, MaterialPageRoute(builder: (_)=>NewOtpScreen(phone: phoneGuest,getCode: myCode,type: 'checkout_otp',)));
      }
      break;
      default:
        {
          print("phone: $phoneGuest");
          print('object: rejected');
        }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        keyboardDismissBehavior:
        ScrollViewKeyboardDismissBehavior.onDrag,
        children: <Widget>[
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: IconButton(
          //       onPressed: ()=>Navigator.pop(context),
          //       icon: const Icon(Icons.arrow_back)
          //   ),
          // ),

          ///App logo
          const SizedBox(height: 30,),
          const Center(
              child: Image(
                image: AssetImage(
                    "assets/images/applogo.png"),
                width: 180,
              )),

          ///for text
          Container(
            margin: const EdgeInsets.only(left: 48, right: 48, top: 20),
            child: const Text(
              "If you already our customer login here.",
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),

          ///for phone no and password
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 30),
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
                    hintText: "Phone Number/Email",
                    hintStyle: TextStyle(fontSize: 14),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                  ),
                  autofocus: false,
                  onChanged: (value) {
                    phone = value;
                    // loginController.phone = value;
                  },
                ),
                Divider(
                  color: MyColors.shadow,
                  height: 0.5,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: (){
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()));
                    },
                      child: const Text(' For New Customer Register Now  ')),
                ),
                Divider(
                  color: MyColors.shadow,
                  height: 0.5,
                ),
                TextFormField(
                  //controller: controller.passwordController,
                  decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(15),
                      suffix: InkWell(
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        child: hidePassword
                            ? Icon(
                          Icons.visibility_off_outlined,
                          size: 15,
                          color: MyColors.inactive,
                        )
                            : Icon(
                          Icons.visibility_outlined,
                          size: 15,
                          color: MyColors.inactive,
                        ),
                      )
                  ),
                  autofocus: false,
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.sentences,
                  obscureText: hidePassword,
                  onChanged: (value) {
                    password = value;
                    // loginController.password = value;
                  },
                )
              ],
            ),
          ),


          ///for forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>const ForgotPasswordScreen())),
              child: Text(
                "Forget Password?",
                style: TextStyle(color: MyColors.inactive),
              ),
            ),
          ),


          ///for button
          Container(
            margin: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(48)),
              boxShadow: [
                BoxShadow(
                  color: MyColors.primary.withAlpha(80),
                  blurRadius: 5,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: MyColors.primary),
              onPressed: () {
                if (phone != null && password != null && phone != '' && password != ''){

                  MyComponents().showLoaderDialog(context);
                  //loginController.login(context);
                  login(context, phone.toString().replaceAll('+880', '0'), password);
                }else{

                  MyComponents().wrongSnackBar(context, 'Please input all fields');

                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: <Widget>[
                   Align(
                    alignment: Alignment.center,
                    child: Text(
                      "LOGIN",
                        style: TextStyle(color: MyColors.buttonTextColor),
                    ),
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

          ///continue as a guest
          widget.where=='CartScreen'?

              Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    child: Row(
                      children: [
                        const Expanded(child: Divider(thickness: 2,)),
                        Text('   OR   ',
                          style: TextStyle(
                              color: MyColors.inactive
                          ),
                        ),
                        const Expanded(child: Divider(thickness: 2,)),
                      ],
                    ),
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: const [
                  //     Text("Continue as a guest"),
                  //   ],
                  // ),

                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  //   decoration: BoxDecoration(
                  //       color: MyColors.background,
                  //       borderRadius:
                  //       const BorderRadius.all(Radius.circular(15)),
                  //       boxShadow: [
                  //         BoxShadow(
                  //             blurRadius: 8.0,
                  //             color: MyColors.shadow,
                  //             offset: const Offset(0, 3)),
                  //       ]),
                  //   child: Expanded(
                  //     child: TextFormField(
                  //       // controller: _mobile,
                  //       keyboardType: TextInputType.phone,
                  //       maxLength: 11,
                  //       decoration: const InputDecoration(
                  //         counterText: '',
                  //         hintText: "Enter your phone number",
                  //         hintStyle: TextStyle(fontSize: 14),
                  //         border: InputBorder.none,
                  //         enabledBorder: InputBorder.none,
                  //         focusedBorder: InputBorder.none,
                  //         isDense: true,
                  //         contentPadding: EdgeInsets.all(15),
                  //       ),
                  //       autofocus: false,
                  //       onChanged: (value) {
                  //         setState((){
                  //           phoneGuest = value;
                  //         });
                  //
                  //       },
                  //     ),
                  //   ),
                  // ),

                  Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(48)),
                      boxShadow: [
                        BoxShadow(
                          color: MyColors.primary.withAlpha(80),
                          blurRadius: 5,
                          offset: const Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: MyColors.primary),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => CheckoutOtp()));
                        // if(phoneGuest.toString().length == 11){
                        //
                        //   //for new otp
                        //   int randomNumber = Random().nextInt(9000) + 1000;
                        //   setState((){
                        //     myCode = randomNumber.toString();
                        //   });
                        //
                        //   sendOtp();
                        // }else{
                        //   MyComponents().wrongSnackBar(context, 'Please enter 11 digits number');
                        // }
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "CONTINUE AS A NEW GUEST",
                              style: TextStyle(color: MyColors.buttonTextColor),
                            ),
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
                ],
              ) : Container(),


          ///register new account
          // Padding(
          //   padding: const EdgeInsets.only(top: 20, bottom: 10),
          //   child: Row(
          //     children: [
          //       const Expanded(child: Divider(thickness: 2,)),
          //       Text('   OR   ',
          //         style: TextStyle(
          //             color: MyColors.inactive
          //         ),
          //       ),
          //       const Expanded(child: Divider(thickness: 2,)),
          //     ],
          //   ),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: const [
          //     Text("For new customer"),
          //     // TextButton(
          //     //     onPressed: () => Navigator.pushReplacement(
          //     //         context,
          //     //         MaterialPageRoute(
          //     //             builder: (_) => const RegisterScreen())),
          //     //     child: const Text('Register Now'))
          //   ],
          // ),
          // Container(
          //   margin: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
          //   decoration: BoxDecoration(
          //     borderRadius: const BorderRadius.all(Radius.circular(48)),
          //     boxShadow: [
          //       BoxShadow(
          //         color: MyColors.primary.withAlpha(80),
          //         blurRadius: 5,
          //         offset: const Offset(0, 5), // changes position of shadow
          //       ),
          //     ],
          //   ),
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(primary: MyColors.primary),
          //     onPressed: () {
          //       Navigator.pushReplacement(
          //           context,
          //           MaterialPageRoute(
          //               builder: (_) => const RegisterScreen()));
          //     },
          //     child: Stack(
          //       clipBehavior: Clip.none,
          //       alignment: Alignment.center,
          //       children: <Widget>[
          //         Align(
          //           alignment: Alignment.center,
          //           child: Text(
          //             "REGISTER NOW",
          //             style: TextStyle(color: MyColors.buttonTextColor),
          //           ),
          //         ),
          //         Positioned(
          //           right: 16,
          //           child: ClipOval(
          //             child: Container(
          //               color: MyColors.secondary,
          //               // button color
          //               child: SizedBox(
          //                   width: 25,
          //                   height: 25,
          //                   child: Icon(
          //                     Icons.arrow_forward,
          //                     color: MyColors.background,
          //                     size: 15,
          //                   )),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),


        ],
      ),
    );
  }
}
