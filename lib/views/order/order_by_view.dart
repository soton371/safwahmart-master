// import 'package:flutter/material.dart';
// import 'package:grocery/configurations/my_colors.dart';
//
//
// class OrderByViewScreen extends StatefulWidget {
//   // const OrderByViewScreen({Key? key}) : super(key: key);
//   dynamic orderNo,orderDetails,subtotal,totalVatAmount,shippingCost,totalDiscountAmount,grandTotal, orderDate, orderCustomerInfo;
//   OrderByViewScreen({this.orderNo,this.orderDetails,this.subtotal,this.totalVatAmount,this.shippingCost,this.totalDiscountAmount,
//     this.grandTotal, this.orderDate, this.orderCustomerInfo});
//
//
//   @override
//   State<OrderByViewScreen> createState() => _OrderByViewScreenState();
// }
//
// class _OrderByViewScreenState extends State<OrderByViewScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: MyColors.background,
//         titleSpacing: 0,
//         title: Text('Orders#${widget.orderNo}',style: TextStyle(color: MyColors.primary,fontWeight: FontWeight.normal),),
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: MyColors.primary,
//           ),
//         ),
//
//       ),
//       body: ListView(
//         physics: const BouncingScrollPhysics(),
//         children: [
//           Table(
//             columnWidths: const{
//               0: FlexColumnWidth(4),
//               1: FlexColumnWidth(2),
//               2: FlexColumnWidth(1.5),
//               3: FlexColumnWidth(1.5),
//               4: FlexColumnWidth(1.5),
//             },
//             border: TableBorder.all(width: 0.5),
//             children: const [
//               TableRow(children: [
//                 Text('\nItem\n', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
//                 Text('\nUnit', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
//                 Text('\nQty', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
//                 Text('\nRate', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
//                 Text('\nTotal', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600)),
//               ]),
//             ],
//           ),
//           ListView.builder(
//             itemCount: widget.orderDetails.length,
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             physics: const ScrollPhysics(),
//             itemBuilder: (BuildContext context, index) {
//
//               var detailData = widget.orderDetails[index];
//
//               // var amount = double.parse(detailData['total_amount']);
//               var amount = double.parse(detailData['sale_price']) * double.parse(detailData['quantity']);
//
//               return Table(
//                 columnWidths: const{
//                   0: FlexColumnWidth(4),
//                   1: FlexColumnWidth(2),
//                   2: FlexColumnWidth(1.5),
//                   3: FlexColumnWidth(1.5),
//                   4: FlexColumnWidth(1.5),
//                 },
//                 border: TableBorder.all(width: 0.3),
//                 children: [
//                   TableRow(children: [
//
//                     //Item
//                     TextView(detailData['product']['name'] ??  ''),
//
//                     //Unit
//                     TextView(detailData['measurement_title'] != '0' && detailData['measurement_title'] != null && detailData['measurement_title'] != '' ? detailData['measurement_title']
//                         :
//                     '${detailData['product']['sub_text']} ${detailData['product']['unit_measure']['name']}'),
//
//                     //Quantity
//                     TextView(detailData['quantity'].toString().replaceAll('.00', '')),
//
//                     //Action
//                     TextView(detailData['sale_price'].toString().replaceAll('.00', '.0')),
//
//                     TextView(amount.toString().replaceAll('.000000', '')),
//
//                   ]),
//                 ],
//               );
//             },
//           ),
//
//           Padding(
//             padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Subtotal: '),
//                 Text(widget.subtotal)
//               ],
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Vat: '),
//                 Text(widget.totalVatAmount)
//               ],
//             ),
//           ),
//
//           const Divider(),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Shipping Cost: '),
//                 Text(widget.shippingCost)
//               ],
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Discount: '),
//                 Text('- ${widget.totalDiscountAmount}')
//               ],
//             ),
//           ),
//
//           const Divider(),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Total Payable: '),
//                 Text(widget.grandTotal)
//               ],
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: const [
//                 Text('Paid Amount: '),
//                 Text('0.00 ')
//               ],
//             ),
//           ),
//
//           const Divider(),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text('Cash To Collect: '),
//                 Text(widget.grandTotal)
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   TextView(text){
//     return Padding(
//       padding: const EdgeInsets.only(top: 8, bottom: 8),
//       child: Text(text.toString().replaceAll('Status.', '').replaceAll('00:00:00.000', ''), textAlign: TextAlign.center,),
//     );
//   }
// }
