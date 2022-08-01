import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/controllers/test_con.dart';
import 'package:grocery/locals/database/db_helper.dart';
import 'package:grocery/locals/model/local_cart_model.dart';
import 'package:grocery/views/account/getx_auth/login_scr.dart';
import 'package:grocery/views/cart/CartScreen.dart';
import 'package:grocery/views/product_details/product_details.dart';
import 'package:grocery/widgets/appbar_widget.dart';
import 'package:grocery/widgets/drawer_widget.dart';
import 'package:http/http.dart' as http;


class OfferProductsScreen extends StatefulWidget {
  const OfferProductsScreen({Key? key}) : super(key: key);

  @override
  State<OfferProductsScreen> createState() => _OfferProductsScreenState();
}

class _OfferProductsScreenState extends State<OfferProductsScreen> {

  var categoryProduct = [];
  var addedProducts   = [];
  var cartController  = Get.put(CartController());
  var loginController = Get.put(LoginController());
  var testController  = Get.put(TestController());
  int allQuentity = 0;

//for pagination
  final scrollController = ScrollController();
  List items = [];
  int page = 1;
  bool hasMore = true;
  var sum = 0.0;

  //for offers products
  Future fetchOfferProducts()async{

    const limit = 20;

    var url = Uri.parse('$baseUrl/offer-products?page=$page');
    var response = await http.get(url);

    if(response.statusCode == 200){

      final List newItems = json.decode(response.body)['products']['data'];

      setState((){
        page++;
        if(newItems.length<limit){
          hasMore = false;
        }
        items.addAll(newItems.map((e) {
          return e;
        }));
      });
    }

  }

  @override
  void initState() {
    fetchOfferProducts();

    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent==scrollController.offset){
        fetchOfferProducts();
      }
    });
    // TODO: implement initState
    super.initState();
    //fetchCategoryWiseProducts(widget.type, widget.slug);
  }


  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: DrawerWidget(),
      floatingActionButton: allQuentity < 1 && cartController.carts.isEmpty ? Container() : InkWell(
        onTap: (){
          for (var i = 0; i< testController.proList.length; i++){
            final carts =  AddtoCart(
              product_id      : testController.proList[i].product_id,
              product_name    : testController.proList[i].product_name,
              unit_tag        : testController.proList[i].unit_tag,
              image           : testController.proList[i].image,
              purchase_price  : testController.proList[i].purchase_price,
              sale_price      : testController.proList[i].sale_price,
              quantity        : testController.proList[i].quantity,
              view_quantity   : testController.proList[i].view_quantity,
              vat_amount      : testController.proList[i].vat_amount,
              discount_amount : testController.proList[i].discount_amount,
              maximum_quantity: testController.proList[i].maximum_quantity,
              current_stock   : testController.proList[i].current_stock,
              weight          : testController.proList[i].weight,
            );
            CartDatabase.instance.createCart(context, carts, pass: 'true').then((value) {
              cartController.refreshCarts();
              cartController.totalPrice();
            });
          }
          testController.proList.removeRange(0, testController.proList.length);

          //add by stephen
          Get.to(CartScreen());
        },
        child: Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(.9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 3,
              ),
            ],
          ),
          height: 50,
          child: Row(
            children: [
              Icon(Icons.shopping_bag_outlined,color: MyColors.buttonTextColor,),

              Text("  Review Order",
                style: TextStyle(
                    color: MyColors.buttonTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
              const Spacer(),
              Obx(() => Text('৳${double.parse(testController.totalPrice().toString())+double.parse(cartController.totalPrice().toString())} ',
                style: TextStyle(
                    color: MyColors.buttonTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ))
            ],
          ),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Expanded(
            child:
            ListView.builder(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            itemCount: items.length,
            itemBuilder: (_,i){

              var data = items[i];
              categoryProduct.add(ContactModel(data['name'], false));

            return GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(image: data['image'], productId: data['id'],
                  name: data['name'], price: '${data['sale_price'].toString().split('.')[0]}.${data['sale_price'].toString().split('.')[1].toString().substring(0,1)}',
                  description: data['description'], subText: data['sub_text'], unitMeasureName: data['unit_measure']['name'],purchasePrice: data['purchase_price'],
                  vat: data['vat'],discount: data['discount'], maximumOrder: data['maximum_order_quantity'], currentStock: data['current_stock'], sku: data['sku'],
                  categoryId: data['category_id'], id: data['id'], weight: data['weight'], productMeasurements: data['product_measurements'],)));
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: MyColors.shadow))),
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: '$imgBaseUrl/${data['image']}',
                        height: 65,
                        width: 65,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text('${data['name'] ?? ''}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  '   ৳${data['sale_price'].toString().split('.')[0]}.${data['sale_price'].toString().split('.')[1].substring(0,1)}',
                                  style: TextStyle(
                                      color: MyColors.decrement,
                                      fontWeight: FontWeight.w500),
                                ),

                                Expanded(
                                  child: Text(
                                    // ' /${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : data['sub_text'] ?? ''}${data['unit_measure']['name']}',
                                    ' /${data['sub_text'] ?? ''}${data['unit_measure']['name']}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            );
          }
          )

            // ListView.builder(
            //     physics: const BouncingScrollPhysics(),
            //     controller: scrollController,
            //     itemCount: items.length + 1,
            //     itemBuilder: (_, i) {
            //       if (i < items.length) {
            //         var data = items[i];
            //         categoryProduct.add(ContactModel(data['name'], false));
            //         addedProducts.add(AddProductModel(added: false, product_name: '${data['name']}', unit_tag: '${data['unit_measure']['name'] ?? ''}',
            //             image: '${data['image'] ?? ''}', view_quantity: '${data['sub_text'] ?? 1}', product_id: data['id'], quantity: 0,
            //             purchase_price: double.parse('${data['purchase_price'] ?? 0.0}'), sale_price: double.parse('${data['sale_price'] ?? 0.0}'),
            //             vat_amount: double.parse('${data['vat'] ?? 0.0}'), discount_amount: double.parse('${data['current_discount'] ?? 0.0}'),
            //             maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'), current_stock: double.parse('${data['current_stock'] ?? 0.0}'),
            //             weight: double.parse('${data['weight'] ?? 0.0}')));
            //
            //         return GestureDetector(
            //           onTap: () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => ProductDetailsScreen(
            //                       image: data['image'],
            //                       productId: data['id'],
            //                       name: data['name'],
            //                       price:
            //                       '${data['sale_price'].toString().split('.')[0]}.${data['sale_price'].toString().split('.')[1].toString().substring(0, 1)}',
            //                       description: data['description'],
            //                       subText: data['sub_text'],
            //                       unitMeasureName: data['unit_measure']
            //                       ['name'],
            //                       purchasePrice: data['purchase_price'],
            //                       vat: data['vat'],
            //                       discount: data['discount'],
            //                       maximumOrder:
            //                       data['maximum_order_quantity'],
            //                       currentStock: data['current_stock'],
            //                       sku: data['sku'],
            //                       categoryId: data['category_id'],
            //                       id: data['id'],
            //                       weight: data['weight'],
            //                     )));
            //           },
            //           child: Container(
            //               padding: const EdgeInsets.symmetric(horizontal: 10),
            //               decoration: BoxDecoration(
            //                   border: Border(
            //                       bottom: BorderSide(color: MyColors.shadow))),
            //               child: Row(
            //                 children: [
            //                   //image
            //                   CachedNetworkImage(
            //                     imageUrl: '$imgBaseUrl/${data['image']}',
            //                     height: 65,
            //                     width: 60,
            //                   ),
            //
            //                   const SizedBox(
            //                     width: 8,
            //                   ),
            //                   //Product Details
            //                   Expanded(
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(data['name'],style: TextStyle(fontSize: 16),),
            //                         const SizedBox(
            //                           height: 5,
            //                         ),
            //                         Row(
            //                           children: [
            //                             Text(
            //                               '৳${data['sale_price'].toString().split('.')[0]}.${data['sale_price'].toString().split('.')[1].substring(0, 1)}',
            //                               style: TextStyle(
            //                                   color: MyColors.decrement,
            //                                   fontWeight: FontWeight.w500),
            //                             ),
            //                             Text(
            //                               '/${data['sub_text'] ?? ''}${data['unit_measure']['name']}',
            //                               style: const TextStyle(fontSize: 12),
            //                             ),
            //                           ],
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //
            //                   const SizedBox(
            //                     width: 8,
            //                   ),
            //
            //                   if (double.parse(data['current_stock'] != null
            //                       ? data['current_stock']
            //                       .toString()
            //                       .replaceAll('.000000', '')
            //                       : '0') <=
            //                       0) ...{
            //                     Column(
            //                       children: [
            //                         InkWell(
            //                           onTap: () {
            //                             if (loginController.loginToken() ==
            //                                 '') {
            //                               Navigator.push(
            //                                 context,
            //                                 MaterialPageRoute(
            //                                     builder: (context) =>
            //                                      LoginScreen()),
            //                               );
            //                             } else {
            //                               productRequest(
            //                                   context: context,
            //                                   customerId: loginController
            //                                       .loginCustomerId(),
            //                                   productId: data['product_id'],
            //                                   productVariationId: '',
            //                                   token:
            //                                   loginController.loginToken());
            //                             }
            //                           },
            //                           child: Container(
            //                             padding: const EdgeInsets.all(5),
            //                             margin: const EdgeInsets.only(top: 5),
            //                             child: const Text(
            //                               'Request',
            //                               style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontWeight: FontWeight.bold,
            //                                   fontSize: 12),
            //                             ),
            //                             decoration: BoxDecoration(
            //                                 borderRadius:
            //                                 BorderRadius.circular(5),
            //                                 color: MyColors.inactive),
            //                           ),
            //                         ),
            //                         Text(
            //                           'Out of Stock',
            //                           style: TextStyle(
            //                               color: MyColors.decrement,
            //                               fontSize: 12),
            //                         )
            //                       ],
            //                     ),
            //                   }
            //
            //                   else if(cartController.productId().toString().contains(data['id'].toString()))...{
            //                     Container(
            //                       padding: const EdgeInsets.all(5),
            //                       margin: const EdgeInsets.only(top: 5),
            //                       child: const Text(
            //                         'Already Cart',
            //                         style: TextStyle(
            //                             color: Colors.white,
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 12),
            //                       ),
            //                       decoration: BoxDecoration(
            //                           borderRadius:
            //                           BorderRadius.circular(5),
            //                           color: Colors.amber),
            //                     )
            //                   }
            //
            //                   //for add and update
            //                   else ...{
            //                       //Add To Cart
            //
            //                       addedProducts[i].added
            //                           ? Row(
            //                         children: [
            //                           addedProducts[i].quantity > 0
            //                               ? IconButton(
            //                             onPressed: () {
            //                               setState(() {
            //                                 addedProducts[i].quantity--;
            //
            //                                 for(var j = 0; j<testController.proList.length; j++){
            //                                   if(testController.proList[j].product_id == data['id']){
            //                                     testController.proList.removeAt(j);
            //                                     testController.proList.value.add(AddProductModel(added: false, product_name: '${data['name']}', unit_tag: '${data['unit_measure']['name'] ?? ''}',
            //                                         image: '${data['image'] ?? ''}', view_quantity: '${data['sub_text'] ?? 1}', product_id: data['id'], quantity: addedProducts[i].quantity,
            //                                         purchase_price: double.parse('${data['purchase_price'] ?? 0.0}'), sale_price: double.parse('${data['sale_price'] ?? 0.0}'),
            //                                         vat_amount: double.parse('${data['vat'] ?? 0.0}'), discount_amount: double.parse('${data['current_discount'] ?? 0.0}'),
            //                                         maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'), current_stock: double.parse('${data['current_stock'] ?? 0.0}'),
            //                                         weight: double.parse('${data['weight'] ?? 0.0}')));                                                        }
            //                                 }
            //                                 if(addedProducts[i].quantity == 0){
            //                                   for(var j = 0; j<testController.proList.length; j++){
            //                                     if(testController.proList[j].product_id == data['id']){
            //                                       testController.proList.removeAt(j);
            //                                     }
            //                                   }
            //                                   addedProducts[i].added = false;
            //                                 }
            //                               });
            //                               allQuentity--;
            //
            //                             },
            //                             icon: Container(
            //                               height: 30,
            //                               width: 30,
            //                               decoration: BoxDecoration(
            //                                   color: MyColors.decrement.withOpacity(.2),
            //                                   borderRadius: BorderRadius.circular(5)
            //                               ),
            //                               child: Icon(
            //                                 Icons.remove,
            //                                 color: MyColors.decrement,
            //                               ),
            //                             ),
            //                           )
            //                               : Container(),
            //
            //                           addedProducts[i].quantity < 1
            //                               ? const Text('')
            //                               : Text(addedProducts[i].quantity.toString(),
            //                             style: const TextStyle(
            //                                 fontWeight: FontWeight.w500
            //                             ),
            //                           ),
            //
            //                           IconButton(
            //                               onPressed: () {
            //                                 setState(() {
            //                                   addedProducts[i].quantity++;
            //                                   for(var j = 0; j<testController.proList.length; j++){
            //                                     if(testController.proList[j].product_id == data['id']){
            //                                       testController.proList.removeAt(j);
            //                                       testController.proList.value.add(AddProductModel(added: false, product_name: '${data['name']}', unit_tag: '${data['unit_measure']['name'] ?? ''}',
            //                                           image: '${data['image'] ?? ''}', view_quantity: '${data['sub_text'] ?? 1}', product_id: data['id'], quantity: addedProducts[i].quantity,
            //                                           purchase_price: double.parse('${data['purchase_price'] ?? 0.0}'), sale_price: double.parse('${data['sale_price'] ?? 0.0}'),
            //                                           vat_amount: double.parse('${data['vat'] ?? 0.0}'), discount_amount: double.parse('${data['current_discount'] ?? 0.0}'),
            //                                           maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'), current_stock: double.parse('${data['current_stock'] ?? 0.0}'),
            //                                           weight: double.parse('${data['weight'] ?? 0.0}')));                                                        }
            //                                   }
            //                                 });
            //                                 allQuentity++;
            //                                 print('Plus 1');
            //                               },
            //                               icon: Container(
            //                                 height: 30,
            //                                 width: 30,
            //                                 decoration: BoxDecoration(
            //                                     color: MyColors.increment.withOpacity(0.2),
            //                                     borderRadius: BorderRadius.circular(5)
            //                                 ),
            //                                 child: Icon(
            //                                   Icons.add,
            //                                   color: MyColors.increment,
            //                                 ),
            //                               )),
            //                         ],
            //                       )
            //                           : data['unit_measure']['name'].toString().toLowerCase().contains('coming')
            //                           ? Container(
            //                         padding:
            //                         const EdgeInsets.all(5),
            //                         margin: const EdgeInsets.only(
            //                             top: 5),
            //                         child: const Text(
            //                           'Coming Soon',
            //                           style: TextStyle(
            //                               color: Colors.white,
            //                               fontWeight:
            //                               FontWeight.bold,
            //                               fontSize: 12),
            //                         ),
            //                         decoration: BoxDecoration(
            //                             borderRadius:
            //                             BorderRadius.circular(
            //                                 5),
            //                             color: MyColors.inactive),
            //                       )
            //                           : IconButton(
            //                           onPressed: () {
            //
            //                             setState(() {
            //                               addedProducts[i].quantity++;
            //                               allQuentity++;
            //                               addedProducts[i].added = true;
            //                               testController.proList.value.add(AddProductModel(added: false, product_name: '${data['name']}', unit_tag: '${data['unit_measure']['name'] ?? ''}',
            //                                   image: '${data['image'] ?? ''}', view_quantity: '${data['sub_text'] ?? 1}', product_id: data['id'], quantity:  addedProducts[i].quantity,
            //                                   purchase_price: double.parse('${data['purchase_price'] ?? 0.0}'), sale_price: double.parse('${data['sale_price'] ?? 0.0}'),
            //                                   vat_amount: double.parse('${data['vat'] ?? 0.0}'), discount_amount: double.parse('${data['current_discount'] ?? 0.0}'),
            //                                   maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'), current_stock: double.parse('${data['current_stock'] ?? 0.0}'),
            //                                   weight: double.parse('${data['weight'] ?? 0.0}')));
            //                             });
            //                           },
            //                           icon: Container(
            //                             height: 30,
            //                             width: 30,
            //                             decoration: BoxDecoration(
            //                                 color: MyColors.increment.withOpacity(0.2),
            //                                 borderRadius: BorderRadius.circular(5)
            //                             ),
            //                             child: Icon(
            //                               Icons.add,
            //                               color: MyColors.increment,
            //                             ),
            //                           ))
            //                     }
            //                 ],
            //               )),
            //         );
            //       } else {
            //         return Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 20),
            //           child: Center(
            //             child: hasMore
            //                 ? const CircularProgressIndicator()
            //                 : const Text('No more products are available'),
            //           ),
            //         );
            //       }
            //     }),
          ),
        ],
      ),
    );
  }
}
