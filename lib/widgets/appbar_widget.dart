
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/configurations/my_sizes.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/test_con.dart';
import 'package:grocery/locals/database/db_helper.dart';
import 'package:grocery/locals/model/local_cart_model.dart';
import 'package:grocery/views/cart/CartScreen.dart';
import 'package:grocery/views/front_screen.dart';
import 'package:grocery/views/search/search_scr.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget{

  var cartController = Get.put(CartController());
  var testController  = Get.put(TestController());


  @override
  Size get preferredSize => const Size.fromHeight(55);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Image.asset('assets/images/menu.png',height: 25,),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),

      title: InkWell(
        onTap: ()=>showSearch(context: context, delegate: SearchScreen()),
        child: Container(
          height: 38,
          width: double.infinity,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(MySizes.textFieldBorderRadius),
            color: MyColors.shadow,
          ),
          child: Text('Search here',
          style: TextStyle(
            fontSize: 14,
            color: MyColors.inactive
          ),
          ),
        ),
      ),
      actions: [
        const SizedBox(width: 8,),
        Column(
          children: [
            const SizedBox(height: 18,),
            InkWell(
                onTap: (){
                  for (var i = 0; i< testController.proList.length; i++){
                    print('Discount Amount: ${testController.proList[i].discount_amount}');
                    print('Discount Amount: ${testController.proList[i].sale_price}');
                    final carts =  AddtoCart(
                      product_id        : testController.proList[i].product_id,
                      product_name      : testController.proList[i].product_name,
                      unit_tag          : testController.proList[i].unit_tag,
                      image             : testController.proList[i].image,
                      purchase_price    : testController.proList[i].purchase_price,
                      sale_price        : testController.proList[i].sale_price,
                      quantity          : testController.proList[i].quantity,
                      view_quantity     : testController.proList[i].view_quantity,
                      vat_amount        : testController.proList[i].vat_amount,
                      discount_amount   : testController.proList[i].discount_amount,
                      maximum_quantity  : testController.proList[i].maximum_quantity,
                      current_stock     : testController.proList[i].current_stock,
                      weight            : testController.proList[i].weight,
                      measurement_sku   : testController.proList[i].measurement_sku,
                      measurement_title : testController.proList[i].measurement_title,
                      measurement_value : testController.proList[i].measurement_value,
                    );
                    CartDatabase.instance.createCart(context, carts, pass: 'true').then((value) {
                      cartController.refreshCarts();
                      cartController.totalPrice();
                    });
                  }
                  testController.proList.removeRange(0, testController.proList.length);
                  MyComponents().loaderDialog(context);
                  // Navigator.push(context, MaterialPageRoute(builder: (_)=> CartScreen()));
                  // Navigator.of(context,
                  //     rootNavigator: false)
                  //     .push(MaterialPageRoute(builder: (_)=>CartScreen()));
                },
                child: Badge(
                  badgeContent: Obx(() => Text('${cartController.carts.length+testController.proList.length}',style: const TextStyle(color: Colors.white),)),
                  child: Icon(Icons.add_shopping_cart_outlined, color: MyColors.primary,size: 22,),
                )
            ),
            // Obx(() => Text('৳ ${controller.totalPrice()}',
            //   style: TextStyle(
            //       color: MyColors.primary,
            //       fontSize: 8
            //   ),
            // ))
            Obx(() => Text('৳${double.parse(testController.totalPrice().toString())+double.parse(cartController.totalPrice().toString())} ',
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
    );
  }
}


