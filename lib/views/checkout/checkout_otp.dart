import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/views/account/getx_auth/login_scr.dart';
import 'package:grocery/views/new_otp/new_otp.dart';
import 'package:http/http.dart' as http;

class CheckoutOtp extends StatefulWidget {


  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<CheckoutOtp> {

  // var _mobile = TextEditingController();
  dynamic phone;

  //for new otp
  dynamic myCode= '1122';

  void sendOtp() async{
    var url = Uri.parse('http://smpp.ajuratech.com:7788/sendtext?apikey=f2c0ed02a8a3ef97&secretkey=07a88429&callerID=SENDER_ID&toUser=$phone&messageContent=Your 4-Digit Verification OTP is $myCode');

    var response = await http.get(url);

    var text = json.decode(response.body)['Text'];


    switch(text){
      case 'ACCEPTD':{
        print("object: ACCEPTD");
        print("phone: $phone");
        Navigator.push(context, MaterialPageRoute(builder: (_)=>NewOtpScreen(phone: phone,getCode: myCode,type: 'checkout_otp',)));
      }
      break;
      default:
        {
          print("phone: $phone");
          print('object: rejected');
        }
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),

        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: ()=>Navigator.pop(context),
                icon: const Icon(Icons.close)
            ),
          ),
          //Button
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("\nWhat's your phone number?",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28
              ),
            ),
          ),
          const SizedBox(height: 5,),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("We'll send a code to your phone number"),
          ),

          const SizedBox(
            height: 50,
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
            child: Row(
              children: [
                // Image.asset('assets/images/bdflag.png',height: 20,),
                // const Text('  +880'),
                Expanded(
                  child: TextFormField(
                    // controller: _mobile,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: "Enter your phone number",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    autofocus: false,
                    onChanged: (value) {
                      setState((){
                        phone = value;
                      });

                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30,),
          //for switch account or register
          InkWell(
            onTap: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> LoginScreen())),
            child: Text('Switch Account or Register',textAlign: TextAlign.center,style: TextStyle(color: MyColors.primary),),
          )
        ],
      ),
      bottomSheet: Container(
        height: 70,
        padding: const EdgeInsets.all(15),
        child: Container(
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
               if(phone.toString().length == 11){

                 //for new otp
                 int randomNumber = Random().nextInt(9000) + 1000;
                 setState((){
                   myCode = randomNumber.toString();
                 });

                 sendOtp();
                 //Navigator.push(context, MaterialPageRoute(builder: (_)=>NewOtpScreen(phone: phone,)));
                //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Get_Otp(phone: '+880${_mobile.text}',)),);
               }else{
                 MyComponents().wrongSnackBar(context, 'Please enter 11 digits number');
               }
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                 Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Continue as a new guest",
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
      ),
    );
  }
}