
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/test_con.dart';
import 'package:grocery/locals/database/db_helper.dart';
import 'package:grocery/locals/model/local_cart_model.dart';
import 'package:grocery/views/account/account_screen.dart';
import 'package:grocery/views/cart/CartScreen.dart';
import 'package:grocery/views/search/search_scr.dart';
import 'package:lottie/lottie.dart';

class MyComponents{

  //for snack bar
  mySnackBar(BuildContext context, String exp){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: MyColors.primary,
        content: Text(
          exp,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  //for wrong snackbar
  wrongSnackBar(BuildContext context, String exp){
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: MyColors.decrement,
        content: Text(
          exp,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal
          ),
        ),
      ),
    );
  }

  //for button
  button(BuildContext context, {text, press}){

    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.055,
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(48)),
        boxShadow: [
          BoxShadow(
            color: MyColors.primary,
            blurRadius: 5,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: MyColors.primary),
        onPressed: press,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                text,style: TextStyle(color: MyColors.background, fontSize: 18,fontWeight: FontWeight.w800),
              ),
            ),
            Positioned(
              right: 16,
              child: ClipOval(
                child: Container(
                  color: Colors.black.withOpacity(0.15),
                  // button color
                  child: SizedBox(
                      width: size.width * 0.074,
                      height: size.height * 0.035,
                      child: const Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 15,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //for input field
  inputText(BuildContext context, {controller, message, text, hintText, initialText, type,
    prefixIcon, visibility, obsecureText, maxLength, autoFillHints,readOnly, maxLines}) {
    return TextFormField(
      controller: controller,
      validator: (v){
        if(v!.isEmpty){
          return message != null ? 'Please Enter $message' : null;
        }else{
          return null;
        }
      },
      obscureText: obsecureText ?? false,
      keyboardType: type ?? null,
      textAlignVertical: TextAlignVertical.center,
      maxLength: maxLength ?? null,
      maxLines: maxLines ?? 1,
      autofillHints: [autoFillHints],
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        counter: const Offstage(),
        hintText: '$hintText',
        border: InputBorder.none,
        filled: true,
        prefixIcon: prefixIcon != null ?
        Icon(
          prefixIcon,
          size: 18,
        ) : null,
        suffixIcon: visibility ?? null,
      ),
    );
  }

  //for alert dialog
  exitAlertDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (context)=> AlertDialog(
          content: const Text('Are you sure you want to close application?'),
          actions: [
            TextButton(
                onPressed: ()=>Navigator.pop(context),
                child: const Text('NO')
            ),
            TextButton(
                onPressed: ()=>SystemNavigator.pop(),
                child: Text('Exit',style: TextStyle(color: MyColors.red),)
            ),
          ],
        )
    );
  }


  //show loader dialog
  showLoaderDialog(BuildContext context) {
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7),child:const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        // Future.delayed(const Duration(milliseconds: 1800), () {
        //   Navigator.of(context).pop(true);
        // });
        return alert;
      },
    );
  }

  //for back button
  Widget backButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const AccountScreen()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  //for button
  Widget submitButton(BuildContext context, String title) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: const Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [MyColors.primary, MyColors.secondary])),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  var cartController = Get.put(CartController());
  var testController = Get.put(TestController());

  //seconded appbar
  secondAppbar(BuildContext context, String title){
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Image.asset('assets/images/menu.png',height: 25,),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),

      title: Text(
        title,
        style: TextStyle(color: MyColors.primary,fontSize: 18,fontWeight: FontWeight.normal),
      ),
      titleSpacing: 0,
      actions: [
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
                  badgeContent: Obx(() => Text('${cartController.carts.length + testController.proList.length}',style: const TextStyle(color: Colors.white),)),
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

        const SizedBox(width: 10,),

        //for search
        IconButton(
            onPressed: ()=>showSearch(context: context, delegate: SearchScreen()),
            icon: Icon(Icons.search, color: MyColors.primary,)
        ),

      ],
    );
  }


  //LoaderDialogForCart
  loaderDialog(BuildContext context) {
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(margin: const EdgeInsets.only(left: 7),child:const Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        Future.delayed(const Duration(milliseconds: 400), () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CartScreen()));
        });
        return alert;
      },
    );
  }

}

//model for local data
class ContactModel {
  dynamic name;
  bool isSelected;
  ContactModel(this.name, this.isSelected);
}