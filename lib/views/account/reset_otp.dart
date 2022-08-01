// import 'package:flutter/material.dart';
// import 'package:grocery/configurations/my_colors.dart';
// import 'package:grocery/configurations/my_components.dart';
// import 'package:grocery/controllers/apis.dart';
// import 'package:grocery/views/account/new_password_screen.dart';
// import 'package:grocery/views/checkout/delivery_screen.dart';
// import 'package:grocery/views/front_screen.dart';
//
// class ResetOtpScreen extends StatefulWidget {
//   var phone, userId;
//
//   ResetOtpScreen({this.phone, this.userId});
//
//   @override
//   _ResetOtpScreenState createState() => _ResetOtpScreenState();
// }
//
// class _ResetOtpScreenState extends State<ResetOtpScreen> {
//   final TextEditingController _pinOtpCodeController = TextEditingController();
//   String? verificationCode;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     veryfyPhoneNumber();
//     print("object: ${widget.phone}");
//   }
//
//   veryfyPhoneNumber() async{
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: widget.phone.toString().replaceAll('+8800', '+880'),
//       verificationCompleted: (PhoneAuthCredential credential) async
//       {
//         await FirebaseAuth.instance.signInWithCredential(credential).then((value){
//           if(value.user != null){
//
//             //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeliveryScreen(phone: widget.phone.toString().replaceAll('+8800', '+880'),)));
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewPasswordScreen(userId: widget.userId,)));
//           }
//         });
//       },
//       verificationFailed: (FirebaseAuthException e){
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(e.message.toString()),
//               duration: const Duration(seconds: 2),
//             )
//         );
//       },
//       codeSent: (String vID,int? recenToken){
//         assert(vID != null);
//         setState(() {
//           verificationCode = vID;
//         });
//       },
//       codeAutoRetrievalTimeout: (String vID){
//         setState(() {
//           verificationCode = vID;
//         });
//       },
//       timeout: const Duration(seconds: 90),
//     );
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: ListView(
//           shrinkWrap: true,
//           children: [
//
//             Align(
//               alignment: Alignment.centerLeft,
//               child: IconButton(
//                   onPressed: ()=>Navigator.pop(context),
//                   icon: const Icon(Icons.arrow_back)
//               ),
//             ),
//
//             const Text(
//               '\n\n   Enter the code',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 5,),
//             const Text(
//               "   Please enter the 6-digit otp code send to:",
//               style: TextStyle(
//                 fontSize: 16,
//               ),
//             ),
//             Text(
//               "   ${widget.phone}\n",
//               style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold
//               ),
//             ),
//
//
//             Container(
//               margin: const EdgeInsets.only(left: 15, right: 15, top: 25),
//               child: TextField(
//                 controller: _pinOtpCodeController,
//                 keyboardType: TextInputType.phone,
//                 style: const TextStyle(fontSize: 20,letterSpacing: 36, fontWeight: FontWeight.bold),
//                 maxLength: 6,
//
//                 decoration: InputDecoration(
//                   counter: const Offstage(),
//                   hintText: 'Enter 6 Digits otp',
//                   fillColor: MyColors.shadow,
//                   filled: true,
//                   labelStyle: const TextStyle(fontSize: 16),
//                   hintStyle: const TextStyle(fontSize: 20,letterSpacing: 1,fontWeight: FontWeight.w100),
//
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(
//                       color: MyColors.shadow,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide(
//                       color: MyColors.shadow,
//                     ),
//                   ),
//                   contentPadding: const EdgeInsets.only(top: 5,left: 15, bottom: 5),
//                 ),
//                 onSubmitted: (pin) async{
//                   try{
//                     await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.
//                     credential(verificationId: verificationCode!, smsCode: pin))
//                         .then((value) {
//                       if(value.user != null){
//                         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewPasswordScreen(userId: widget.userId,)));
//
//                         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeliveryScreen(phone: widget.phone.toString().replaceAll('+8800', '+880'),type: 'otp',)));
//                       }
//                     });
//                   }
//                   catch(e)
//                   {
//                     MyComponents().wrongSnackBar(context, 'INVALID OTP');
//                   }
//                 },
//               ),
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }