import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/configurations/my_sizes.dart';
import 'package:grocery/configurations/select_location.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/company_con.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/locals/database/db_helper.dart';
import 'package:grocery/locals/model/local_cart_model.dart';
import 'package:grocery/locals/database/login_db.dart';
import 'package:grocery/locals/model/login_model.dart';
import 'package:grocery/models/get_area.dart';
import 'package:grocery/models/get_district.dart';
import 'package:grocery/views/all_product/all_product_screen.dart';
import 'package:grocery/views/blogs/all_blogs.dart';
import 'package:grocery/views/blogs/blog_details.dart';
import 'package:grocery/views/brand/all_brand_screen.dart';
import 'package:grocery/views/product_details/product_details.dart';
import 'package:grocery/widgets/appbar_widget.dart';
import 'package:grocery/widgets/drawer_widget.dart';
import 'package:recase/recase.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({Key? key}) : super(key: key);

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  var companyController = Get.put(CompanyController());
  bool showBrand = false;

  @override
  void initState() {
    super.initState();
    cartController.refreshCarts();
    locController.Districts();
    locController.districtList;
    Areas(locController.districtId);
  }

  //for city and floating button section
  bool showSpeedDial = false;

  //for tap to open call log
  void throwUrl(caughtUrl) async {
    if (await canLaunch(caughtUrl)) {
      await launch(caughtUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to open',
            style: TextStyle(
              color: MyColors.decrement,
            ),
          ),
        ),
      );
    }
  }

  var todaySale         = [];
  var topRated          = [];
  var topDiscount       = [];
  var todaySaleRequest  = [];

  var cartController = Get.put(CartController());
  var locController  = Get.put(LocationController());
  var loginController  = Get.put(LoginController());


  var areaValue, areaId;

  List areaList     = [];
  Future<dynamic> Areas(districtId)async {
    print('District Id : $districtId');
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
      return areaData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Slider section
            FutureBuilder(
                future: fetchGetSliders(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? CarouselSlider.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              snapshot.data.length == 0
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: Image.asset(
                                        'assets/images/33-333216_no-offers-available-promotional-schemes.png',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "$imgBaseUrl/${snapshot.data[itemIndex].image}",
                                      ),
                                    ),
                          options: CarouselOptions(
                            height: 100,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            scrollDirection: Axis.horizontal,
                          ),
                        )
                      : Shimmer.fromColors(
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            color: Colors.grey,
                          ),
                          baseColor: MyColors.shimmerBaseColor,
                          highlightColor: MyColors.shimmerHighlightColor);
                }),

            //select city section
            Padding(
              padding: EdgeInsets.all(MySizes.bodyPadding),
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),

                  Container(
                    width: 130,
                    height: 40,
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
                      dropdownSearchDecoration: InputDecoration(
                        hintStyle: const TextStyle(fontSize: 14),
                        hintText: '${locController.districtValue}\n${areaValue ?? loginController.loginArea()}',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.only(left: 8, top: 5),
                      ),
                      items: [
                        for(int i=0; i<locController.districtList.length;i++)...{
                          locController.districtList[i].name.toString()
                        },
                      ],
                      onChanged: (newVal) {
                        setState(() {
                          locController.districtValue.value = newVal.toString();
                          int index = locController.districtList.indexWhere((element) => element.name == newVal);
                          Areas(locController.districtList.elementAt(index).id);
                            locController.districtId.value      = locController.districtList.elementAt(index).id;
                            locController.districtValue.value   = locController.districtList.elementAt(index).name;
                            cartController.deliveryCharge.value = double.parse(locController.districtList.elementAt(index).shippingCost);

                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context)=> AlertDialog(
                                content:  Container(
                                  width: 130,
                                  height: 45,
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
                                      for(int i=0; i<areaList.length;i++)...{
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

                                actions: [
                                  TextButton(
                                      onPressed: ()=>Navigator.pop(context),
                                      child: Text('Cancel', style: TextStyle(color: MyColors.red),)
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        final login = Login(
                                          token       : '${loginController.loginToken() ?? ''}',
                                          name        : '${loginController.loginName() ?? ''}',
                                          email       : '${loginController.loginEmail() ?? ''}',
                                          phone       : '${loginController.loginPhone() ?? ''}',
                                          user_id     : int.parse(loginController.loginUserId()),
                                          customer_id : int.parse(loginController.loginCustomerId()),
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
                        });
                      },
                    ),
                  ),

                  const Spacer(),
                  showSpeedDial
                      ? IconButton(
                          onPressed: () {
                            throwUrl('tel:${companyController.hotline.string}');
                          },
                          icon: Icon(
                            Icons.phone,
                            color: MyColors.primary,
                          ),
                        )
                      : const SizedBox(),
                  showSpeedDial
                      ? IconButton(
                          onPressed: () {
                            throwUrl(
                                'mailto:${companyController.email.string}');
                          },
                          icon: Icon(
                            Icons.email,
                            color: MyColors.primary,
                          ),
                        )
                      : const SizedBox(),
                  showSpeedDial
                      ? IconButton(
                          onPressed: () {
                            throwUrl(companyController.website.string);
                          },
                          icon: Icon(
                            Icons.language,
                            color: MyColors.primary,
                          ),
                        )
                      : const SizedBox(),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          showSpeedDial = !showSpeedDial;
                        });
                      },
                      icon: showSpeedDial
                          ? Icon(
                              Icons.close,
                              color: MyColors.decrement,
                            )
                          : Icon(
                              Icons.menu,
                              color: MyColors.primary,
                            )),
                ],
              ),
            ),



            //categories section
            const Text(
              "  Categories",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),

            //for horizontal view
            SizedBox(
              height: 100,
              child: FutureBuilder(
                  future: fetchGetHighlightedCategories(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, i) {
                              var data = snapshot.data;
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, top: 5), //top add blind
                                child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AllProductScreen(
                                                type: 'category',
                                                slug: data[i].slug,
                                              ))),
                                  child: Column(
                                    children: [
                                      data[i].image != null && data.length > 0
                                          ? CircleAvatar(
                                              radius: 30,
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                      '$imgBaseUrl/${data[i].image}'))
                                          : const CircleAvatar(
                                              radius: 30,
                                              backgroundImage: AssetImage(
                                                  'assets/images/picture.png'),
                                            ),
                                      Text(
                                        data[i].name,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })
                        : Shimmer.fromColors(
                            child: ListView.builder(
                                itemCount: 5,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, i) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Column(
                                      children: const [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage(
                                              'assets/images/image-gallery.png'),
                                        ),
                                        Text(
                                          'Name',
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            baseColor: MyColors.shimmerBaseColor,
                            highlightColor: MyColors.shimmerHighlightColor);
                  }),
            ),

            //for banners
            SizedBox(
                height: 120,
                child: FutureBuilder(
                    future: fetchGetBanners(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return snapshot.hasData
                          ? CarouselSlider.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  snapshot.data.length == 0
                                      ? SizedBox(
                                          width: double.infinity,
                                          child: Image.asset(
                                            'assets/images/33-333216_no-offers-available-promotional-schemes.png',
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : SizedBox(
                                          width: double.infinity,
                                          child:
                                              snapshot.data[itemIndex].image !=
                                                      null
                                                  ? CachedNetworkImage(
                                                      imageUrl:
                                                          '$imgBaseUrl/${snapshot.data[itemIndex].image}',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.asset(
                                                      'assets/images/33-333216_no-offers-available-promotional-schemes.png',
                                                      fit: BoxFit.cover,
                                                    ),
                                        ),
                              options: CarouselOptions(
                                height: 100,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                initialPage: 0,
                                enableInfiniteScroll: true,
                                reverse: false,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                scrollDirection: Axis.horizontal,
                              ),
                            )
                          : SizedBox(
                              width: double.infinity,
                              child: Shimmer.fromColors(
                                  child: Image.asset(
                                    'assets/images/33-333216_no-offers-available-promotional-schemes.png',
                                    fit: BoxFit.cover,
                                  ),
                                  baseColor: MyColors.shimmerBaseColor,
                                  highlightColor:
                                      MyColors.shimmerHighlightColor),
                            );
                    })),

            //Highlighted Product
            FutureBuilder(
                future: fetchHighlightedProduct(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                              vertical: MySizes.bodyPadding),
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, i) {
                            var data = snapshot.data[i];

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                data['product_highlight_types'].length > 0
                                    ? Text(
                                        "   ${data['name']}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20),
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 5,
                                ),
                                data['product_highlight_types'].length > 0
                                    ? GridView.builder(
                                        itemCount:
                                            data['product_highlight_types']
                                                .length,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                mainAxisExtent: 180,
                                                mainAxisSpacing: 15,
                                                crossAxisSpacing: 0,
                                                crossAxisCount: 2),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var datas =
                                              data['product_highlight_types']
                                                  [index]['product'];

                                          if (i == 0) {
                                            todaySale.add(ContactModel(
                                                datas['name'], false));
                                          } else if (i == 1) {
                                            topRated.add(ContactModel(
                                                data['name'], false));
                                          } else if (i == 2) {
                                            topDiscount.add(ContactModel(
                                                data['name'], false));
                                          }

                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetailsScreen(
                                                            image: datas[
                                                                'thumbnail_image'],
                                                            productId:
                                                                datas['id'],
                                                            name: datas['name'],
                                                            price:
                                                                '${datas['sale_price'].toString().split('.')[0]}.${datas['sale_price'].toString().split('.')[1].toString().substring(0, 1)}',
                                                            description: datas[
                                                                'description'],
                                                            subText: datas[
                                                                'sub_text'],
                                                            unitMeasureName:
                                                                datas['unit_measure']
                                                                    ['name'],
                                                            purchasePrice: datas[
                                                                'purchase_price'],
                                                            vat: datas['vat'],
                                                            discount: datas[
                                                                'discount'],
                                                            maximumOrder: datas[
                                                                'maximum_order_quantity'],
                                                            currentStock: datas[
                                                                'current_stock'],
                                                            sku: datas['sku'],
                                                            categoryId: datas[
                                                                'category_id'],
                                                            id: datas['id'],
                                                            weight:
                                                                datas['weight'],
                                                          )));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              margin: const EdgeInsets.only(
                                                  left: 5, right: 5),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.36,
                                              decoration: BoxDecoration(
                                                  color: MyColors.background,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color:
                                                            MyColors.inactive,
                                                        blurRadius: 2)
                                                  ]),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Center(
                                                        child: datas[
                                                                    'thumbnail_image'] !=
                                                                null
                                                            ? CachedNetworkImage(
                                                                imageUrl:
                                                                    "$imgBaseUrl/${datas['thumbnail_image']}",
                                                                height: 80,
                                                              )
                                                            : Image.asset(
                                                                'assets/images/picture.png',
                                                                height: 85,
                                                              ),
                                                      ),
                                                      datas['discount'] != null
                                                          ? Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 5,
                                                                  vertical: 2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                                color: MyColors
                                                                    .decrement,
                                                              ),
                                                              child: Text(
                                                                datas['discount']
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            )
                                                          : const SizedBox(),
                                                    ],
                                                  ),
                                                  Text(
                                                    datas['name'].length > 15
                                                        ? '${datas['name'].substring(0, 15)}.'
                                                        : datas['name'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    '৳${datas['sale_price'].toString().split('.')[0]}.${datas['sale_price'].toString().split('.')[1].toString().substring(0, 1)}/${datas['sub_text'] ?? ''} ${datas['unit_measure']['name']}',
                                                    style: const TextStyle(
                                                        //fontWeight: FontWeight.w500
                                                        ),
                                                  ),
                                                  if (double.parse(datas[
                                                                  'current_stock'] !=
                                                              null
                                                          ? datas['current_stock']
                                                              .toString()
                                                              .replaceAll(
                                                                  '.000000', '')
                                                          : '0') <=
                                                      0) ...{
                                                    Container(
                                                      width: double.infinity,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: const Text(
                                                        'Out Of Stock',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: MyColors
                                                              .inactive),
                                                    )
                                                  } else ...{
                                                    if (i == 0) ...{
                                                      todaySale[index]
                                                                  .isSelected ||
                                                              datas['unit_measure']
                                                                      ['name']
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      'coming')
                                                          ? AddToCartActive(
                                                              datas['unit_measure']
                                                                  ['name'])
                                                          : GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  i == 0
                                                                      ? todaySale[
                                                                              index]
                                                                          .isSelected = !todaySale[
                                                                              index]
                                                                          .isSelected
                                                                      : i == 1
                                                                          ? topRated[index].isSelected = !topRated[index]
                                                                              .isSelected
                                                                          : topDiscount[index].isSelected =
                                                                              !topDiscount[index].isSelected;
                                                                });
                                                                final carts =
                                                                    AddtoCart(
                                                                  product_id:
                                                                      datas[
                                                                          'id'],
                                                                  product_name:
                                                                      '${datas['name'] ?? ''}',
                                                                  unit_tag:
                                                                      '${datas['unit_measure']['name'] ?? ''}',
                                                                  image:
                                                                      '${datas['thumbnail_image'] ?? ''}',
                                                                  purchase_price:
                                                                      double.parse(
                                                                          '${datas['purchase_price'] ?? 0.0}'),
                                                                  sale_price:
                                                                      double.parse(
                                                                          '${datas['sale_price'] ?? 0.0}'),
                                                                  quantity: 1,
                                                                  view_quantity:
                                                                      '${datas['sub_text'] ?? 1}',
                                                                  vat_amount:
                                                                      double.parse(
                                                                          '${datas['vat'] ?? 0.0}'),
                                                                  discount_amount:
                                                                      double.parse(
                                                                          '${datas['discount'] ?? 0.0}'),
                                                                  maximum_quantity:
                                                                      double.parse(
                                                                          '${datas['maximum_order_quantity'] ?? 0.0}'),
                                                                  current_stock:
                                                                      double.parse(
                                                                          '${datas['current_stock'] ?? 0.0}'),
                                                                  weight: double
                                                                      .parse(
                                                                          '${data['weight'] ?? 0.0}'),
                                                                );
                                                                CartDatabase.instance.createCart(context, carts).then((value) {
                                                                  cartController.refreshCarts();
                                                                  cartController.totalPrice();
                                                                });
                                                              },
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                child:
                                                                    const Text(
                                                                  'Add To Cart',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    color: MyColors
                                                                        .primary),
                                                              ),
                                                            )
                                                    } else if (i == 1) ...{
                                                      topRated[index]
                                                                  .isSelected ||
                                                              datas['unit_measure']
                                                                      ['name']
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      'coming')
                                                          ? AddToCartActive(
                                                              datas['unit_measure']
                                                                  ['name'])
                                                          : GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  i == 0
                                                                      ? todaySale[
                                                                              index]
                                                                          .isSelected = !todaySale[
                                                                              index]
                                                                          .isSelected
                                                                      : i == 1
                                                                          ? topRated[index].isSelected = !topRated[index]
                                                                              .isSelected
                                                                          : topDiscount[index].isSelected =
                                                                              !topDiscount[index].isSelected;
                                                                });
                                                                final carts =
                                                                    AddtoCart(
                                                                  product_id:
                                                                      datas[
                                                                          'id'],
                                                                  product_name:
                                                                      '${datas['name'] ?? ''}',
                                                                  unit_tag:
                                                                      '${datas['unit_measure']['name'] ?? ''}',
                                                                  image:
                                                                      '${datas['thumbnail_image'] ?? ''}',
                                                                  purchase_price:
                                                                      double.parse(
                                                                          '${datas['purchase_price']}'),
                                                                  sale_price:
                                                                      double.parse(
                                                                          '${datas['sale_price']}'),
                                                                  quantity: 1,
                                                                  view_quantity:
                                                                      '${datas['sub_text'] ?? 1}',
                                                                  vat_amount:
                                                                      double.parse(
                                                                          '${datas['vat'] ?? 0.0}'),
                                                                  discount_amount:
                                                                      double.parse(
                                                                          '${datas['discount'] ?? 0.0}'),
                                                                  maximum_quantity:
                                                                      double.parse(
                                                                          '${datas['maximum_order_quantity'] ?? 0.0}'),
                                                                  current_stock:
                                                                      double.parse(
                                                                          '${datas['current_stock'] ?? 0.0}'),
                                                                  weight: double
                                                                      .parse(
                                                                          '${data['weight'] ?? 0.0}'),
                                                                );
                                                                CartDatabase
                                                                    .instance
                                                                    .createCart(
                                                                        context,
                                                                        carts)
                                                                    .then(
                                                                        (value) {
                                                                  cartController
                                                                      .refreshCarts();
                                                                  cartController
                                                                      .totalPrice();
                                                                });
                                                              },
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                child:
                                                                    const Text(
                                                                  'Add To Cart',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    color: MyColors
                                                                        .primary),
                                                              ),
                                                            )
                                                    } else if (i == 2) ...{
                                                      topDiscount[index]
                                                                  .isSelected ||
                                                              datas['unit_measure']
                                                                      ['name']
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      'coming')
                                                          ? AddToCartActive(
                                                              datas['unit_measure']
                                                                  ['name'])
                                                          : GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  i == 0
                                                                      ? todaySale[
                                                                              index]
                                                                          .isSelected = !todaySale[
                                                                              index]
                                                                          .isSelected
                                                                      : i == 1
                                                                          ? topRated[index].isSelected = !topRated[index]
                                                                              .isSelected
                                                                          : topDiscount[index].isSelected =
                                                                              !topDiscount[index].isSelected;
                                                                });
                                                                final carts =
                                                                    AddtoCart(
                                                                  product_id:
                                                                      datas[
                                                                          'id'],
                                                                  product_name:
                                                                      '${datas['name'] ?? ''}',
                                                                  unit_tag:
                                                                      '${datas['unit_measure']['name'] ?? ''}',
                                                                  image:
                                                                      '${datas['thumbnail_image'] ?? ''}',
                                                                  purchase_price:
                                                                      double.parse(
                                                                          '${datas['purchase_price']}'),
                                                                  sale_price:
                                                                      double.parse(
                                                                          '${datas['sale_price']}'),
                                                                  quantity: 1,
                                                                  view_quantity:
                                                                      '${datas['sub_text'] ?? 1}',
                                                                  vat_amount:
                                                                      double.parse(
                                                                          '${datas['vat'] ?? 0.0}'),
                                                                  discount_amount:
                                                                      double.parse(
                                                                          '${datas['discount'] ?? 0.0}'),
                                                                  maximum_quantity:
                                                                      double.parse(
                                                                          '${datas['maximum_order_quantity'] ?? 0.0}'),
                                                                  current_stock:
                                                                      double.parse(
                                                                          '${datas['current_stock'] ?? 0.0}'),
                                                                  weight: double
                                                                      .parse(
                                                                          '${data['weight'] ?? 0.0}'),
                                                                );
                                                                CartDatabase
                                                                    .instance
                                                                    .createCart(
                                                                        context,
                                                                        carts)
                                                                    .then(
                                                                        (value) {
                                                                  cartController
                                                                      .refreshCarts();
                                                                  cartController
                                                                      .totalPrice();
                                                                });
                                                              },
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 5),
                                                                child:
                                                                    const Text(
                                                                  'Add To Cart',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                5),
                                                                    color: MyColors
                                                                        .primary),
                                                              ),
                                                            )
                                                    }
                                                  }
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                    : Container()
                              ],
                            );
                          })
                      : Container();
                }),

            const SizedBox(
              height: 10,
            ),

            //brands section
            showBrand
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "  Brands",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AllBrandScreen()));
                          },
                          child: const Text('See all'))
                    ],
                  )
                : const Text(''),
            showBrand
                ? SizedBox(
                    height: 100,
                    child: FutureBuilder(
                        future: fetchGetHighlightedBrands(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return snapshot.hasData
                              ? ListView.builder(
                                  itemCount: snapshot.data.length,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (_, i) {
                                    setState(() {
                                      showBrand = true;
                                    });

                                    var data = snapshot.data;
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: InkWell(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    AllProductScreen(
                                                      type: 'brand',
                                                      slug: data[i].slug,
                                                    ))),
                                        child: Column(
                                          children: [
                                            data[i].logo != null
                                                ? CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                            '$imgBaseUrl/${data[i].logo}'),
                                                  )
                                                : const CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/picture.png'),
                                                  ),
                                            Text(
                                              data[i].name.toString().titleCase,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : Shimmer.fromColors(
                                  child: ListView.builder(
                                      itemCount: 5,
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (_, i) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Column(
                                            children: const [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundImage: AssetImage(
                                                    'assets/images/image-gallery.png'),
                                              ),
                                              Text(
                                                'Name',
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                  baseColor: MyColors.shimmerBaseColor,
                                  highlightColor:
                                      MyColors.shimmerHighlightColor);
                        }),
                  )
                : const Text(''),

            //Blogs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "  Blogs",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const AllBlogsScreen()));
                    },
                    child: const Text('See all'))
              ],
            ),
            SizedBox(
                height: 120,
                child: FutureBuilder(
                    future: fetchGetBlogs(),
                    builder:
                        (BuildContext context, AsyncSnapshot snapshot) {
                      return snapshot.hasData
                          ? CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 110,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval:
                            const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.ease,
                            scrollDirection: Axis.horizontal,
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder:
                              (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          snapshot.data.length == 0
                              ? SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/33-333216_no-offers-available-promotional-schemes.png',
                              fit: BoxFit.cover,
                            ),
                          )
                              : SizedBox(
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder:
                                            (context) =>
                                            BlogDetails(
                                              blogImage:
                                              snapshot.data[itemIndex].image,
                                              blogTitle: snapshot
                                                  .data[itemIndex]
                                                  .name,
                                              blogDescription: snapshot
                                                  .data[itemIndex]
                                                  .description,
                                            )));
                              },
                              child: Container(
                                decoration:
                                BoxDecoration(
                                  borderRadius:
                                  BorderRadius
                                      .circular(5),
                                  color:
                                  const Color(0xffffff),
                                  image: DecorationImage(
                                      image: snapshot.data[itemIndex].image != null
                                          ? NetworkImage(
                                        '$imgBaseUrl/${snapshot.data[itemIndex].image}',
                                        // fit: BoxFit.cover,
                                      )
                                          : const AssetImage(
                                        'assets/images/33-333216_no-offers-available-promotional-schemes.png',
                                        // fit: BoxFit.cover,
                                      ) as ImageProvider,
                                      fit: BoxFit.cover),
                                ),
                                child: BackdropFilter(
                                  filter: ImageFilter
                                      .blur(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors
                                            .black38,
                                        borderRadius:
                                        BorderRadius
                                            .circular(
                                            5)),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets
                                          .all(5.0),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .end,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            '${snapshot.data[itemIndex].name}',
                                            style: const TextStyle(
                                                fontSize:
                                                16,
                                                fontWeight:
                                                FontWeight
                                                    .w600,
                                                color: Colors
                                                    .white),
                                            textAlign:
                                            TextAlign
                                                .start,
                                          ),
                                          Text(
                                            snapshot.data[itemIndex].description.length >
                                                100
                                                ? snapshot
                                                .data[
                                            itemIndex]
                                                .description
                                                .toString()
                                                .substring(0,
                                                100)
                                                : snapshot
                                                .data[itemIndex]
                                                .description,
                                            style: TextStyle(
                                                fontSize:
                                                14,
                                                fontWeight:
                                                FontWeight
                                                    .w100,
                                                color: MyColors
                                                    .shadow),
                                            textAlign:
                                            TextAlign
                                                .justify,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ))
                          : SizedBox(
                        width: double.infinity,
                        child: Shimmer.fromColors(
                            baseColor: MyColors.shimmerBaseColor,
                            highlightColor:
                            MyColors.shimmerHighlightColor,
                            child: Image.asset(
                              'assets/images/33-333216_no-offers-available-promotional-schemes.png',
                              fit: BoxFit.cover,
                            )),
                      );
                    })),
          ],
        ),
      ),
    );
  }

  Widget AddToCartActive(measureName) {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 5),
      child: const Text(
        'Add To Cart',
        //measureName.toString().toLowerCase().contains('coming') ? 'Add To Cart' : 'Coming Soon',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: MyColors.inactive),
    );
  }

  Widget DropDown({text, list, value, id}){
    return Container(
      width: 130,
      height: 45,
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
        dropdownSearchDecoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 16),
          hintText: text,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          //prefixIcon: const Icon(Icons.location_city_outlined),
          contentPadding: const EdgeInsets.only(left: 10, top: 12),
        ),
        items: [
          for(int i=0; i<list.length;i++)...{
            list[i].name.toString()
          },
        ],
        onChanged: (newVal) {
          setState(() {
            value = newVal;
            int index = list.indexWhere((element) => element.name == newVal);
            if(id == locController.districtId){
              locController.districtId.value      = list.elementAt(index).id;
              locController.districtValue.value   = list.elementAt(index).name;
              locController.shippingCharge.value  = double.parse(list.elementAt(index).shippingCost);
              cartController.deliveryCharge.value = locController.shippingCharge.toDouble();
            }

          });
        },
      ),
    );
  }
}
