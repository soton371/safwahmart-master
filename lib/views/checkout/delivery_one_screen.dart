// import 'package:flutter/material.dart';
// import 'package:grocery/configurations/my_colors.dart';
// import 'package:grocery/configurations/my_sizes.dart';
// import 'package:grocery/views/checkout/delivery_screen.dart';
// import 'package:grocery/widgets/my_textformfield.dart';
//
// class DeliveryOneScreen extends StatefulWidget {
//   const DeliveryOneScreen({Key? key}) : super(key: key);
//
//   @override
//   _DeliveryOneScreenState createState() => _DeliveryOneScreenState();
// }
//
// class _DeliveryOneScreenState extends State<DeliveryOneScreen> {
//
//   bool selectCheck = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: Icon(
//               Icons.arrow_back,
//               color: MyColors.primary,
//             )),
//         titleSpacing: 0,
//         title: Text(
//           'Order delivery',
//           style: TextStyle(color: MyColors.primary,fontSize: 18),
//         ),
//       ),
//       body: ListView(
//         physics: BouncingScrollPhysics(),
//         padding: EdgeInsets.all(MySizes.bodyPadding),
//         children: [
//           //for name
//           MyTextFormField(myHint: 'Full Name',myIcon: Icons.person_outline,),
//           //for phone
//           MyTextFormField(myHint: 'Phone Number',myIcon: Icons.phone_iphone_outlined,),
//           //for Address
//           MyTextFormField(myHint: 'Address',myIcon: Icons.location_on_outlined,),
//           //for city
//           MyTextFormField(myHint: 'City',myIcon: Icons.location_city_outlined,),
//           //for country
//           MyTextFormField(myHint: 'Country',myIcon: Icons.vpn_lock_outlined,),
//           //for order note
//           MyTextFormField(myHint: 'Order Note',myIcon: Icons.edit,),
//           //for Ship To Different Address!
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Checkbox(
//                   value: selectCheck,
//                   onChanged: (v)=>setState(() {
//                     selectCheck=v!;
//                   })
//               ),
//               Text('Ship To Different Address!',style: TextStyle(
//                 color: MyColors.inactive
//               ),),
//             ],
//           ),
//           selectCheck?SizedBox(
//             child: Column(
//               children: [
//                 //for name
//                 MyTextFormField(myHint: 'Full Name',myIcon: Icons.person_outline,),
//                 //for phone
//                 MyTextFormField(myHint: 'Phone Number',myIcon: Icons.phone_iphone_outlined,),
//                 //for Address
//                 MyTextFormField(myHint: 'Address',myIcon: Icons.location_on_outlined,),
//                 //for city
//                 MyTextFormField(myHint: 'City',myIcon: Icons.location_city_outlined,),
//                 //for country
//                 MyTextFormField(myHint: 'Country',myIcon: Icons.vpn_lock_outlined,),
//                 //for order note
//                 MyTextFormField(myHint: 'Order Note',myIcon: Icons.edit,),
//               ],
//             ),
//           ):SizedBox()
//         ],
//       ),
//       floatingActionButton: Container(
//         padding: const EdgeInsets.only(right: 10),
//         margin: const EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 3,
//             ),
//           ],
//         ),
//         height: 50,
//         child: Row(
//           children: [
//             IconButton(
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       behavior: SnackBarBehavior.floating,
//                       backgroundColor: Colors.white,
//                       margin: const EdgeInsets.only(
//                         left: 10,
//                         right: 10,
//                       ),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10)),
//                       content: const Text(
//                         'SubTotal: ৳250 & Delivery charge: ৳50',
//                         style: TextStyle(
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//                 icon: const Icon(Icons.info_outline)),
//             const Text(
//               "Total: ৳300",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               onPressed: (){
//                 Navigator.push(context, MaterialPageRoute(builder: (_)=>DeliveryScreen()));
//               },
//               child: const Text("Continue"),
//               style: ElevatedButton.styleFrom(
//                   shape: const StadiumBorder(), elevation: 0),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
//
