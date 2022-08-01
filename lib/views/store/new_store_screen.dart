import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/calculation/discount_price.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/configurations/select_location.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/date_time.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/locals/database/db_helper.dart';
import 'package:grocery/locals/database/home_db.dart';
import 'package:grocery/locals/database/login_db.dart';
import 'package:grocery/locals/model/home_model.dart';
import 'package:grocery/locals/model/local_cart_model.dart';
import 'package:grocery/locals/model/login_model.dart';
import 'package:grocery/models/get_area.dart';
import 'package:grocery/views/account/getx_auth/login_scr.dart';
import 'package:grocery/views/all_product/all_product_screen.dart';
import 'package:grocery/views/product_details/product_details.dart';
import 'package:grocery/widgets/appbar_widget.dart';
import 'package:grocery/widgets/drawer_widget.dart';
import 'package:http/http.dart' as http;

class NewStoreScreen extends StatefulWidget {
  const NewStoreScreen({Key? key}) : super(key: key);

  @override
  State<NewStoreScreen> createState() => _NewStoreScreenState();
}

class _NewStoreScreenState extends State<NewStoreScreen> {
  var categoryProduct = [];
  var addedProducts   = [];
  int allQuentity = 0;

  ///controllers
  var cartController  = Get.put(CartController());
  var loginController = Get.put(LoginController());
  var locController   = Get.put(LocationController());
  var timeController   = Get.put(DateTimeController());


  ///for products request
  var productRequestList = [];

  ///for pagination
  final scrollController = ScrollController();
  List items = [];
  int page = 1;
  bool hasMore = true;
  dynamic type = 'category', slug = 'fresh-vegetables';
  var sum = 0.0;
  Future fetch() async {
    const limit = 20;

    var url = Uri.parse('$baseUrl/search-products?page=$page');
    var res = await http.get(url);

    if (res.statusCode == 200) {
      final List newItems = json.decode(res.body)['products']['data'];

      setState(() {
        page++;
        if (newItems.length < limit) {
          hasMore = false;
        }
        items.addAll(newItems.map((e) {
          return e;
        }));
      });
    }
  }
  List<Home>? homes;
  var isLoading   = false;

  Future refreshHome() async{
    setState(() => isLoading = true);
    homes = await HomeDatabase.instance.viewHome();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    fetch();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        fetch();
      }
    });
    // TODO: implement initState
    super.initState();
    refreshHome();
  }

  @override
  void dispose() {
    scrollController.dispose();
    HomeDatabase.instance.close();
    super.dispose();
  }

  ///test location
  var areaValue, areaId;
  List areaList = [];
  Future<dynamic> Areas(districtId)async {
    String url = '$baseUrl/get-areas/${districtId ?? 58}';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      GetAreaList area = getAreaListFromJson(response.body);
      List areaData = area.data.areas;
      for (var i = 0; i <= areaData.length; i++) {
        setState(() {
          areaList = areaData;
        });
      }
      return areaList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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


      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children:  [
                ///for you
                const Text(
                  '  For you',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ///select city section
                const Spacer(),

                InkWell(
                  onTap: (){
                    showDialog(
                        context: context,
                        barrierDismissible: false,

                        builder: (context)=> AlertDialog(
                          insetPadding: const EdgeInsets.all(12),
                          content:  SizedBox(
                            height: 350,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [

                                ///for district
                                Obx(() => Container(
                                  margin: const EdgeInsets.only(bottom: 10, top: 30),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: MyColors.shadow
                                  ),
                                  child: DropdownSearch<String>(
                                    dropdownSearchBaseStyle: const TextStyle(fontSize: 18),
                                    popupShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    dropdownSearchDecoration: const InputDecoration(
                                      hintStyle: TextStyle(fontSize: 16),
                                      hintText: 'Select District *',
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left: 10, top: 12),
                                    ),
                                    items: [
                                      for(int i=0; i<locController.districtList.length;i++)...{
                                        locController.districtList[i].name.toString()
                                      },
                                    ],
                                    onChanged: (newVal) {
                                      if(loginController.loginToken() == ''){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                      }

                                      else{
                                        setState(() {
                                          locController.districtValue.value = newVal.toString();
                                          int index = locController.districtList.indexWhere((element) => element.name == newVal);
                                          Areas(locController.districtList.elementAt(index).id);
                                          locController.districtId.value      = locController.districtList.elementAt(index).id;
                                          locController.districtValue.value   = locController.districtList.elementAt(index).name;
                                          cartController.deliveryCharge.value = double.parse(locController.districtList.elementAt(index).shippingCost);
                                        });
                                      }
                                    },
                                  ),
                                ),),

                                ///for area
                                Container(
                                  margin: const EdgeInsets.only(bottom: 30, top: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: MyColors.shadow
                                  ),
                                  child: DropdownSearch<String>(
                                    dropdownSearchBaseStyle: const TextStyle(fontSize: 18),
                                    popupShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    dropdownSearchDecoration: const InputDecoration(
                                      hintStyle: TextStyle(fontSize: 16),
                                      hintText: 'Select Area *',
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left: 10, top: 12),
                                    ),
                                    items: [
                                      for(int i=0; i < areaList.length;i++)...{
                                        areaList[i].name.toString()
                                      },
                                    ],
                                    onChanged: (newVal) {
                                      setState(() {
                                        areaValue = newVal.toString();
                                        int index = areaList.indexWhere((element) => element.name == newVal);

                                        areaId      = areaList.elementAt(index).id;
                                        areaValue   = areaList.elementAt(index).name;
                                      });
                                    },
                                  ),
                                ),

                                ///for date
                                InkWell(
                                  onTap: (){
                                    timeController.selectDate(context);
                                    setState((){});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    height: 45,
                                    alignment: Alignment.centerLeft,
                                    color: MyColors.shadow,
                                    child: Row(
                                      children: [
                                        Icon(Icons.calendar_today_outlined,color: Colors.black.withOpacity(0.5),size: 16,),
                                        const SizedBox(width: 15,),
                                        Obx(() => Text(timeController.dateIs == 'true' ? "${timeController.selectDates}".split(' ')[0] : 'Select Date *', style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black.withOpacity(0.6)
                                        ),),),
                                      ],
                                    ),
                                  ),
                                ),

                                ///select time
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8, top: 30),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: MyColors.shadow
                                  ),
                                  child: DropdownSearch<String>(
                                    dropdownSearchBaseStyle: const TextStyle(fontSize: 18),
                                    popupShape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    mode: Mode.DIALOG,
                                    showSearchBox: true,
                                    dropdownSearchDecoration: const InputDecoration(
                                      hintStyle: TextStyle(fontSize: 16),
                                      hintText: 'Select Time *',
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left: 10, top: 12),
                                    ),
                                    items: [
                                      for(int i=0; i < timeController.timeList.length;i++)...{
                                        '${timeController.timeList[i]['starting_time']} - ${timeController.timeList[i]['ending_time']}'
                                      },
                                    ],
                                    onChanged: (newVal) {
                                      setState(() {
                                        timeController.selectTime = newVal.toString();
                                        int index = timeController.timeList.indexWhere((element) => '${element['starting_time']} - ${element['ending_time']}' == newVal);
                                        timeController.timeId      = timeController.timeList[index]['id'];
                                        timeController.selectTime  = '${timeController.timeList.elementAt(index)['starting_time'] - timeController.timeList.elementAt(index)['ending_time']}';
                                      });
                                    },
                                  ),
                                ),

                              ],
                            ),
                          ),

                          actions: [
                            ///Cancel
                            TextButton(
                                onPressed: ()=>Navigator.pop(context),
                                child: Text('Cancel', style: TextStyle(color: MyColors.red),)
                            ),

                            ///Save
                            TextButton(
                                onPressed: () {
                                  final login = Login(
                                    token       : '${loginController.loginToken() ?? ''}',
                                    name        : '${loginController.loginName() ?? ''}',
                                    email       : '${loginController.loginEmail() ?? ''}',
                                    phone       : '${loginController.loginPhone() ?? ''}',
                                    user_id     : int.parse(loginController.loginUserId() ?? 0),
                                    customer_id : int.parse(loginController.loginCustomerId() ?? 0),
                                    district_id : int.parse('${locController.districtId}'),
                                    district    : '${locController.districtValue}',
                                    area_id     : areaId ?? int.parse('${loginController.loginAreaId() ?? '0'}'),
                                    area        : areaValue ?? '${loginController.loginArea() ?? ''}',
                                    address     : '${loginController.loginAddress() ?? ''}',
                                    zip_code    : '${loginController.loginZipCode()}',
                                  );

                                  LoginDatabase.instance.createLogin(context, login).then((value) {
                                    loginController.refreshLogin();
                                    loginController.loginToken();
                                    loginController.loginName();
                                    loginController.loginEmail();
                                    loginController.loginPhone();
                                    loginController.loginDistrictId();
                                    loginController.loginDistrict();
                                    loginController.loginAreaId();
                                    loginController.loginArea();
                                    loginController.loginAddress();
                                    loginController.loginZipCode();
                                    loginController.loginUserId();
                                    loginController.loginCustomerId();
                                    Navigator.pop(context);
                                  });
                                },
                                child: const Text('Save',)
                            ),
                          ],
                        )
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, right: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 18,),
                        Text(' ${locController.districtValue}, ${areaValue ?? loginController.loginArea()}'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: ApiHome()
          ),
        ],
      ),
    );
  }

  Widget ApiHome(){
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        itemCount: items.length + 1,
        itemBuilder: (_, i) {
          if(items.isNotEmpty) {
            if (i < items.length) {
              var data = items[i];
              var price = discountPrice(salePrice: data['sale_price'], productMeasurement: data['product_measurements'], productMeasurementValue: data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0,
                  discounts: data['discount'], discountPercent: data['discount'] != null ? data['discount']['discount_percentage'] : 0.0 , discountEndDate: data['discount'] != null ?
                  data['discount']['end_date'] : null);

              //for products request
              productRequestList.add(ProductRequestConst(request: false));
              categoryProduct.add(ContactModel(data['name'], false));
              addedProducts.add(AddProductModel(added: false,
                product_name      : '${data['name']}',
                unit_tag          : '${data['unit_measure']['name'] ?? ''}',
                image             : '${data['image'] ?? ''}',
                view_quantity     : '${data['sub_text'] ?? ''}',
                product_id        : data['id'],
                quantity          : 0,
                purchase_price    : double.parse('${data['purchase_price'] ?? 0.0}'),
                sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:price,
                // sale_price        : double.parse(data['sale_price'] ?? 0.0),
                vat_amount        : double.parse('${data['vat'] ?? 0.0}'),
                // discount_amount   : double.parse('${data['sale_price'] ?? 0.0}') - price,
                discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:0.0,
                maximum_quantity  : double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                current_stock     : double.parse('${data['current_stock'] ?? 0.0}'),
                weight            : double.parse('${data['weight'] ?? 0.0}'),
                measurement_sku   : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',
              ));



              final home =  Home(
                  product_id        : data['id'],
                  product_name      : '${data['name']}',
                  unit_tag          : '${data['unit_measure']['name'] ?? ''}',
                  image             : '${data['image'] ?? ''}',
                  purchase_price    : double.parse('${data['purchase_price'] ?? 0.0}'),
                  sale_price        : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:price,
                  // sale_price        : double.parse(data['sale_price'] ?? 0.0),
                  description       : '${data['description']}',
                  view_quantity     : '${data['sub_text'] ?? ''}',
                  vat_amount        : double.parse('${data['vat'] ?? 0.0}'),
                  discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:0.0,
                  // discount_amount   : double.parse('${data['sale_price'] ?? 0.0}') - price,
                  maximum_quantity  : double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                  current_stock     : double.parse('${data['current_stock'] ?? 0.0}'),
                  weight            : double.parse('${data['weight'] ?? 0.0}'),
                  sku               : '${data['sku'] ?? ''}',
                  category_id       : '${data['category_id']}',
                  measurement_sku   : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : ''}',
                  measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : ''}',
                  measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : ''}',
                  measurement       : '${data['product_measurements']}'
              );
              HomeDatabase.instance.createHome(context, home);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailsScreen(
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
                        border: Border(
                            bottom: BorderSide(color: MyColors.shadow))),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data['name'], style: const TextStyle(
                                  fontSize: 16),),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?
                                  Text(
                                      '৳${data['sale_price']}',
                                      style: TextStyle(
                                          color: MyColors.inactive,
                                          fontSize: 10,
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
                                      ' | ${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : data['sub_text'] ?? ''}${data['product_measurements'].length > 0 ?'':data['unit_measure']['name']}',
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

                        if (double.parse(data['current_stock'] != null ? data['current_stock'].toString().replaceAll('.000000', '') : '0') <= 0) ...{
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (loginController.loginToken() == '') {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()),
                                    );
                                  } else {


                                    productRequestList[i].request?
                                    MyComponents().mySnackBar(context, 'The request has already been sent'):

                                    productRequest(
                                        context: context,
                                        customerId: loginController.loginCustomerId(),
                                        productId: data['id'].toString(),
                                        productVariationId: '',
                                        token: loginController.loginToken().toString());

                                    setState((){
                                      productRequestList[i].request = true;
                                    });

                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  margin: const EdgeInsets.only(top: 5),
                                  // child: Obx(() => Text(productRequestController.buttonName.string)),
                                  child:  Text(productRequestList[i].request==false?'Request':'Request Send',
                                    style: const TextStyle(
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

                                      for (var j = 0; j <
                                          testController.proList
                                              .length; j++) {
                                        if (testController.proList[j]
                                            .product_id == data['id']) {
                                          testController.proList.removeAt(j);
                                          testController.proList.value.add(
                                              AddProductModel(added: false,
                                                product_name      : '${data['name']}',
                                                unit_tag          : '${data['unit_measure']['name'] ?? ''}',
                                                image             : '${data['image'] ?? ''}',
                                                view_quantity     : '${data['sub_text'] ?? ''}',
                                                product_id        : data['id'],
                                                quantity          : addedProducts[i].quantity,
                                                purchase_price    : double.parse('${data['purchase_price'] ?? 0.0}'),
                                                sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:price,
                                                // sale_price        : double.parse(data['sale_price'] ?? 0.0),
                                                vat_amount        : double.parse('${data['vat'] ?? 0.0}'),
                                                discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:0.0,
                                                // discount_amount   : double.parse('${data['sale_price'] ?? 0.0}') - price,
                                                maximum_quantity  : double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                                                current_stock     : double.parse('${data['current_stock'] ?? 0.0}'),
                                                weight            : double.parse('${data['weight'] ?? 0.0}'),
                                                measurement_sku   : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                                                measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                                                measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',
                                              ));
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
                                                    view_quantity   : '${data['sub_text'] ?? ''}',
                                                    product_id      : data['id'],
                                                    quantity        : addedProducts[i].quantity,
                                                    purchase_price  : double.parse('${data['purchase_price'] ?? 0.0}'),
                                                    sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:price,
                                                    // sale_price      : double.parse(data['sale_price'] ?? 0.0),
                                                    vat_amount      : double.parse('${data['vat'] ?? 0.0}'),
                                                    discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:0.0,
                                                    // discount_amount   : double.parse('${data['sale_price'] ?? 0.0}') - price,
                                                    maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                                                    current_stock   : double.parse('${data['current_stock'] ?? 0.0}'),
                                                    weight          : double.parse('${data['weight'] ?? 0.0}'),
                                                    measurement_sku : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                                                    measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                                                    measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',
                                                  ));
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
                                            view_quantity   : '${data['sub_text'] ?? ''}',
                                            product_id      : data['id'],
                                            quantity        : addedProducts[i].quantity,
                                            purchase_price  : double.parse('${data['purchase_price'] ?? 0.0}'),
                                            sale_price      : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:price,
                                            // sale_price      : double.parse(data['sale_price'] ?? 0.0),
                                            vat_amount      : double.parse('${data['vat'] ?? 0.0}'),
                                            discount_amount : double.parse('${data['sale_price'] ?? 0.0}') * double.parse('${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : 1.0}') > price ?double.parse('${data['sale_price'] ?? 0.0}') - price:0.0,
                                            // discount_amount : double.parse('${data['sale_price'] ?? 0.0}') - price,
                                            maximum_quantity: double.parse('${data['maximum_order_quantity'] ?? 0.0}'),
                                            current_stock   : double.parse('${data['current_stock'] ?? 0.0}'),
                                            weight          : double.parse('${data['weight'] ?? 0.0}'),
                                            measurement_sku: '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['sku'] : '0'}',
                                            measurement_title : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['title'] : '0'}',
                                            measurement_value : '${data['product_measurements'].length > 0 ? data['product_measurements'][0]['value'] : '0'}',
                                          ));
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
            }
            else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: hasMore
                      ? const CircularProgressIndicator()
                      : const Text('No more products are available'),
                ),
              );
            }
          }
          else{
            return homes == null ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const[
                Center(child: Text('Loading...'),),
              ],
            )
                :
            const Center(child: CircularProgressIndicator());
            // LocalHome();
          }
        });
  }

}


class ProductRequestConst{
  var request;
  ProductRequestConst({this.request});
}