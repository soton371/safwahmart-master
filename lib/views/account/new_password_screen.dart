import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';

class NewPasswordScreen extends StatefulWidget {
  // const NewPasswordScreen({Key? key}) : super(key: key);
  var userId;
  NewPasswordScreen({this.userId});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {

  dynamic newPassword, confirmPassword;
  bool hidePassword = true;
  bool newHidePassword = true;


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
          const Center(
              child: Image(
                image: AssetImage(
                    "assets/images/applogo.png"),
                width: 180,
              )),
          Container(
            margin: const EdgeInsets.only(left: 48, right: 48, top: 20),
            child: const Text(
              "Enter your new password to access your account",
              softWrap: true,
              textAlign: TextAlign.center,
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
                      newPassword = value;
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
                      confirmPassword = value;
                    },
                  )
                ],
              ),
            ),
          ),

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
                print('new: $newPassword');
                print('confirm: $confirmPassword');
                print('userId: ${widget.userId}');

                if (newPassword != null && confirmPassword != null){

                  //login(context, phone.toString(), password.toString());
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
