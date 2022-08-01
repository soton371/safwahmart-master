// import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:grocery/configurations/my_colors.dart';
// import 'package:grocery/configurations/my_components.dart';
// import 'package:grocery/controllers/apis.dart';
// import 'package:grocery/locals/database/login_db.dart';
// import 'package:grocery/locals/model/login_model.dart';
// import 'package:grocery/views/checkout/delivery_screen.dart';
// import 'package:http/http.dart' as http;
//
// class Get_Otp extends StatefulWidget {
//   var phone, type, password, name, email;
//
//   Get_Otp({this.phone, this.type, this.password, this.name, this.email});
//
//   @override
//   _Get_OtpState createState() => _Get_OtpState();
// }
//
// class _Get_OtpState extends State<Get_Otp> {
//   final TextEditingController _pinOtpCodeController = TextEditingController();
//   String? verificationCode;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     verifyPhoneNumber();
//   }
//
//   Future accountCheck(String mobile)async{
//     debugPrint('Mobile No: $mobile');
//     var url = Uri.parse('$baseUrl/account-check?phone=$mobile');
//     var response = await http.get(url);
//     var status        = json.decode(response.body)['status'];
//     var data          = json.decode(response.body)['data'];
//     var dataCustomer  = json.decode(response.body)['data']['customer'];
//
//     switch(status){
//       case 1:
//         {
//           Navigator.pop(context);
//           LoginDatabase.instance.deleteLogin(loginController.loginPhone().toString());
//           final login = Login(
//             token       : '${loginController.loginToken() ?? ''}',
//             name        : '${data['name'] ?? ''}',
//             email       : '${data['email'] ?? ''}',
//             phone       : widget.phone.toString().replaceAll('+8800', '+880'),
//             user_id     : int.parse('${data['id'] ?? 0}'),
//             customer_id : int.parse('${dataCustomer['id'] ?? 0}'),
//             district_id : int.parse('${dataCustomer['district_id'] ?? 0}'),
//             district    : '${dataCustomer['district'] != null ? dataCustomer['district']['name'] : ''}',
//             area_id     : int.parse('${dataCustomer['area_id'] ?? 0}'),
//             area        : '${dataCustomer['area'] != null ? dataCustomer['area']['name'] : ''}',
//             address     : '${dataCustomer['address'] ?? ''}',
//             zip_code    : '${dataCustomer['zip_code'] ?? ''}',
//           );
//           LoginDatabase.instance.createLogin(context, login).then((value) {
//             loginController.refreshLogin();
//             loginController.loginToken();
//             loginController.loginName();
//             loginController.loginEmail();
//             loginController.loginPhone();
//             loginController.loginDistrictId();
//             loginController.loginDistrict();
//             loginController.loginAreaId();
//             loginController.loginArea();
//             loginController.loginAddress();
//             loginController.loginZipCode();
//             loginController.loginCustomerId();
//             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeliveryScreen(phone: widget.phone.toString().replaceAll('+8800', '+880'))));
//           });
//         }
//         break;
//       case 0:
//         {
//           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeliveryScreen(phone: widget.phone.toString().replaceAll('+8800', '+880'),)));
//         }
//     }
//   }
//
//   verifyPhoneNumber() async{
//     await FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: widget.phone.toString().replaceAll('+8800', '+880'),
//       verificationCompleted: (PhoneAuthCredential credential) async
//       {
//         await FirebaseAuth.instance.signInWithCredential(credential).then((value){
//           if(value.user != null){
//             widget.type == 'register' ?
//             register(context,widget.phone, widget.password, widget.name, widget.email)
//                 :
//             accountCheck(widget.phone.toString().replaceAll('+880', ''));
//           }
//         });
//       },
//       verificationFailed: (FirebaseAuthException e){
//         ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(e.message.toString()),
//               duration: const Duration(seconds: 15),
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
//               "   ${widget.phone.toString().replaceAll('+8800', '+880')}\n",
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold
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
//                         color: MyColors.shadow,
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
//                         widget.type == 'register' ?
//                         register(context, widget.phone, widget.password, widget.name, widget.email ?? '')
//                             :
//                         accountCheck(widget.phone.toString().replaceAll('+880', ''));
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