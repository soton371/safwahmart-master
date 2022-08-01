import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/views/account/new_password_screen.dart';

class NewResetOtpScreen extends StatefulWidget {
  // const NewResetOtpScreen({Key? key}) : super(key: key);
  dynamic phone, userId, getCode;
  NewResetOtpScreen({this.phone,this.userId, this.getCode});

  @override
  State<NewResetOtpScreen> createState() => _NewResetOtpScreenState();
}

class _NewResetOtpScreenState extends State<NewResetOtpScreen> {

  dynamic inputCode = '';

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
                    print('user id: ${widget.userId}');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewPasswordScreen(userId: widget.userId,)));

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
