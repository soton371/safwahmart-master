import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/views/cart/CartScreen.dart';
import 'package:grocery/views/checkout/delivery_screen.dart';
import 'package:grocery/views/order/order_by_view.dart';
import 'package:grocery/views/order_returns/order_returns.dart';
import 'package:grocery/INVOICE/api/pdf_api.dart';
import 'package:grocery/INVOICE/api/pdf_invoice_api.dart';
import 'package:grocery/INVOICE/model/invoice.dart';
import 'package:grocery/INVOICE/model/supplier.dart';
import 'package:grocery/INVOICE/model/customer.dart';

class OrderScreen extends StatefulWidget {

  var customerId;
  OrderScreen({this.customerId});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  var cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.background,
        titleSpacing: 0,
        title: Text('My Orders',style: TextStyle(color: MyColors.primary,fontWeight: FontWeight.normal),),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: MyColors.primary,
          ),
        ),
        actions: [
          const SizedBox(width: 8,),
          Column(
            children: [
              const SizedBox(height: 18,),
              InkWell(
                  onTap: (){
                    // Navigator.push(context, MaterialPageRoute(builder: (_)=> CartScreen()));
                    Navigator.of(context,
                        rootNavigator: false)
                        .push(MaterialPageRoute(builder: (_)=>CartScreen()));
                  },
                  child: Badge(
                    badgeContent: Obx(() => Text('${cartController.carts.length}',style: const TextStyle(color: Colors.white),)),
                    child: Icon(Icons.add_shopping_cart_outlined, color: MyColors.primary,size: 22,),
                  )
              ),
              Obx(() => Text('৳ ${cartController.totalPrice()}',
                style: TextStyle(
                    color: MyColors.primary,
                    fontSize: 8
                ),
              ))
            ],
          ),
          const SizedBox(
            width: 22,
          ),
        ],
      ),


      body: FutureBuilder(
        future: orderList(context, '${widget.customerId}', loginController.loginToken().toString()),
          builder: (BuildContext context, AsyncSnapshot snapshot){
          return snapshot.hasData?
          ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data.length+1,
              itemBuilder: (_, i) {

                var data = snapshot.data;


                if(i<snapshot.data.length){
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: MyColors.shadow))
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ///left side
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text('Order no: ${data[i]['order_no']}',style: const TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                            ),
                            Text('Placed on ${data[i]['date']}',style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),),
                            Text('Payment type: ${data[i]['payment_type']}',style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey
                            ),),
                            Text(data[i]['order_status'][data[i]['order_status'].length==0?0:data[i]['order_status'].length-1]['status']['name'],style: TextStyle(
                                color: MyColors.primary
                            ),
                            )
                          ],
                        ),

                        ///right side
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            Text('Grand Total: ৳${data[i]['grand_total'].toString().split('.')[0]}.${data[i]['grand_total'].toString().split('.')[1].substring(0,1)}',style: const TextStyle(
                                fontWeight: FontWeight.bold
                            ),),

                            Text('Quantity: ${data[i]['total_quantity']}'),

                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Row(
                                children: [

                                  ///for history
                                  InkWell(
                                    onTap: (){
                                      showDialog(
                                          context: context,
                                          builder: (_)=> AlertDialog(
                                            title: const Text('Order History',textAlign: TextAlign.center,),
                                            content: ListView.builder(
                                              itemCount: data[i]['order_status'].length,
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              itemBuilder: (BuildContext context, index) {

                                                var detailData = data[i]['order_status'][index];

                                                return Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                                    margin: const EdgeInsets.symmetric(horizontal: 8),
                                                    decoration: BoxDecoration(
                                                      color: index % 5 == 0 ? const Color(0xfffff6f6) :
                                                      index % 4 == 0 ? const Color(0xfff0f0ff) :
                                                      index % 3 == 0 ? const Color(0xfff1fbff) :
                                                      index % 2 == 0 ? const Color(0xfffffdc9) : const Color(0xffdefdde),
                                                        border: Border.all(
                                                            color: MyColors.shadow)),
                                                    child: Row(
                                                      children: [
                                                        Text('${detailData['status']['name']}'),

                                                        const Spacer(),
                                                        //Product Details
                                                        Text(detailData['status']['created_at'].toString().split('T')[0])

                                                      ],
                                                    ));
                                              },
                                            )
                                          )
                                      );
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(top: 2),
                                        padding: const EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            color: MyColors.historyColor,
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Icon(Icons.history,color: MyColors.background,size: 15,)),
                                  ),



                                ///for return
                                //   data[i]['order_status'][data[i]['order_status'].length==0?0:data[i]['order_status'].length-1]['status']['name']=='Delivered'?
                                //   InkWell(
                                //   onTap: (){
                                //     Navigator.push(context, MaterialPageRoute(builder: (_)=> OrderReturnsScreen(orderNo: data[i]['order_no'].toString(),token: loginController.loginToken(),)));
                                //   },
                                //   child: Container(
                                //       margin: const EdgeInsets.only(top: 2,left: 8),
                                //       padding: const EdgeInsets.all(7),
                                //     decoration: BoxDecoration(
                                //       color: MyColors.editColor,
                                //       borderRadius: BorderRadius.circular(5)
                                //     ),
                                //       child: Icon(Icons.assignment_return,color: MyColors.background,size: 15,)),
                                // ):const SizedBox(),


                                  ///for update order
                                  data[i]['order_status'][data[i]['order_status'].length==0?0:data[i]['order_status'].length-1]['status']['name']=='Pending'?
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryScreen(phone: loginController.loginPhone(),
                                        type: 'update', orderId: data[i]['id'],)));
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(top: 2,left: 8),
                                        padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: const Color(0xff873e23),
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                        child: Icon(Icons.edit,color: MyColors.background,size: 15,)),
                                  ):const SizedBox(),


                                  ///for alert view product details
                                  InkWell(
                                    onTap: () async {

                                      ///Submit sales with Invoice
                                      // _invoicePrint() async{

                                        // var customerId = '1';
                                        var companyName = 'Sara Bosor Ekrate Ltd.';

                                        final date = DateTime.now();
                                        final invoice = Invoice(
                                          supplier:  Supplier(
                                            name: '$companyName',
                                            address: 'Keraniganj, Dhaka',
                                            paymentInfo: '',
                                          ),

                                          customer: Customer(
                                              name: '${data[i]['order_customer_info']['name']}', //customer Name
                                              address: '${data[i]['order_customer_info']['address']}',
                                              phoneNo: '${data[i]['order_customer_info']['phone']}',
                                              createdAt: data[i]['order_customer_info']['created_at'].toString().split('T')[0],
                                              deleveryTime: '',
                                              invoiceNumber: '${data[i]['order_no']}'
                                          ),


                                          info: InvoiceInfo(
                                            date: date,
                                            SalesId: null,
                                          ),
                                          subTotal: data[i]['subtotal'],
                                          vat: data[i]['total_vat_amount'],
                                          shippingCost: data[i]['total_shipping_cost'],
                                          discount: data[i]['total_discount_amount'],
                                          totalPayable: data[i]['grand_total'],
                                          paidAmount: 0,
                                          cashToCollect: data[i]['grand_total'],
                                          items: [
                                            for (var j = 0; j < data[i]['order_details'].length; j++)...{
                                              InvoiceItem(
                                                  serial: j + 1,
                                                  description: '${data[i]['order_details'][j]['product']['name']}',
                                                  date: DateTime.now(),
                                                  quantity: double.parse(data[i]['order_details'][j]['quantity'].toString()),
                                                  vat: 0,
                                                  unitPrice: double.parse(data[i]['order_details'][j]['sale_price'].toString().replaceAll('.00', '.0'))
                                              ),
                                            }
                                          ],
                                        );
                                        final pdfFile = await PdfInvoiceApi.generate(invoice);
                                        PdfApi.openFile(pdfFile);
                                      // }

                                      // Navigator.push(context, MaterialPageRoute(builder: (_)=>OrderByViewScreen(
                                      //   orderNo             : data[i]['order_no'],
                                      //   orderDetails        : data[i]['order_details'],
                                      //   orderCustomerInfo   : data[i]['order_customer_info'],
                                      //   subtotal            : '${data[i]['subtotal'] ?? ''}',
                                      //   totalVatAmount      : '${data[i]['total_vat_amount'] ?? ''}',
                                      //   shippingCost        : '${data[i]['shipping_cost'] ?? ''}',
                                      //   totalDiscountAmount : '${data[i]['total_discount_amount'] ?? ''}',
                                      //   grandTotal          : '${data[i]['grand_total'] ?? ''}',
                                      //
                                      // )));

                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(7),
                                        margin: const EdgeInsets.only(top: 2,left: 8),
                                        decoration: BoxDecoration(
                                            color: MyColors.viewColor,
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Icon(Icons.remove_red_eye,color: MyColors.background,size: 15,),),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }else if(i==0){
                  return Container(
                      height: MediaQuery.of(context).size.height/1.5,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/gift.png',height: 100,),
                          const Text("\nYou haven't placed any orders yet",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ],
                      ));

                }else{
                  return const Text(' ');
                }
              })
              :const Center(child: CircularProgressIndicator(),);
          }
      ),
    );
  }

  TextView(text){
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Text(text.toString().replaceAll('Status.', '').replaceAll('00:00:00.000', ''), textAlign: TextAlign.center,),
    );
  }

}
