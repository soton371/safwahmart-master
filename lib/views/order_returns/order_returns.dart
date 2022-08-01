import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:http/http.dart' as http;
import '../../controllers/apis.dart';

class OrderReturnsScreen extends StatefulWidget {
  // const OrderReturnsScreen({Key? key}) : super(key: key);
  dynamic orderNo, token;
  OrderReturnsScreen({this.orderNo, this.token});

  @override
  State<OrderReturnsScreen> createState() => _OrderReturnsScreenState();
}

class _OrderReturnsScreenState extends State<OrderReturnsScreen> {

  //for select product list
  List selectProduct = [];

  //for reason
  List reasonList = [];
  dynamic selectReason;

  //for products
  List productList = [];

  //for checkbox
  dynamic checkboxOne = false;

  //for fetch products of order
  Future productsOfOrder() async {
    var url =
        Uri.parse('$baseUrl/create-order-return?order_no=${widget.orderNo}');
    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: 'Bearer ${widget.token}'});

    var data = json.decode(response.body);
    var statusCode = response.statusCode;
    switch (statusCode) {
      case 200:
        {
          setState(() {
            reasonList = data['returnReasons'];
            productList = data['order']['order_details'];
            orderId = data['order']['id'];
          });

        }
        break;
      default:
        {
          MyComponents().wrongSnackBar(context, 'Something went wrong');
        }
    }
  }

  //send data api
  List orderDetailsIdList=[];
  dynamic orderId;
  dynamic selectReasonId;
  dynamic note;
  List conditionList=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productsOfOrder();
  }

  List selectedItemValue = [];

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ['Condition',"Damaged", "Expired", "Good"];
    return ddl
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value),
    )).toList();
  }

  var dropIndex = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.background,
        titleSpacing: 0,
        title: Text(
          'Order Return',
          style:
              TextStyle(color: MyColors.primary, fontWeight: FontWeight.normal),
        ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('Order no: ${widget.orderNo}'),

            ///for select reason
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(bottom: 8, top: 8),
              height: 45,
              alignment: Alignment.centerLeft,
              color: MyColors.shadow,
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  items: reasonList.map((item) {
                    return DropdownMenuItem(
                      onTap: (){
                        setState((){
                          selectReasonId = item['id'];
                        });
                      },
                      child: Text("${item['title']}"),
                      value: "${item['title']}",
                    );
                  }).toList(),
                  value: selectReason,
                  onChanged: (v) => setState(() {
                    selectReason = v.toString();
                  }),
                  hint: const Text('Select Reason *'),
                ),
              ),
            ),

            const Divider(
              thickness: 5,
            ),

            ///for show products
            Expanded(
              child: ListView.builder(
                  itemCount: productList.length,
                  itemBuilder: (_, i) {

                    selectProduct.add(SelectProduct(selectIs: false,orderDetailsId: productList[i]['id']));
                    selectedItemValue.add('Condition');

                    return Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: MyColors.shadow))),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///for check box
                          productList[i]['product']['is_refundable']=='Yes'?
                              
                              //when already return request send
                          productList[i]['exist_in_return']==1?IconButton(onPressed: (){
                            MyComponents().mySnackBar(context, 'Return request has already been sent');
                          }, icon: Icon(Icons.check_box,color: MyColors.inactive,)):
                          Checkbox(
                              value: selectProduct[i].selectIs,
                              onChanged: (v) {
                                setState(() {
                                  selectProduct[i].selectIs = v;
                                  print('object');
                                  selectProduct[i].selectIs?orderDetailsIdList.add(productList[i]['id']):orderDetailsIdList.remove(productList[i]['id']);
                                  print('object2');
                                });
                              })
                              :
                          IconButton(
                              onPressed: (){
                                MyComponents().mySnackBar(context, 'This product is not refundable');
                              },
                              icon: Icon(Icons.info_outline,color: MyColors.increment,)
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${productList[i]['product']['name']}',
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Text('${productList[i]['quantity'].toString().split('.')[0]}x${productList[i]['sale_price']}'),
                                //for amount
                                Text(
                                  '৳${productList[i]['total_amount'].toString().split('.')[0]}.${productList[i]['total_amount'].toString().split('.')[1].toString().substring(0,2)}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),

                          //for condition
                          selectProduct[i].selectIs?
                          DropdownButton(
                            value: selectedItemValue[i].toString(),
                            items: _dropDownItem(),
                            onChanged: (value) {
                              setState((){
                                selectedItemValue[i] = value.toString();

                                dropIndex.add('$i${selectedItemValue[i]}');

                                dropIndex.toString().contains(i.toString()) ?
                                {
                                  print('shamol'),
                                  print('Length: ${i.toString().length}'),
                                  dropIndex.removeRange(0, i.toString().length),
                                  dropIndex.add('$i${selectedItemValue[i]}')
                                }
                                    :
                                print('soton');
                              });
                            },
                            hint: const Text('Condition'),
                          ) : const SizedBox()

                          // productList[i]['product']['is_refundable']=='Yes'?
                          //     //when already return request send
                          // productList[i]['exist_in_return']==1?const SizedBox():
                          // DropdownButton(
                          //   isDense: true,
                          //   icon: Icon(
                          //     Icons.arrow_drop_down,
                          //     color: Colors.black.withOpacity(0.5),
                          //   ),
                          //   items: const [
                          //     DropdownMenuItem(
                          //       child: Text(
                          //         "Damaged",
                          //         style: TextStyle(fontSize: 12),
                          //       ),
                          //       value: "Damaged",
                          //     ),
                          //     DropdownMenuItem(
                          //       child: Text(
                          //         "Expired",
                          //         style: TextStyle(fontSize: 12),
                          //       ),
                          //       value: "Expired",
                          //     ),
                          //     DropdownMenuItem(
                          //       child: Text(
                          //         "Good",
                          //         style: TextStyle(fontSize: 12),
                          //       ),
                          //       value: "Good",
                          //     )
                          //   ],
                          //   value: selectCondition,
                          //   onChanged: (v) => setState(() {
                          //     selectCondition = v.toString();
                          //   }),
                          //   hint: const Text(
                          //     'Condition',
                          //     style: TextStyle(fontSize: 12),
                          //   ),
                          // ):const SizedBox(),
                        ],
                      ),
                    );
                  }),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Note'
              ),
              onChanged: (v){
                setState((){
                  note=v;
                });
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        child: ElevatedButton(
            onPressed: (){
              print('order id: $orderId');
              print('return_reason_id: $selectReasonId');
              print('order_detail_id: $orderDetailsIdList');
              print('condition list: $dropIndex');
              print('note: $note');

            },
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              elevation: 0
            ),
            child: const Text('Submit')
        ),
      ),
    );
  }
}

class SelectProduct{
  dynamic selectIs,orderDetailsId, condition;
  SelectProduct({this.selectIs,this.orderDetailsId, this.condition});
}