import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/views/account/reset_otp.dart';
import 'package:grocery/views/new_otp/new_reset_otp.dart';
import 'package:http/http.dart' as http;


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  dynamic phone;
  dynamic userId;


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
        Navigator.push(context, MaterialPageRoute(builder: (_)=> NewResetOtpScreen(phone: phone,userId: userId,getCode: myCode,)));
      }
      break;
      default:
        {
          print("phone: $phone");
          print('object: rejected');
        }
    }

  }


  //for check account
  Future accountCheck(String mobile)async{
    var url = Uri.parse('$baseUrl/account-check?phone=$mobile');
    var response = await http.get(url);
    var status = json.decode(response.body)['status'];

    switch(status){
      case 1:
        {
          setState((){
            userId = json.decode(response.body)['data']['id'];
          });

          print("userId: $userId");
          sendOtp();
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ResetOtpScreen(phone: '+88${phone.text}',userId: '$userId',)),);
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => Get_Otp(phone: '+880${_mobile.text}',)),);

          //MyComponents().wrongSnackBar(context, json.decode(response.body)['data']['id'].toString());
        }
        break;
      case 0:
        {
          MyComponents().wrongSnackBar(context, json.decode(response.body)['message'].toString());
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
            child: Text("\nReset Password",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28
              ),
            ),
          ),
          const SizedBox(height: 5,),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text("Please enter the account that you want to reset the password."),
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

                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
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
                        phone=value;
                      });

                    },
                  ),
                ),
              ],
            ),
          ),

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


              print("phone: $phone");

              // if(_mobile.text.length == 14){

              //for new otp
              int randomNumber = Random().nextInt(9000) + 1000;
              setState((){
              myCode = randomNumber.toString();
              });

              accountCheck('$phone');


              // }else{
              //   MyComponents().wrongSnackBar(context, 'Please enter 11 digit numbers');
              // }
            },
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: <Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Continue",
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
