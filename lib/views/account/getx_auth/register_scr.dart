import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/views/account/getx_auth/login_scr.dart';
import 'package:grocery/views/new_otp/new_otp.dart';
import 'package:http/http.dart' as http;


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  dynamic phone, name, email, password, confirmPassword;
  bool hidePassword1 = true;
  bool hidePassword2 = true;

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
        Navigator.push(context, MaterialPageRoute(builder: (_)=>NewOtpScreen(phone: phone,type: 'register', password: password, name: name, email: email,getCode: myCode,)));
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
          Navigator.pop(context);
          MyComponents().wrongSnackBar(context, json.decode(response.body)['message'].toString());
        }
        break;
      case 0:
        {
          sendOtp();
          // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Get_Otp(phone: '+88${phone.replaceAll('+880', '0')}',
          //   type: 'register', password: password, name: name, email: email,)),);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: ()=>Navigator.pop(context),
                icon: const Icon(Icons.arrow_back)
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
              child: Image(
                image:
                AssetImage("assets/images/applogo.png"),
                width: 180,
              )),

          //tagline
          const Text('\nJoin Now! Setup A New Account In A Minute',
            textAlign: TextAlign.center,
          ),

          //input section
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 50),
            child: Container(
              decoration: BoxDecoration(
                  color: MyColors.background,
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 8.0,
                        color: MyColors.shadow,
                        offset: const Offset(0, 3)),
                  ]),
              child: Column(
                children: [
                  TextFormField(
                    autofillHints: const [AutofillHints.name],
                    decoration: const InputDecoration(
                      hintText: "Name*",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    autofocus: false,
                    onChanged: (value) {
                      name=value;
                    },
                  ),
                  Divider(
                    color: MyColors.shadow,
                    height: 0.5,
                  ),
                  TextFormField(
                    autofillHints: const [AutofillHints.telephoneNumber],
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: "Phone*",
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
                    },
                  ),
                  Divider(
                    color: MyColors.shadow,
                    height: 0.5,
                  ),
                  TextFormField(
                    autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.all(15),
                    ),
                    autofocus: false,
                    onChanged: (value) {
                      email = value;
                    },
                  ),
                  Divider(
                    color: MyColors.shadow,
                    height: 0.5,
                  ),
                  TextFormField(
                    obscureText: hidePassword1,
                    decoration: InputDecoration(
                      hintText: "Password*",
                      hintStyle: const TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(15),
                      suffix: InkWell(
                        onTap: (){
                          setState((){
                            hidePassword1 = !hidePassword1;
                          });
                        },
                        child: hidePassword1
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
                      ),
                    ),
                    autofocus: false,
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  Divider(
                    color: MyColors.shadow,
                    height: 0.5,
                  ),
                  TextFormField(
                    obscureText: hidePassword2,
                    decoration: InputDecoration(
                      hintText: "Confirm password*",
                      hintStyle: const TextStyle(fontSize: 14),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.all(15),
                      suffix: InkWell(
                        onTap: (){
                          setState((){
                            hidePassword2 = !hidePassword2;
                          });
                        },
                        child: hidePassword2
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
                      ),
                    ),
                    autofocus: false,
                    onChanged: (value) {
                      confirmPassword = value;
                    },
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 40, bottom: 15),
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
                if(name != '' && name != null
                    && phone.length == 11 && phone != null
                    && password != '' && password != null
                    && password == confirmPassword){

                  //for new otp
                  int randomNumber = Random().nextInt(9000) + 1000;
                  setState((){
                    myCode = randomNumber.toString();
                  });
                  // print('phone: $phone');
                  // print('myCode: $myCode');
                  MyComponents().showLoaderDialog(context);
                  accountCheck(phone);
                }
                else if (name == '' || name == null){
                  MyComponents().wrongSnackBar(context, 'Please Enter Name');
                }
                else if (phone == '' || phone == null){
                  MyComponents().wrongSnackBar(context, 'Please Enter Phone Number');
                }
                else if (password == '' || password == null){
                  MyComponents().wrongSnackBar(context, 'Please Enter Password');
                }
                else if (password != confirmPassword){
                  MyComponents().wrongSnackBar(context, 'Please Enter Same Password');
                }
                else if (phone.length != 11){
                  MyComponents().wrongSnackBar(context, 'Please Enter 11 Digit Number');
                }

              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: <Widget>[
                   Align(
                    alignment: Alignment.center,
                    child: Text(
                      "REGISTER",
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

          const SizedBox(
            height: 20,
          ),
          //register new account
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?"),
              TextButton(
                  onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>  LoginScreen())),
                  child: const Text('Login'))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
