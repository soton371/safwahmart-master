import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/calculation/discount_price.dart';
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


class AllProductScreen extends StatefulWidget {
  //const AllProductScreen({Key? key}) : super(key: key);

  String type, slug;
  AllProductScreen({required this.type,required this.slug});

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {

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

  Future fetch() async{

    const limit = 20;

    var url = Uri.parse('$baseUrl/category-or-brand-wise-products?type=${widget.type}&slug=${widget.slug}&page=$page');
    var res = await http.get(url);

    if(res.statusCode == 200){

      final List newItems = json.decode(res.body)['products']['data'];

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
    fetch();

    scrollController.addListener(() {
      if(scrollController.position.maxScrollExtent==scrollController.offset){
        fetch();
      }
    });
    // TODO: implement initState
    super.initState();

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

          //add by stephen
          Get.to(CartScreen());
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
              const Icon(Icons.shopping_bag_outlined,color: Colors.white,),

              const Text("  Review Order",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16
                ),
              ),
              const Spacer(),
              Obx(() => Text('৳${double.parse(testController.totalPrice().toString()) + double.parse(cartController.totalPrice().toString())} ',
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

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: scrollController,
                itemCount: items.length + 1,
                itemBuilder: (_, i) {
                  if (i < items.length) {
                    var data = items[i];
                    categoryProduct.add(ContactModel(data['name'], false));

                    var finalPrice = discountPrice(salePrice: data['sale_price'], productMeasurement: data['product_measurements'], productMeasurementValue: data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0,
                        discounts: data['discount'], discountPercent: data['discount'] != null ? data['discount']['discount_percentage'] : 0.0 , discountEndDate: data['discount'] != null ?
                        data['discount']['end_date'] : null);

                    addedProducts.add(AddProductModel(
                      added: false,
                      product_name: '${data['name']}',
                      unit_tag: '${data['unit_measure']['name'] ?? ''}',
                      image: '${data['image'] ?? ''}',
                      view_quantity: '${data['sub_text'] ?? 1}',
                      product_id: data['id'], quantity: 0,
                      purchase_price: double.parse('${data['purchase_price'] ?? 0.0}'),
                      // sale_price: double.parse('${data['sale_price'] ?? 0.0}'),
                      vat_amount: double.parse('${data['vat'] ?? 0.0}'),
                      // discount_amount   : double.parse('${data['sale_price'] ?? 0.0}') - finalPrice,
                      sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > finalPrice ?double.parse('${data['sale_price'] ?? 0.0}') - finalPrice:finalPrice,
                      discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > finalPrice ?double.parse('${data['sale_price'] ?? 0.0}') - finalPrice:0.0,
                      maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                      current_stock: double.parse('${data['current_stock'] ?? 0.0}'),
                      weight: double.parse('${data['weight'] ?? 0.0}'),
                      measurement_sku: '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                      measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                      measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',));

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  image               : data['image'],
                                  productId           : data['id'],
                                  name                : data['name'],
                                  getSalePrice        : data['sale_price'],
                                  price               : '${finalPrice.toString().split('.')[0]}.${finalPrice.toString().split('.')[1].toString().substring(0, 1)}',
                                  description         : data['description'],
                                  subText             : data['sub_text'],
                                  unitMeasureName     : data['unit_measure']['name'],
                                  purchasePrice       : data['purchase_price'],
                                  vat                 : data['vat'],
                                  discount            : data['discount'],
                                  maximumOrder        : data['maximum_order_quantity'],
                                  currentStock        : data['current_stock'],
                                  sku                 : data['sku'],
                                  categoryId          : data['category_id'],
                                  id                  : data['id'],
                                  weight              : data['weight'],
                                  productMeasurements : data['product_measurements'],
                                )));
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: MyColors.shadow))),
                          child: Row(
                            children: [
                              //image
                              CachedNetworkImage(
                                imageUrl: '$imgBaseUrl/${data['image']}',
                                height: 65,
                                width: 60,
                              ),

                              const SizedBox(
                                width: 8,
                              ),
                              //Product Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['name'],style: const TextStyle(fontSize: 16),),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > finalPrice ?
                                        Text(
                                            '  ৳${data['sale_price']} ',
                                            style: TextStyle(
                                                color: MyColors.inactive,
                                                fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.lineThrough)
                                        ) : const Text(''),
                                        Text(
                                          '৳${finalPrice.toString().split('.')[0]}.${finalPrice.toString().split('.')[1].substring(0, 1)}',
                                          style: TextStyle(
                                              color: MyColors.decrement,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Expanded(
                                          child: Text(
                                            ' /${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : data['sub_text'] ?? ''} ${data['product_measurements'].length > 0 ?'':data['unit_measure']['name']}',
                                            // ' /${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : data['sub_text'] ?? ''}${data['unit_measure']['name']}',
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

                              if (double.parse(data['current_stock'] != null
                                  ? data['current_stock']
                                  .toString()
                                  .replaceAll('.000000', '')
                                  : '0') <=
                                  0) ...{
                                Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (loginController.loginToken() ==
                                            '') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                 LoginScreen()),
                                          );
                                        } else {
                                          productRequest(
                                              context: context,
                                              customerId: loginController
                                                  .loginCustomerId(),
                                              productId: data['product_id'],
                                              productVariationId: '',
                                              token:
                                              loginController.loginToken());
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.only(top: 5),
                                        child: const Text(
                                          'Request',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            color: MyColors.inactive),
                                      ),
                                    ),
                                    Text(
                                      'Out of Stock',
                                      style: TextStyle(
                                          color: MyColors.decrement,
                                          fontSize: 12),
                                    )
                                  ],
                                ),
                              }

                              else if(cartController.productId().toString().contains(data['id'].toString()))...{
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    'Already Cart',
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

                              //for add and update
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

                                            for(var j = 0; j<testController.proList.length; j++){
                                              if(testController.proList[j].product_id == data['id']){
                                                testController.proList.removeAt(j);
                                                testController.proList.value.add(AddProductModel(
                                                  added: false,
                                                  product_name: '${data['name']}',
                                                  unit_tag: '${data['unit_measure']['name'] ?? ''}',
                                                  image: '${data['image'] ?? ''}',
                                                  view_quantity: '${data['sub_text'] ?? 1}',
                                                  product_id: data['id'],
                                                  quantity: addedProducts[i].quantity,
                                                  purchase_price: double.parse('${data['purchase_price'] ?? 0.0}'),
                                                  // sale_price: double.parse(data['sale_price'] ?? 0.0),
                                                  sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > finalPrice ?double.parse('${data['sale_price'] ?? 0.0}') - finalPrice:finalPrice,
                                                  discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > finalPrice ?double.parse('${data['sale_price'] ?? 0.0}') - finalPrice:0.0,
                                                  vat_amount: double.parse('${data['vat'] ?? 0.0}'),
                                                  // discount_amount   : double.parse('${data['sale_price'] ?? 0.0}') - finalPrice,
                                                  maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                                                  current_stock: double.parse('${data['current_stock'] ?? 0.0}'),
                                                  weight: double.parse('${data['weight'] ?? 0.0}'),
                                                  measurement_sku : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                                                  measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                                                  measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',));                                                        }
                                            }
                                            if(addedProducts[i].quantity == 0){
                                              for(var j = 0; j<testController.proList.length; j++){
                                                if(testController.proList[j].product_id == data['id']){
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
                                          : Text(addedProducts[i].quantity.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500
                                        ),
                                      ),

                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              addedProducts[i].quantity++;
                                              for(var j = 0; j<testController.proList.length; j++){
                                                if(testController.proList[j].product_id == data['id']){
                                                  testController.proList.removeAt(j);
                                                  testController.proList.value.add(AddProductModel(
                                                    added: false,
                                                    product_name: '${data['name']}',
                                                    unit_tag: '${data['unit_measure']['name'] ?? ''}',
                                                    image: '${data['image'] ?? ''}',
                                                    view_quantity: '${data['sub_text'] ?? 1}',
                                                    product_id: data['id'],
                                                    quantity: addedProducts[i].quantity,
                                                    purchase_price: double.parse('${data['purchase_price'] ?? 0.0}'),
                                                    // sale_price        : double.parse(data['sale_price'] ?? 0.0),
                                                    sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > finalPrice ?double.parse('${data['sale_price'] ?? 0.0}') - finalPrice:finalPrice,
                                                    discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > finalPrice ?double.parse('${data['sale_price'] ?? 0.0}') - finalPrice:0.0,
                                                    vat_amount: double.parse('${data['vat'] ?? 0.0}'),
                                                    // discount_amount   : double.parse('${data['sale_price'] ?? 0.0}') - finalPrice,
                                                    maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                                                    current_stock: double.parse('${data['current_stock'] ?? 0.0}'),
                                                    weight: double.parse('${data['weight'] ?? 0.0}'),
                                                    measurement_sku: '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                                                    measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                                                    measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',));                                                        }
                                              }
                                            });
                                            allQuentity++;
                                            print('Plus 1');
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
                                    padding:
                                    const EdgeInsets.all(5),
                                    margin: const EdgeInsets.only(
                                        top: 5),
                                    child: const Text(
                                      'Coming Soon',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                          FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(
                                            5),
                                        color: MyColors.inactive),
                                  )
                                      : IconButton(
                                      onPressed: () {

                                        setState(() {
                                          addedProducts[i].quantity++;
                                          allQuentity++;
                                          addedProducts[i].added = true;
                                          testController.proList.value.add(AddProductModel(
                                            added: false,
                                            product_name: '${data['name']}',
                                            unit_tag: '${data['unit_measure']['name'] ?? ''}',
                                            image: '${data['image'] ?? ''}',
                                            view_quantity: '${data['sub_text'] ?? 1}',
                                            product_id: data['id'],
                                            quantity:  addedProducts[i].quantity,
                                            purchase_price: double.parse('${data['purchase_price'] ?? 0.0}'),
                                            // sale_price        : double.parse(data['sale_price'] ?? 0.0),
                                            sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > finalPrice ?double.parse('${data['sale_price'] ?? 0.0}') - finalPrice:finalPrice,
                                            discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > finalPrice ?double.parse('${data['sale_price'] ?? 0.0}') - finalPrice:0.0,
                                            vat_amount: double.parse('${data['vat'] ?? 0.0}'),
                                            // discount_amount   : double.parse('${data['sale_price'] ?? 0.0}') - finalPrice,
                                            maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                                            current_stock: double.parse('${data['current_stock'] ?? 0.0}'),
                                            weight: double.parse('${data['weight'] ?? 0.0}'),
                                            measurement_sku: '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                                            measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                                            measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',));
                                        });
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
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: hasMore
                            ? const CircularProgressIndicator()
                            : const Text('No more products are available'),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}


class AddProductModel {
  String product_name, unit_tag, image, view_quantity, measurement_sku, measurement_title, measurement_value;
  bool added;
  int product_id, quantity;
  double purchase_price, sale_price, vat_amount, discount_amount, maximum_quantity, current_stock, weight;
  AddProductModel({required this.added, required this.product_name, required this.unit_tag, required this.image, required this.view_quantity,
    required this.product_id, required this.quantity, required this.purchase_price, required this.sale_price, required this.vat_amount,
    required this.discount_amount, required this.maximum_quantity, required this.current_stock, required this.weight, required this.measurement_sku,
    required this.measurement_title, required this.measurement_value});
}

