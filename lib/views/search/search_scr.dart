import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/calculation/discount_price.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/views/product_details/product_details.dart';

class SearchScreen extends SearchDelegate{

  var searchProduct = [];
  var cartController  = Get.put(CartController());
  dynamic haseMore = true;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: (){
            query = "";
          },
          icon: const Icon(Icons.clear)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context));
  }

  @override
  Widget buildResults(BuildContext context) {

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState){
          return FutureBuilder(
              future: searchProducts(query),
              builder: (BuildContext context, AsyncSnapshot snapshot){

                return snapshot.hasData?
                ListView.builder(
                    itemCount: snapshot.data.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_,i){

                      var data = snapshot.data[i];
                      searchProduct.add(ContactModel(data['name'], false));
                      var price = discountPrice(salePrice: data['sale_price'], productMeasurement: data['product_measurements'], productMeasurementValue: data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0,
                          discounts: data['discount'], discountPercent: data['discount'] != null ? data['discount']['discount_percentage'] : 0.0 , discountEndDate: data['discount'] != null ?
                          data['discount']['end_date'] : null);

                      return GestureDetector(
                        onTap: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(
                            image              : data['image'],
                            productId          : data['id'],
                            name               : data['name'],
                            getSalePrice       : data['sale_price'],
                            price              : '${price.toString().split('.')[0]}.${price.toString().split('.')[1].toString().substring(0, 1)}',
                            description        : data['description'],
                            subText            : data['sub_text'],
                            unitMeasureName    : data['unit_measure']['name'],
                            purchasePrice      : data['purchase_price'],
                            vat                : data['vat'],
                            discount           : data['discount'],
                            maximumOrder       : data['maximum_order_quantity'],
                            currentStock       : data['current_stock'],
                            sku                : data['sku'],
                            categoryId         : data['category_id'],
                            id                 : data['id'],
                            weight             : data['weight'],
                            productMeasurements: data['product_measurements'],
                          )));
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

                                SizedBox(width: 8,),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${data['name'] ?? ''}',
                                        style: const TextStyle(fontWeight: FontWeight.w500),
                                      ),

                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?
                                          Text(
                                              '  ৳${data['sale_price']} ',
                                              style: TextStyle(
                                                  color: MyColors.inactive,
                                                  fontWeight: FontWeight.w500,
                                                  decoration: TextDecoration.lineThrough)
                                          ) : const Text(''),
                                          Text(
                                            '৳${price.toString().split('.')[0]}.${price.toString().split('.')[1].substring(0, 1)}',
                                            style: TextStyle(
                                                color: MyColors.decrement,
                                                fontWeight: FontWeight.w500),
                                          ),

                                          Expanded(
                                            child: Text(
                                              ' /${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : data['sub_text'] ?? ''}${data['product_measurements'].length > 0 ?'':data['unit_measure']['name']}',
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
                    :
                const Center(
                  child: CircularProgressIndicator(),
                );

              }
          );
        }
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    return Container();
    // return StatefulBuilder(
    //     builder: (BuildContext context, StateSetter setState){
    //       return FutureBuilder(
    //           future: searchProducts(query),
    //           builder: (BuildContext context, AsyncSnapshot snapshot){
    //
    //             return snapshot.hasData?
    //             ListView.builder(
    //                 itemCount: snapshot.data.length,
    //                 physics: const BouncingScrollPhysics(),
    //                 itemBuilder: (_,i){
    //
    //                   var data = snapshot.data[i];
    //                   searchProduct.add(ContactModel(data['name'], false));
    //
    //                   return GestureDetector(
    //                     onTap: (){
    //                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(image: data['image'], productId: data['id'],
    //                         name: data['name'], price: '${data['sale_price'].toString().split('.')[0]}.${data['sale_price'].toString().split('.')[1].toString().substring(0,1)}',
    //                         description: data['description'], subText: data['sub_text'], unitMeasureName: data['unit_measure']['name'],purchasePrice: data['purchase_price'],
    //                         vat: data['vat'],discount: data['discount'], maximumOrder: data['maximum_order_quantity'], currentStock: data['current_stock'], sku: data['sku'],
    //                       categoryId: data['category_id'], id: data['id'], weight: data['weight'],)));
    //                     },
    //                     child: Container(
    //                         padding: const EdgeInsets.symmetric(horizontal: 10),
    //                         decoration: BoxDecoration(
    //                             border: Border(bottom: BorderSide(color: MyColors.shadow))),
    //                         child: Row(
    //                           children: [
    //                             Image.network(
    //                               '$imgBaseUrl/${data['image']}',
    //                               height: 65,
    //                               width: 65,
    //                             ),
    //                             Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 Text(
    //                                   data['name'].length>20?
    //                                   "   ${data['name'].substring(0, 20)}..":'   ${data['name']}',
    //                                   style: const TextStyle(fontWeight: FontWeight.w500),
    //                                 ),
    //                                 const SizedBox(
    //                                   height: 5,
    //                                 ),
    //                                 Row(
    //                                   children: [
    //                                     Text(
    //                                       '   ৳${data['sale_price'].toString().split('.')[0]}.${data['sale_price'].toString().split('.')[1].substring(0,1)}',
    //                                       style: TextStyle(
    //                                           color: MyColors.decrement,
    //                                           fontWeight: FontWeight.w500),
    //                                     ),
    //
    //                                     Text(
    //                                       '/${data['sub_text'] ?? ''}${data['unit_measure']['name']}',
    //                                       style: const TextStyle(fontSize: 12),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ],
    //                             ),
    //
    //                             const Spacer(),
    //
    //                             if(double.parse(data['current_stock'] != null ? data['current_stock'].toString().replaceAll('.000000', '') : '0') <= 0)...{
    //                               Container(
    //                                 //width: double.infinity,
    //                                 alignment: Alignment.center,
    //                                 padding: const EdgeInsets.all(8),
    //                                 margin:
    //                                 const EdgeInsets.only(top: 5),
    //                                 child: const Text(
    //                                   'Out Of Stock / Request',
    //                                   style: TextStyle(
    //                                       color: Colors.white,
    //                                       fontWeight: FontWeight.bold,
    //                                       fontSize: 12),
    //                                 ),
    //                                 decoration: BoxDecoration(
    //                                     borderRadius:
    //                                     BorderRadius.circular(5),
    //                                     color: MyColors.inactive),
    //                               )
    //                             }
    //
    //                             else...{
    //                               //Add To Cart
    //                               searchProduct[i].isSelected || data['unit_measure']['name'].toString().toLowerCase().contains('coming') ?
    //                               Container(
    //                                 padding: const EdgeInsets.all(5),
    //                                 margin: const EdgeInsets.only(top: 5),
    //                                 child: Text(data['unit_measure']['name'].toString().toLowerCase().contains('coming') ? 'Coming Soon' : 'Add To Cart',
    //                                   style: const TextStyle(
    //                                       color: Colors.white,
    //                                       fontWeight: FontWeight.bold,
    //                                       fontSize: 12
    //                                   ),),
    //                                 decoration: BoxDecoration(
    //                                     borderRadius: BorderRadius.circular(5),
    //                                     color:
    //                                     MyColors.inactive),
    //                               )
    //                                   :
    //                               GestureDetector(
    //                                   onTap: (){
    //                                     setState((){
    //                                       searchProduct[i].isSelected = !searchProduct[i].isSelected;
    //                                     });
    //                                     final carts =  AddtoCart(
    //                                       product_id      : data['id'],
    //                                       product_name    : '${data['name'] ?? ''}',
    //                                       unit_tag        : '${data['unit_measure']['name'] ?? ''}',
    //                                       image           : '${data['image'] ?? ''}',
    //                                       purchase_price  : double.parse('${data['purchase_price'] ?? 0.0}'),
    //                                       sale_price      : double.parse('${data['sale_price'] ?? 0.0}'),
    //                                       quantity        : 1,
    //                                       view_quantity   : '${data['sub_text'] ?? 1}',
    //                                       vat_amount      : double.parse('${data['vat'] ?? 0.0}'),
    //                                       discount_amount : double.parse('${data['current_discount'] ?? 0.0}'),
    //                                       maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
    //                                       current_stock   : double.parse('${data['current_stock'] ?? 0.0}'),
    //                                       weight          : double.parse('${data['weight'] ?? 0.0}'),
    //                                     );
    //                                     CartDatabase.instance.createCart(context, carts).then((value) {
    //                                       cartController.refreshCarts();
    //                                       cartController.totalPrice();
    //                                     });
    //                                   },
    //                                   child: Container(
    //                                     padding: const EdgeInsets.all(5),
    //                                     margin: const EdgeInsets.only(top: 5),
    //                                     child: const Text('Add To Cart',style: TextStyle(
    //                                         color: Colors.white,
    //                                         fontWeight: FontWeight.bold,
    //                                         fontSize: 12
    //                                     ),),
    //                                     decoration: BoxDecoration(
    //                                         borderRadius: BorderRadius.circular(5),
    //                                         color:
    //                                         MyColors.primary),
    //                                   )
    //                               )
    //                             }
    //                           ],
    //                         )),
    //                   );
    //                 }
    //             )
    //                 :
    //             const Center(
    //               child: CircularProgressIndicator(),
    //             );
    //
    //           }
    //       );
    //     }
    // );
  }

}