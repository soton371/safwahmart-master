import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/locals/database/db_helper.dart';
import 'package:grocery/locals/model/local_cart_model.dart';
import 'package:grocery/views/cart/CartScreen.dart';
import 'package:grocery/views/product_details/product_details.dart';
import 'package:grocery/widgets/appbar_widget.dart';
import 'package:http/http.dart' as http;


class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  var cartController  = Get.put(CartController());
  var loginController = Get.put(LoginController());

  var cartProduct = [];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.background,
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: Icon(Icons.arrow_back,color: MyColors.primary,),
        ),
        elevation: 1,
        titleSpacing: 0,
        title: Text('Wishlist',style: TextStyle(color: MyColors.primary,fontWeight: FontWeight.normal),),
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
          future: fetchWishlist(loginController.loginUserId(), loginController.loginToken().toString()),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            return snapshot.hasData ?
            ListView.builder(
                itemCount: snapshot.data.length+1,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_,i){
                  var data = snapshot.data;

                  cartProduct.add(ContactModel(false));

                  if(i<snapshot.data.length){
                    return Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: MyColors.shadow))
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(image: data[i]['product']['image'], productId: data[i]['product']['id'],
                                name: data[i]['product']['name'], price: '${data[i]['product']['sale_price'].toString().split('.')[0]}.${data[i]['product']['sale_price'].toString().split('.')[1].toString().substring(0,1)}',
                                description: data[i]['product']['description'], subText: data[i]['product']['sub_text'], unitMeasureName: data[i]['product']['unit_measure']['name'],purchasePrice: data[i]['product']['purchase_price'],
                                vat: data[i]['product']['vat'],discount: data[i]['product']['discount'], maximumOrder: data[i]['product']['maximum_order_quantity'], currentStock: data[i]['product']['current_stock'],sku: data[i]['product']['sku'],
                                categoryId: data[i]['product']['category_id'], id: data[i]['id'], weight: data[i]['product']['weight'],productMeasurements : data[i]['product']['product_measurements'])));
                            },
                              child: Image.network('$imgBaseUrl/${data[i]['product']['thumbnail_image']}',height: 65,width: 65,),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(image: data[i]['product']['image'], productId: data[i]['product']['id'],
                                      name: data[i]['product']['name'], price: '${data[i]['product']['sale_price'].toString().split('.')[0]}.${data[i]['product']['sale_price'].toString().split('.')[1].toString().substring(0,1)}',
                                      description: data[i]['product']['description'], subText: data[i]['product']['sub_text'], unitMeasureName: data[i]['product']['unit_measure']['name'],purchasePrice: data[i]['product']['purchase_price'],
                                      vat: data[i]['product']['vat'],discount: data[i]['product']['discount'], maximumOrder: data[i]['product']['maximum_order_quantity'], currentStock: data[i]['product']['current_stock'],sku: data[i]['product']['sku'],
                                      categoryId: data[i]['product']['category_id'], id: data[i]['id'], weight: data[i]['product']['weight'],productMeasurements : data[i]['product']['product_measurements'],)));
                                  },
                                  child: Text('${data[i]['product']['name']} - ${data[i]['product']['sub_text']}/${data[i]['product']['unit_measure']['name']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Text('৳${data[i]['product']['sale_price']}'),
                                    Expanded(
                                      child: Text(
                                        ' /${data[i]['product']['product_measurements'].length > 0 ? data[i]['product']['product_measurements'][0]['title'] : data[i]['product']['sub_text'] ?? ''} ${data[i]['product']['product_measurements'].length > 0 ?'':data[i]['product']['unit_measure']['name']}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),

                          //const Spacer(),

                          IconButton(
                            padding: const EdgeInsets.all(2),
                            onPressed: () async {
                              var url = Uri.parse('$baseUrl/delete-from-wishlist/${data[i]['id']}');
                              var res = await http.get(url,headers: {
                                HttpHeaders.authorizationHeader: 'Bearer ${loginController.loginToken()}'
                              });

                              var status = json.decode(res.body)['status'];


                              switch(status){
                                case 1:
                                  {
                                    setState((){
                                      data.removeAt(i);
                                    });
                                    MyComponents().wrongSnackBar(context, 'Delete item from wishlist');
                                  }
                                  break;
                                case 0:
                                  {
                                    print('object: something wrong delete wishlist');
                                  }
                              }

                              //deleteWishlist(context, '${data[i]['id']}', loginController.loginToken().toString());
                            },
                            icon: Image.asset('assets/images/delete.png',height: 20,color: MyColors.red,),
                          ),

                          //for add to cart
                          // const Spacer(),
                          //
                          // if(double.parse(data[i]['product']['current_stock'] != null ? data[i]['product']['current_stock'].toString().replaceAll('.000000', '') : '0') <= 0)...{
                          //
                          // }
                          //
                          // else...{
                          //   //Add To Cart
                          //   cartProduct[i].isSelected ||
                          //       data[i]['product']['unit_measure']['name'].toString().toLowerCase().contains('coming') ?
                          //   Container(
                          //     padding: const EdgeInsets.all(7),
                          //     margin: const EdgeInsets.only(top: 5, right: 8),
                          //     child: Text(data[i]['product']['unit_measure']['name'].toString().toLowerCase().contains('coming') ? 'Coming Soon' : 'Add To Cart',
                          //       style: const TextStyle(
                          //           color: Colors.white,
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 12
                          //       ),),
                          //     decoration: BoxDecoration(
                          //         borderRadius: BorderRadius.circular(5),
                          //         color:
                          //         MyColors.inactive),
                          //   )
                          //       :
                          //   GestureDetector(
                          //       onTap: (){
                          //         setState((){
                          //           cartProduct[i].isSelected = !cartProduct[i].isSelected;
                          //
                          //         });
                          //         final carts =  AddtoCart(
                          //           product_id      : data[i]['product']['id'],
                          //           product_name    : '${data[i]['product']['name'] ?? ''}',
                          //           unit_tag        : '${data[i]['product']['unit_measure']['name'] ?? ''}',
                          //           image           : '${data[i]['product']['image'] ?? ''}',
                          //           purchase_price  : double.parse('${data[i]['product']['purchase_price'] ?? 0.0}'),
                          //           sale_price      : double.parse('${data[i]['product']['sale_price'] ?? 0.0}'),
                          //           quantity        : 1,
                          //           view_quantity   : '${data[i]['product']['sub_text'] ?? 1}',
                          //           vat_amount      : double.parse('${data[i]['product']['vat'] ?? 0.0}'),
                          //           discount_amount : double.parse('${data[i]['product']['current_discount'] ?? 0.0}'),
                          //           maximum_quantity: double.parse('${data[i]['product']['maximum_order_quantity'] ?? 0.0}'),
                          //           current_stock   : double.parse('${data[i]['product']['current_stock'] ?? 0.0}'),
                          //           weight          : double.parse('${data[i]['product']['weight'] ?? 0.0}'),
                          //         );
                          //         CartDatabase.instance.createCart(context, carts).then((value) {
                          //           cartController.refreshCarts();
                          //           cartController.totalPrice();
                          //         });
                          //       },
                          //       child: Container(
                          //         padding: const EdgeInsets.all(7),
                          //         margin: const EdgeInsets.only(top: 5, right: 8),
                          //         child: const Text('Add To Cart',style: TextStyle(
                          //             color: Colors.white,
                          //             fontWeight: FontWeight.bold,
                          //             fontSize: 12
                          //         ),),
                          //         decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.circular(5),
                          //             color:
                          //             MyColors.primary),
                          //       )
                          //   )
                          // }

                        ],
                      ),
                    );
                  }else if(i==0){
                    return SizedBox(
                      height: MediaQuery.of(context).size.height/1.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/gift.png',height: 100,),
                          const Text('\nYour wishlist is empty',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    );
                  }else{
                    return const Text('');
                  }
                }
            )
                :
            const Center(child: CircularProgressIndicator());
          }
      ),
    );
  }
}


//model for local data
class ContactModel {
  bool isSelected;
  ContactModel(this.isSelected);
}