import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:http/http.dart' as http;


class UpdatePasswordScreen extends StatefulWidget {
  //const UpdatePasswordScreen({Key? key}) : super(key: key);
  dynamic userId, userName;
  UpdatePasswordScreen({this.userId, this.userName});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {

  dynamic newPassword, confirmPassword, currentPassword;
  bool hidePassword = true;
  bool newHidePassword = true;
  bool currentHidePassword = true;

  checkCurrentPassword()async{

    MyComponents().showLoaderDialog(context);

    var url = Uri.parse('$baseUrl/check-current-password?user_id=${widget.userId}&current_password=$currentPassword');
    var response = await http.get(url);
    
    var status = json.decode(response.body)['status'];
    var message = json.decode(response.body)['message'];

    switch(status){
      case 1:{
        Navigator.pop(context);
        if (newPassword != null && confirmPassword != null){
          if(newPassword==confirmPassword){
            //hit api
            MyComponents().showLoaderDialog(context);
            updatePassword(context, widget.userId.toString(), confirmPassword.toString());

          }else{
            MyComponents().wrongSnackBar(context, 'Confirm password not match');
          }
        }else{

          MyComponents().wrongSnackBar(context, 'Please input all fields');

        }
      }
      break;
      default:{
        Navigator.pop(context);
        MyComponents().wrongSnackBar(context, '$message');
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
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: ()=>Navigator.pop(context),
                icon: const Icon(Icons.arrow_back)
            ),
          ),
          const SizedBox(height: 50,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("\nUpdate Password",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28
                ),
              ),
            ),
          ),
          const SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("${widget.userName} enter your new password to access your account."),
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 15, right: 15, top: 30),
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
                  //for current password
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "current password",
                        hintStyle: const TextStyle(fontSize: 14),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(15),
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              currentHidePassword = !currentHidePassword;
                            });
                          },
                          child: currentHidePassword
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
                    obscureText: currentHidePassword,
                    onChanged: (value) {
                      setState((){
                        currentPassword = value;
                      });

                    },
                  ),
                  Divider(
                    color: MyColors.shadow,
                    height: 0.5,
                  ),


                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "new password",
                        hintStyle: const TextStyle(fontSize: 14),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.all(15),
                        suffix: InkWell(
                          onTap: () {
                            setState(() {
                              newHidePassword = !newHidePassword;
                            });
                          },
                          child: newHidePassword
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
                    obscureText: newHidePassword,
                    onChanged: (value) {
                      setState((){
                        newPassword = value;
                      });

                    },
                  ),
                  Divider(
                    color: MyColors.shadow,
                    height: 0.5,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "confirm password",
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
                      setState((){
                        confirmPassword = value;
                      });

                    },
                  )
                ],
              ),
            ),
          ),


          const SizedBox(height: 20,),
          //for button

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


                checkCurrentPassword();
                // if (newPassword != null && confirmPassword != null){
                //
                //   //login(context, phone.toString(), password.toString());
                //   if(newPassword==confirmPassword){
                //     //hit api
                //     MyComponents().showLoaderDialog(context);
                //     updatePassword(context, widget.userId.toString(), confirmPassword.toString());
                //
                //   }else{
                //     MyComponents().wrongSnackBar(context, 'Confirm password not match');
                //   }
                // }else{
                //
                //   MyComponents().wrongSnackBar(context, 'Please input all fields');
                //
                // }
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: <Widget>[
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "CONTINUE",
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
    );
  }
}
