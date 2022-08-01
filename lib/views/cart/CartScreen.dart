import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/locals/database/db_helper.dart';
import 'package:grocery/views/account/getx_auth/login_scr.dart';
import 'package:grocery/views/checkout/delivery_screen.dart';
import 'package:grocery/views/front_screen.dart';
import 'package:grocery/widgets/appbar_widget.dart';
import 'package:grocery/widgets/drawer_widget.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  var cartController = Get.put(CartController());
  var loginController = Get.put(LoginController());

  checkoutPage() async {
    if (loginController.loginToken() == '') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(where: 'CartScreen',)),
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => DeliveryScreen()),
      );
    }
  }

  @override
  void initState() {
    cartController.refreshCarts();
    cartController.carts;
    loginController.refreshLogin();
    loginController.login;
    super.initState();
  }

  ///Delete Product From Cart
  deleteProduct({productName, productId, index}){
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                    text:
                    'Are you sure that you want to delete '),
                TextSpan(
                  text:
                  '$productName',
                  style: TextStyle(
                      fontWeight:
                      FontWeight.bold,
                      color: MyColors.red),
                ),
                const TextSpan(
                    text:
                    ' from your cart?'),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () =>
                    Navigator.pop(context),
                child: const Text('NO')),
            TextButton(
                onPressed: () {
                  CartDatabase.instance
                      .deleteCart(productId)
                      .then((value) =>
                      cartController
                          .refreshCarts());
                  setState(() {
                    cartController.carts.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  'YES',
                  style: TextStyle(
                      color: MyColors.red),
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        // Get.to(const FrontScreen());
        // Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => FrontScreen()));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>FrontScreen()));
        return true;
      },

      child: Scaffold(
        appBar: MyAppBar(),
        drawer: DrawerWidget(),
        body: cartController.carts.length > 0
            ? ListView.builder(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                itemCount: cartController.carts.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, i) {
                  var data = cartController.carts[i];

                  return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 5),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cartController.carts[i].image != null
                                ?
                                CachedNetworkImage(imageUrl: '$imgBaseUrl/${cartController.carts[i].image}',height: 50,width: 50,)

                                : Image.asset(
                                    'assets/images/applogo.png',
                                    height: 50,
                                    width: 50,
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text('${cartController.carts[i].product_name ?? ''} - '
                                        '${cartController.carts[i].measurement_title != '' && cartController.carts[i].measurement_title != '0' && cartController.carts[i].measurement_title != '1.0' ? cartController.carts[i].measurement_title : cartController.carts[i].view_quantity}'
                                        '${cartController.carts[i].measurement_title != '' && cartController.carts[i].measurement_title != '0' && cartController.carts[i].measurement_title != '1.0' ?'':cartController.carts[i].unit_tag}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    ),
                                  ),

                                  Text(
                                    "৳${cartController.carts[i].sale_price - cartController.carts[i].discount_amount}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            //for delete and increase
                            IconButton(
                                onPressed: () {
                                  deleteProduct(productName: cartController.carts[i].product_name, productId: data.id, index: i);
                                },
                              icon: Image.asset('assets/images/delete.png',height: 20,color: MyColors.red,),
                            ),
                            // cartController.carts[i].quantity > 1
                            //     ?
                            IconButton(
                                    onPressed: () {
                                      setState(() {
                                        int quantity = cartController.carts[i].quantity;
                                        cartController.refreshCarts();
                                        cartController.carts[i].quantity == 0
                                            ? quantity
                                            : quantity--;
                                        quantity > 0 ?
                                        CartDatabase.instance.updateCart(data.id, quantity).then((value) => cartController.refreshCarts())
                                        :
                                        deleteProduct(productName: cartController.carts[i].product_name, productId: data.id, index: i);
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                      color: Colors.black54,
                                    )),
                                // : Container(),
                            Obx(() => Text(
                                cartController.carts[i].quantity.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    int quantity = cartController.carts[i].quantity;
                                    cartController.refreshCarts();
                                    quantity++;

                                    if (quantity > (cartController.carts[i].maximum_quantity <= 0
                                                ? cartController.carts[i].current_stock
                                                : cartController.carts[i].maximum_quantity) ||
                                        quantity > cartController.carts[i].current_stock) {
                                      MyComponents().wrongSnackBar(context, 'Out of Your Maximum Quantity');
                                    } else {
                                      CartDatabase.instance.updateCart(data.id, quantity).then((value) => cartController.refreshCarts());}
                                  });
                                },
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.black54,
                                ))
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                })
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/gift.png',height: 100,),
                    const Text(
                      '\nNo Item\'s Available',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
        floatingActionButton: cartController.carts.length > 0
            ? Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const FrontScreen())),
                      child: const Text("Continue shopping",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red.withOpacity(.9),
                          shape: const StadiumBorder(), elevation: 0),
                    ),

                    //const Spacer(),
                    ElevatedButton(
                      onPressed: () => checkoutPage(),
                      child: Obx(
                        () => Text(
                          "Confirm ৳${cartController.totalPrice()}",
                            style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.withOpacity(.9),
                          shape: const StadiumBorder(), elevation: 0),
                    ),
                  ],
                ),
              )
            : Container(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
