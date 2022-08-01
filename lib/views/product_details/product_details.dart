import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:grocery/calculation/discount_price.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/configurations/my_sizes.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/controllers/test_con.dart';
import 'package:grocery/locals/database/db_helper.dart';
import 'package:grocery/locals/model/local_cart_model.dart';
import 'package:grocery/views/account/getx_auth/login_scr.dart';
import 'package:grocery/views/all_product/all_product_screen.dart';
import 'package:grocery/views/cart/CartScreen.dart';
import 'package:grocery/widgets/appbar_widget.dart';
import 'package:grocery/widgets/drawer_widget.dart';
import 'package:http/http.dart' as http;


class ProductDetailsScreen extends StatefulWidget {

  dynamic productId, image, name, price, getSalePrice, description, subText, unitMeasureName, purchasePrice,
      vat, discount, maximumOrder, currentStock, sku, categoryId, id, weight, productMeasurements;

  ProductDetailsScreen({this.image, this.name, this.price, this.getSalePrice, this.description, this.subText, this.unitMeasureName, this.categoryId,
  this.productId, this.purchasePrice, this.vat, this.discount, this.maximumOrder, this.currentStock, this.sku, this.id, this.weight, this.productMeasurements});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  var loginController = Get.put(LoginController());

  //for wish list
  bool favorite = false;

  addWishlist()async{
    var url = Uri.parse('$baseUrl/add-to-wishlist');
    var response = await http.post(url,headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${loginController.loginToken()}'
    },
        body: {
          'user_id'   : loginController.loginUserId().toString(),
          'product_id': widget.id.toString()
        }
    );

    int status = json.decode(response.body)['status'];

    switch(status){
      case 1:
        {
          MyComponents().mySnackBar(context, 'Add item to wishlist successful');
        }
    }
  }

  var visibleAddToCart = false;
  var cartController = Get.put(CartController());
  var relatedProduct = [];

  var addedProducts   = [];
  var testController  = Get.put(TestController());
  int allQuentity = 0;


  //for product Measurements
  dynamic productMeasurementsTitle,productMeasurementsValue,productMeasurementsSku;
  dynamic salePrice;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productMeasurementsTitle = widget.productMeasurements.length == 0 ? '' : widget.productMeasurements[0]['title'];
    productMeasurementsValue = widget.productMeasurements.length == 0 ? '1.0' : widget.productMeasurements[0]['value'];
    salePrice = double.parse(widget.price);
    // salePrice = double.parse(widget.price) * double.parse(productMeasurementsValue ?? '1.0');

    print('productMeasurementsTitle: $productMeasurementsTitle');
    print('productMeasurementsValue: $productMeasurementsValue');
    print('salePrice: $salePrice');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,

      appBar: MyAppBar(),

      drawer: DrawerWidget(),

      floatingActionButton: allQuentity < 1 && cartController.carts.isEmpty ?
      Container()
          :
      InkWell(
        onTap: (){
          for (var i = 0; i< testController.proList.length; i++){
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
        },
        child: Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(.9),
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
              const Icon(Icons.shopping_bag_outlined,color: Colors.white),

              const Text("  Review Order",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
              const Spacer(),
              Obx(() => Text('৳${double.parse(testController.totalPrice().toString())+double.parse(cartController.totalPrice().toString())} ',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ))
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(MySizes.bodyPadding),
        children: [
          //image
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //image
                Container(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Center(
                        child: widget.image != null ?
                        Image(
                          image: CachedNetworkImageProvider('$imgBaseUrl/${widget.image}'),
                          //image: NetworkImage('$imgBaseUrl/${widget.image}'),
                        ) : Image.asset('assets/images/picture.png'),
                      ),

                      favorite ? IconButton(
                          onPressed: (){
                            //if add wish list then remove
                          },
                          icon: Icon(Icons.favorite,color: MyColors.red,),
                      ): IconButton(
                        onPressed: (){

                          if(loginController.loginToken() == ''){
                            Navigator.push(context, MaterialPageRoute(builder: (_)=> LoginScreen()));
                          }else{
                            //add wish list
                            setState((){
                              favorite = true;
                            });
                            addWishlist();
                          }
                        },
                        icon: const Icon(Icons.favorite_outline,),
                      ),

                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                        ),
                      ],
                      color: Colors.white),
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(10),
                  height: 200,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '${widget.name}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          widget.productMeasurements.length ==0? Text(
                            '   ৳${widget.price}/${widget.subText ?? ''} ${widget.unitMeasureName ?? ''}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w300),
                          ):
                          Row(
                            children: [
                              Text('   ৳$salePrice/ '),
                              DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    hint: Text(
                                      productMeasurementsTitle,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          ),
                                    ),
                                    items: [

                                      for(int i = 0; i<widget.productMeasurements.length; i++)
                                      DropdownMenuItem(
                                        onTap: (){
                                          setState(() {
                                            productMeasurementsTitle = widget.productMeasurements[i]['title'];
                                            productMeasurementsValue = widget.productMeasurements[i]['value'];
                                            productMeasurementsSku = widget.productMeasurements[i]['sku'];
                                            // salePrice = double.parse(widget.productMeasurements[0]['value'])<1.0?double.parse(widget.price) * double.parse(productMeasurementsValue)*2:double.parse(widget.price) * double.parse(productMeasurementsValue);
                                            salePrice = double.parse(widget.getSalePrice) * double.parse(productMeasurementsValue);
                                          });
                                        },
                                        child: Text("${widget.productMeasurements[i]['title']}",style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),),
                                        value: "1 kg",
                                      ),

                                    ],
                                    onChanged: (v){
                                      setState((){
                                        productMeasurementsTitle = productMeasurementsTitle;
                                      });
                                    }
                                ),
                              )
                            ],
                          ),


                          Text(
                            '    SKU: ${widget.sku}\n',
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),

                    if(double.parse(widget.currentStock != null ? widget.currentStock.toString().replaceAll('.000000', '') : '0') <= 0)...{
                      Container(
                        //width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        margin:
                        const EdgeInsets.only(top: 5,right: 8),
                        child: const Text(
                          'Out Of Stock',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            color: MyColors.inactive),
                      )
                    }

                    else if(cartController.productId().toString().contains(widget.productId.toString()))...{
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 5),
                        child: Text(
                          'Already Added',
                          style: TextStyle(
                              color: MyColors.decrement,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            color: MyColors.decrement.withOpacity(.2)),
                      )
                    }

                    else...{
                      visibleAddToCart || widget.unitMeasureName.toString().toLowerCase().contains('coming') ?
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(right: 5),
                        child: Text(
                          //'Add To Cart',
                          widget.unitMeasureName.toString().toLowerCase().contains('coming') ? 'Coming Soon' :'Add To Cart',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.circular(5),
                            color: MyColors.inactive),
                      )
                          :
                      GestureDetector(
                        onTap: (){
                          setState((){
                            visibleAddToCart = !visibleAddToCart;
                          });
                          final carts =  AddtoCart(
                            product_id       : int.parse('${widget.productId}'),
                            product_name     : '${widget.name}',
                            unit_tag         : '${widget.unitMeasureName}',
                            image            : '${widget.image}',
                            purchase_price   : double.parse('${widget.purchasePrice}'),
                            sale_price       : double.parse('$salePrice'),
                            quantity         : 1,
                            view_quantity    : '${widget.subText ?? ''}',
                            vat_amount       : double.parse('${widget.vat ?? 0.0}'),
                            discount_amount  : double.parse('${widget.discount ?? 0.0}'),
                            maximum_quantity : double.parse('${widget.maximumOrder ?? 0.0}'),
                            current_stock    : double.parse('${widget.currentStock ?? 0.0}'),
                            weight           : double.parse('${widget.weight ?? 0.0}'),
                            measurement_title: '$productMeasurementsTitle',
                            measurement_value: '$productMeasurementsValue',
                            measurement_sku  : '$productMeasurementsSku'
                          );
                          CartDatabase.instance.createCart(context, carts).then((value) {
                            cartController.refreshCarts();
                            cartController.totalPrice();
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 5),
                          child: const Text('Add To Cart',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(5),
                              color: MyColors.secondary),
                        ),
                      )
                    }
                  ],
                )
              ],
            ),
          ),

          widget.description != null ? const SizedBox(height: 25,) : Container(),

          //about
          widget.description != null ? const Text("About this Product",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ) : Container(),
          const SizedBox(height: 5,),
          HtmlWidget(widget.description != null ? widget.description.toString() : ''),

          const SizedBox(height: 25,),

          const Text("Related Products",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5,),

          FutureBuilder(
              future: fetchRelatedProducts(widget.categoryId.toString(), widget.id.toString()),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return snapshot.hasData ? ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    itemBuilder: (_, i) {

                      var data = snapshot.data[i];
                      var price = discountPrice(salePrice: data['sale_price'], productMeasurement: data['product_measurements'], productMeasurementValue: data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0,
                          discounts: data['discount'], discountPercent: data['discount'] != null ? data['discount']['discount_percentage'] : 0.0 , discountEndDate: data['discount'] != null ?
                          data['discount']['end_date'] : null);

                      relatedProduct.add(ContactModel(data['name'], false));
                      addedProducts.add(AddProductModel(added: false,
                          product_name      : '${data['name']}',
                          unit_tag          : '${data['unit_measure']['name'] ?? ''}',
                          image             : '${data['image'] ?? ''}',
                          view_quantity     : '${data['sub_text'] ?? 1}',
                          product_id        : data['id'],
                          quantity          : 0,
                          purchase_price    : double.parse('${data['purchase_price'] ?? 0.0}'),
                        sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:price,
                          // sale_price        : double.parse(data['sale_price'] ?? 0.0),
                          vat_amount        : double.parse('${data['vat'] ?? 0.0}'),
                        discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:0.0,
                        // discount_amount   : double.parse('${data['current_discount'] ?? 0.0}'),
                          maximum_quantity  : double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                          current_stock     : double.parse('${data['current_stock'] ?? 0.0}'),
                          weight            : double.parse('${data['weight'] ?? 0.0}'),
                          measurement_sku   : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                          measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                          measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',
                      ));


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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: MyColors.shadow))),
                            child: Row(
                              children: [
                                //image
                                data['image'] != null ?
                                CachedNetworkImage(
                                  imageUrl: '$imgBaseUrl/${data['image']}',
                                  height: 65,
                                  width: 60,
                                ) :
                                Image.asset('assets/images/picture.png', height: 65, width: 60,),

                                const SizedBox(
                                  width: 8,
                                ),
                                //Product Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data['name'], style: const TextStyle(
                                          fontSize: 16),),
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
                                            '৳${price.toString().split(
                                                '.')[0]}.${price
                                                .toString()
                                                .split('.')[1].substring(0, 1)}',
                                            style: TextStyle(
                                                color: MyColors.decrement,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Expanded(
                                            child: Text(
                                              ' /${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : data['sub_text'] ?? ''}${data['unit_measure']['name']}',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),

                                if(double.parse(data['current_stock'] != null ? data['current_stock'].toString().replaceAll('.000000', '') : '0') <= 0)...{
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(8),
                                    margin:
                                    const EdgeInsets.only(top: 5),
                                    child: const Text(
                                      'Out Of Stock / Request',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        color: MyColors.inactive),
                                  )
                                }

                                else if(cartController.productId().toString().contains(data['id'].toString()))...{
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    margin: const EdgeInsets.only(top: 5),
                                    child:  Text(
                                      'Already Added',
                                      style: TextStyle(
                                          color: MyColors.decrement,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        color: MyColors.decrement.withOpacity(.2)),
                                  )
                                }

                                else ...{
                                    //Add To Cart

                                    addedProducts[i].added
                                        ? Row(
                                      children: [
                                        addedProducts[i].quantity > 0
                                            ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              addedProducts[i].quantity--;

                                              for (var j = 0; j <
                                                  testController.proList.length; j++) {
                                                if (testController.proList[j]
                                                    .product_id == data['id']) {
                                                  testController.proList.removeAt(j);
                                                  testController.proList.value.add(
                                                      AddProductModel(added: false,
                                                          product_name    : '${data['name']}',
                                                          unit_tag        : '${data['unit_measure']['name'] ?? ''}',
                                                          image           : '${data['image'] ?? ''}',
                                                          view_quantity   : '${data['sub_text'] ?? 1}',
                                                          product_id      : data['id'],
                                                          quantity        : addedProducts[i].quantity,
                                                          purchase_price  : double.parse('${data['purchase_price'] ?? 0.0}'),
                                                          // sale_price      : double.parse(data['sale_price'] ?? 0.0),
                                                        sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:price,
                                                        discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:0.0,
                                                        vat_amount      : double.parse('${data['vat'] ?? 0.0}'),
                                                          // discount_amount : double.parse('${data['sale_price'] ?? 0.0}') - price,
                                                          maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                                                          current_stock   : double.parse('${data['current_stock'] ?? 0.0}'),
                                                          weight          : double.parse('${data['weight'] ?? 0.0}'),
                                                        measurement_sku   : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                                                        measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                                                        measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',));
                                                }
                                              }
                                              if (addedProducts[i].quantity == 0) {
                                                for (var j = 0; j<testController.proList.length; j++) {
                                                  if (testController.proList[j].product_id == data['id']) {
                                                    testController.proList.removeAt(j);
                                                  }
                                                }
                                                addedProducts[i].added = false;
                                              }
                                            });
                                            allQuentity--;
                                          },
                                          icon: Container(
                                            height: 30,
                                            width: 30,
                                            decoration: BoxDecoration(
                                                color: MyColors.decrement.withOpacity(.2),
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              color: MyColors.decrement,
                                            ),
                                          ),
                                        )
                                            : Container(),

                                        addedProducts[i].quantity < 1
                                            ? const Text('')
                                            : Text(
                                          addedProducts[i].quantity.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500
                                          ),
                                        ),

                                        IconButton(
                                            onPressed: () {
                                              print('Plus 1');
                                              setState(() {
                                                if(addedProducts[i].quantity >= (double.parse(data['maximum_order_quantity']) <= 0 ?
                                                double.parse(data['current_stock'])
                                                    :
                                                double.parse(data['maximum_order_quantity'])) ){
                                                  MyComponents().wrongSnackBar(context, 'Out of Your Maximum Quantity');
                                                }

                                                else{
                                                  addedProducts[i].quantity++;
                                                  for (var j = 0; j<testController.proList.length; j++) {
                                                    if (testController.proList[j].product_id == data['id']) {
                                                      testController.proList.removeAt(j);
                                                      testController.proList.value.add(
                                                          AddProductModel(added: false,
                                                              product_name    : '${data['name']}',
                                                              unit_tag        : '${data['unit_measure']['name'] ?? ''}',
                                                              image           : '${data['image'] ?? ''}',
                                                              view_quantity   : '${data['sub_text'] ?? 1}',
                                                              product_id      : data['id'],
                                                              quantity        : addedProducts[i].quantity,
                                                              purchase_price  : double.parse('${data['purchase_price'] ?? 0.0}'),
                                                              // sale_price      : double.parse(data['sale_price'] ?? 0.0),
                                                              vat_amount      : double.parse('${data['vat'] ?? 0.0}'),
                                                              // discount_amount : double.parse('${data['sale_price'] ?? 0.0}') - price,
                                                            sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:price,
                                                            discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:0.0,
                                                              maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                                                              current_stock   : double.parse('${data['current_stock'] ?? 0.0}'),
                                                              weight          : double.parse('${data['weight'] ?? 0.0}'),
                                                            measurement_sku   : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                                                            measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                                                            measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',));
                                                    }
                                                  }
                                                }
                                              });
                                              allQuentity++;
                                            },
                                            icon: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                  color: MyColors.increment.withOpacity(0.2),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: MyColors.increment,
                                              ),
                                            )),
                                      ],
                                    )
                                        : data['unit_measure']['name'].toString().toLowerCase().contains('coming')
                                        ? Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.only(top: 5),
                                      child: const Text('Coming Soon',
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: MyColors.inactive),
                                    )
                                        : IconButton(
                                        onPressed: () {
                                          print('Plus: 2');
                                          setState(() {
                                            if(addedProducts[i].quantity >= (double.parse(data['maximum_order_quantity']) <= 0 ?
                                            double.parse(data['current_stock'])
                                                :
                                            double.parse(data['maximum_order_quantity']))){
                                              MyComponents().wrongSnackBar(context, 'Out of Your Maximum Quantity');
                                            }

                                            else{
                                              addedProducts[i].quantity++;
                                              addedProducts[i].added = true;
                                              testController.proList.value.add(
                                                  AddProductModel(added: false,
                                                      product_name    : '${data['name']}',
                                                      unit_tag        : '${data['unit_measure']['name'] ?? ''}',
                                                      image           : '${data['image'] ?? ''}',
                                                      view_quantity   : '${data['sub_text'] ?? 1}',
                                                      product_id      : data['id'],
                                                      quantity        : addedProducts[i].quantity,
                                                      purchase_price  : double.parse('${data['purchase_price'] ?? 0.0}'),
                                                      // sale_price      : double.parse(data['sale_price'] ?? 0.0),
                                                      vat_amount      : double.parse('${data['vat'] ?? 0.0}'),
                                                    sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:price,
                                                    discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:0.0,
                                                      // discount_amount : double.parse('${data['sale_price'] ?? 0.0}') - price,
                                                      maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                                                      current_stock   : double.parse('${data['current_stock'] ?? 0.0}'),
                                                      weight          : double.parse('${data['weight'] ?? 0.0}'),
                                                    measurement_sku   : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                                                    measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                                                    measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',));
                                            }

                                          });
                                          allQuentity++;
                                        },
                                        icon: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              color: MyColors.increment.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: MyColors.increment,
                                          ),
                                        ))
                                  }

                              ],
                            )),
                      );
                    }): const Center(child: CircularProgressIndicator());
              }
          )
        ],
      ),
    );
  }
}
