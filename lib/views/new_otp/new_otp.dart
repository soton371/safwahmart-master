import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/locals/database/login_db.dart';
import 'package:grocery/locals/model/login_model.dart';
import 'package:grocery/views/checkout/delivery_screen.dart';
import 'package:http/http.dart' as http;


class NewOtpScreen extends StatefulWidget {
  //const NewOtpScreen({Key? key}) : super(key: key);
  dynamic phone, type, password, name, email, getCode;
  NewOtpScreen({this.phone, this.type, this.password, this.name, this.email, this.getCode});

  @override
  State<NewOtpScreen> createState() => _NewOtpScreenState();
}

class _NewOtpScreenState extends State<NewOtpScreen> {

  dynamic inputCode = '';

  Future accountCheck(String mobile)async{
    var url = Uri.parse('$baseUrl/account-check?phone=$mobile');
    var response = await http.get(url);
    var status        = json.decode(response.body)['status'];
    var data          = json.decode(response.body)['data'];
    var dataCustomer  = json.decode(response.body)['data']['customer'];

    switch(status){
      case 1:
        {
          Navigator.pop(context);
          LoginDatabase.instance.deleteLogin(loginController.loginPhone().toString());
          final login = Login(
            token       : '${loginController.loginToken() ?? ''}',
            name        : '${data['name'] ?? ''}',
            email       : '${data['email'] ?? ''}',
            phone       : widget.phone.toString(),
            user_id     : int.parse('${data['id'] ?? 0}'),
            customer_id : int.parse('${dataCustomer['id'] ?? 0}'),
            district_id : int.parse('${dataCustomer['district_id'] ?? 0}'),
            district    : '${dataCustomer['district'] != null ? dataCustomer['district']['name'] : ''}',
            area_id     : int.parse('${dataCustomer['area_id'] ?? 0}'),
            area        : '${dataCustomer['area'] != null ? dataCustomer['area']['name'] : ''}',
            address     : '${dataCustomer['address'] ?? ''}',
            zip_code    : '${dataCustomer['zip_code'] ?? ''}',
          );
          LoginDatabase.instance.createLogin(context, login).then((value) {
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
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeliveryScreen(phone: widget.phone.toString())));
          });
        }
        break;
      case 0:
        {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeliveryScreen(phone: widget.phone.toString())));
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [

            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: ()=>Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back)
              ),
            ),

            const Text(
              '\n\n   Enter the code',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5,),
            const Text(
              "   Please enter the 4-digit otp code send to:",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              "   ${widget.phone}\n",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
              ),
            ),


            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 25),
              child: TextField(
                cursorColor: inputCode.toString().length==4?MyColors.shadow:Colors.redAccent,

                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 20,letterSpacing: 60, fontWeight: FontWeight.bold),
                maxLength: 4,

                decoration: InputDecoration(
                  counter: const Offstage(),
                  hintText: 'Enter 4 Digits otp',
                  fillColor: MyColors.shadow,
                  filled: true,
                  labelStyle: const TextStyle(fontSize: 16),
                  hintStyle: const TextStyle(fontSize: 20,letterSpacing: 1,fontWeight: FontWeight.w100),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: MyColors.shadow,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: MyColors.shadow,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(top: 5,left: 15, bottom: 5),
                ),
                onChanged: (v){
                  setState((){
                    inputCode = v;
                  });
                },
              ),
            ),



            //for submit button
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
                  if(inputCode==widget.getCode){
                    print('success');

                    widget.type == 'register' ?
                    register(context, widget.phone, widget.password, widget.name, widget.email ?? '')
                    :
                    accountCheck(widget.phone.toString());


                  }else{
                    print('something wrong');
                    showDialog(
                        context: context,
                        builder: (_)=>const AlertDialog(
                          alignment: Alignment.center,
                          title: Text('OTP',textAlign: TextAlign.center,),
                          content: Text('Incorrect OTP',textAlign: TextAlign.center,),
                        )
                    );
                  }
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "SUBMIT",
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
        ),
      ),
    );
  }
}

