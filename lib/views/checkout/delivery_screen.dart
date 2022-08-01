import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/configurations/select_location.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/date_time.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/locals/database/login_db.dart';
import 'package:grocery/locals/model/login_model.dart';
import 'package:grocery/models/get_area.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DeliveryScreen extends StatefulWidget {
  dynamic phone, type, orderId;
  DeliveryScreen({this.phone, this.type, this.orderId});

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  var cartController  = Get.put(CartController());
  var locController   = Get.put(LocationController());
  var loginController = Get.put(LoginController());
  var timeController  = Get.put(DateTimeController());

  var areaValue, receiverDistrictValue, receiverAreaValue;
  var areaId, receiverDistrictId, receiverAreaId;
  var shippingCharge;

  List areaList = [];
  Future<dynamic> Areas() async {
    String url = '$baseUrl/get-areas/${locController.districtId}';
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

  List receiverAreaList = [];
  Future<dynamic> ReceiverAreas() async {
    String url = '$baseUrl/get-areas/${locController.receiverDistrictId}';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      GetAreaList area = getAreaListFromJson(response.body);
      List areaData = area.data.areas;
      for (var i = 0; i <= areaData.length; i++) {
        setState(() {
          receiverAreaList = areaData;
        });
      }
      return areaData;
    }
  }

  ///for user info
  var fullName, email, address, zipCode;
  getUserInfo() async {
    setState(() {
      fullName =
          TextEditingController(text: loginController.loginName().toString());
      email =
          TextEditingController(text: loginController.loginEmail().toString());
      address = TextEditingController(
          text: loginController.loginAddress().toString());
      zipCode = TextEditingController(
          text: loginController.loginZipCode().toString());
    });
  }

  @override
  void initState() {
    super.initState();
    locController.Districts();
    getUserInfo();
    Areas();
    selectDate  = timeController.selectDates != '' ? DateTime.parse(timeController.selectDates.toString()) : DateTime.now();
    dateIs      = timeController.selectDates != '' ? true : false;
    selectTime  = timeController.selectTime;
    timeId      = timeController.timeId;
  }

  ///for date pick
  DateTime initialDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  bool dateIs = false;
  var selectDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: initialDate,
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectDate = picked;
        dateIs = true;
        timeList.removeRange(0, timeList.length);
        fetchTime();
      });
    }
  }

  ///for time
  var selectTime, timeId;
  List timeList = [];
  Future fetchTime() async {
    var endDate = DateTime(
        int.parse(selectDate.toString().split('-')[0]),
        int.parse(selectDate.toString().split('-')[1]),
        int.parse(selectDate.toString().split('-')[2].split(' ')[0]));
    var currentDate = DateTime.now();
    var difference = currentDate.difference(endDate).inHours;
    String formattedDate = DateFormat('kk:mm').format(DateTime.now());

    var url = Uri.parse('$baseUrl/get-common-section-data');
    var res = await http.get(url);

    var status = json.decode(res.body)['status'];
    var getTimes = json.decode(res.body)['data']['time_slots'];
    if (status == 1) {
      setState(() {
        for (var i = 0; i < getTimes.length; i++) {
          if (difference >= 0 &&
              timeConvert(formattedDate) >
                  timeConvert(time12to24Format(getTimes[i]['disable_at'] != null
                      ? getTimes[i]['disable_at']
                      : '0:00'))) {
            //timeList.remove(getTimes[i]);
          } else {
            timeList.add(getTimes[i]);
          }
        }
        //timeList = getTimes;
      });
    }
  }

  var formKey = GlobalKey<FormState>();

  ///for pickup
  bool selectCheck = false;
  bool selectDelivery = true;

  var fullNameController  = TextEditingController();
  var emailController     = TextEditingController();
  var addressController   = TextEditingController();
  var zipCodeController   = TextEditingController();
  var orderNote           = TextEditingController();

  ///for ship to differrenc address
  var receiverFullNameCon   = TextEditingController();
  var receiverPhoneCon      = TextEditingController();
  var receiverEmailCon      = TextEditingController();
  var receiverCountryCon    = TextEditingController();
  var receiverAddressCon    = TextEditingController();
  var receiverZipCodeCon    = TextEditingController();
  var receiverOrderNoteCon  = TextEditingController();

  dynamic name, newEmail;

  String time12to24Format(String time) {
    int h = int.parse(time.split(":").first);
    int m = int.parse(time.split(":").last.split(" ").first);
    String meridium = time.split(":").last.split(" ").last.toLowerCase();
    if (meridium == "pm") {
      if (h != 12) {
        h = h + 12;
      }
    }
    if (meridium == "am") {
      if (h == 12) {
        h = 00;
      }
    }
    String newTime = "${h == 0 ? "00" : h}:${m == 0 ? "00" : m}";

    return newTime;
  }

  timeConvert(time) {
    var minutes = time.toString().split(':')[0];
    var seconds = time.toString().split(':')[1];

    var times = int.parse(minutes) * 60 + int.parse(seconds);
    return times;
  }

  Widget pickup() {
    return Expanded(
      child: Form(
        key: formKey,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [
            //for name
            MyComponents().inputText(
              context,
              controller: widget.type != 'otp' ? fullName : fullNameController,
              hintText: 'Full Name *',
              prefixIcon: Icons.person_outline,
              message: 'Full Name',
              autoFillHints: AutofillHints.name,
            ),

            //for phone
            MyComponents().inputText(
              context,
              hintText: '${widget.phone ?? loginController.loginPhone()}',
              prefixIcon: Icons.phone_iphone_outlined,
              readOnly: true,
              autoFillHints: AutofillHints.name,
            ),

            //for Email
            MyComponents().inputText(
              context,
              controller: widget.type != 'otp' ? email : emailController,
              hintText: 'Email',
              prefixIcon: Icons.email_outlined,
              autoFillHints: AutofillHints.email,
            ),

            //for country
            MyComponents().inputText(
              context,
              hintText: 'Bangladesh',
              prefixIcon: Icons.location_on_outlined,
              readOnly: true,
              autoFillHints: AutofillHints.addressState,
            ),

            //District
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DropDown(
                  text:
                      '${loginController.loginDistrict() != '' ? loginController.loginDistrict() : locController.districtValue}',
                  list: locController.districtList,
                  value: locController.districtValue,
                  id: locController.districtId),
            ),

            //Area
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: DropDown(
                  text:
                      '${loginController.loginArea() != '' ? loginController.loginArea() : 'Select Area*'}',
                  list: areaList,
                  value: areaValue,
                  id: areaId),
            ),

            //for Address
            MyComponents().inputText(
              context,
              controller: widget.type != 'otp' ? address : addressController,
              hintText: 'Address *',
              prefixIcon: Icons.location_on_outlined,
              message: 'Address',
              autoFillHints: AutofillHints.addressState,
            ),

            //for Zip Code
            MyComponents().inputText(context,
                controller: widget.type != 'otp' ? zipCode : zipCodeController,
                hintText: 'ZIP Code',
                prefixIcon: Icons.location_on_outlined,
                autoFillHints: AutofillHints.addressCityAndState,
                type: TextInputType.number),

            //For Order Note
            MyComponents().inputText(
              context,
              controller: orderNote,
              hintText: 'Order Note',
              prefixIcon: Icons.edit,
              autoFillHints: AutofillHints.addressCityAndState,
            ),

            //for date
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 45,
                alignment: Alignment.centerLeft,
                color: MyColors.shadow,
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.black.withOpacity(0.5),
                      size: 16,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      dateIs
                          ? "${selectDate.toLocal()}".split(' ')[0]
                          : 'Select Date *',
                      style: TextStyle(
                          fontSize: 16, color: Colors.black.withOpacity(0.6)),
                    ),
                  ],
                ),
              ),
            ),

            //select time
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.only(bottom: 8, top: 8),
              height: 45,
              alignment: Alignment.centerLeft,
              color: MyColors.shadow,
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: Colors.black.withOpacity(0.5),
                    size: 16,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        items: timeList.map((item) {
                          if (selectTime == '${item['starting_time']} - ${item['ending_time'].toString()}') {
                            timeId = item['id'];
                          } else {
                            const Text('No Select Time Select');
                          }
                          return DropdownMenuItem(
                            child: Text(
                                "${item['starting_time']} - ${item['ending_time']}"),
                            value:
                                "${item['starting_time']} - ${item['ending_time']}",
                          );
                        }).toList(),
                        value: selectTime,
                        onChanged: (v) {
                          setState(() {
                            selectTime = v.toString();
                          });
                        },
                        hint: Text(selectTime != null ? selectTime : 'Select Time *'),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //for Ship To Different Address!
            widget.type != 'update'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          value: selectCheck,
                          onChanged: (v) => setState(() {
                                selectCheck = v!;
                              })),
                      Text(
                        'Ship To Different Address!',
                        style: TextStyle(color: MyColors.inactive),
                      ),
                    ],
                  )
                : Container(),

            selectCheck
                ? SizedBox(
                    child: Column(
                      children: [
                        //for name
                        MyComponents().inputText(
                          context,
                          controller: receiverFullNameCon,
                          hintText: 'Receiver full name *',
                          prefixIcon: Icons.person_outline,
                          message: 'Receiver full name',
                          autoFillHints: AutofillHints.name,
                        ),

                        //for phone
                        MyComponents().inputText(context,
                            controller: receiverPhoneCon,
                            hintText: 'Receiver phone *',
                            prefixIcon: Icons.phone_iphone_outlined,
                            readOnly: false,
                            autoFillHints: AutofillHints.telephoneNumber,
                            message: 'Receiver phone',
                            type: TextInputType.phone),

                        //for Email
                        MyComponents().inputText(context,
                            controller: receiverEmailCon,
                            hintText: 'Receiver email',
                            prefixIcon: Icons.email_outlined,
                            autoFillHints: AutofillHints.email,
                            type: TextInputType.emailAddress),

                        //for country
                        MyComponents().inputText(
                          context,
                          hintText: 'Bangladesh',
                          prefixIcon: Icons.location_on_outlined,
                          readOnly: true,
                          autoFillHints: AutofillHints.addressState,
                        ),

                        //District
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: MyColors.shadow),
                              child: DropdownSearch<String>(
                                dropdownSearchBaseStyle:
                                    const TextStyle(fontSize: 18),
                                popupShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                mode: Mode.DIALOG,
                                showSearchBox: true,
                                dropdownSearchDecoration: const InputDecoration(
                                  hintStyle: TextStyle(fontSize: 16),
                                  hintText: 'Receiver District *',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  prefixIcon:
                                      Icon(Icons.location_city_outlined),
                                  contentPadding:
                                      EdgeInsets.only(left: 40, top: 12),
                                ),
                                items: [
                                  for (int i = 0;
                                      i <
                                          locController
                                              .receiverDistrictList.length;
                                      i++) ...{
                                    locController.receiverDistrictList[i].name
                                        .toString(),
                                  },
                                ],
                                onChanged: (newVal) {
                                  setState(() {
                                    locController.receiverDistrictValue.value =
                                        newVal!;
                                    int index = locController
                                        .receiverDistrictList
                                        .indexWhere((element) =>
                                            element.name == newVal);
                                    locController.receiverDistrictId.value =
                                        locController.receiverDistrictList
                                            .elementAt(index)
                                            .id;
                                    locController.receiverDistrictValue.value =
                                        locController.receiverDistrictList
                                            .elementAt(index)
                                            .name;
                                    ReceiverAreas();
                                    shippingCharge = locController
                                        .receiverDistrictList
                                        .elementAt(index)
                                        .shippingCost;
                                    cartController.deliveryCharge.value =
                                        double.parse(shippingCharge);
                                  });
                                },
                              ),
                            )),

                        //Area
                        Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: MyColors.shadow),
                              child: DropdownSearch<String>(
                                dropdownSearchBaseStyle:
                                    const TextStyle(fontSize: 18),
                                popupShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                mode: Mode.DIALOG,
                                showSearchBox: true,
                                dropdownSearchDecoration: const InputDecoration(
                                  hintStyle: TextStyle(fontSize: 16),
                                  hintText: 'Receiver Area *',
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  isDense: true,
                                  prefixIcon:
                                      Icon(Icons.location_city_outlined),
                                  contentPadding:
                                      EdgeInsets.only(left: 40, top: 12),
                                ),
                                items: [
                                  for (int i = 0;
                                      i < receiverAreaList.length;
                                      i++) ...{
                                    receiverAreaList[i].name.toString(),
                                  },
                                ],
                                onChanged: (newVal) {
                                  setState(() {
                                    receiverAreaValue = newVal;
                                    int index = receiverAreaList.indexWhere(
                                        (element) => element.name == newVal);
                                    receiverAreaId =
                                        receiverAreaList.elementAt(index).id;
                                    receiverAreaValue =
                                        receiverAreaList.elementAt(index).name;
                                  });
                                },
                              ),
                            )),

                        //for Address
                        MyComponents().inputText(
                          context,
                          controller: receiverAddressCon,
                          hintText: 'Receiver Address *',
                          prefixIcon: Icons.location_on_outlined,
                          message: 'Receiver Address',
                          autoFillHints: AutofillHints.addressState,
                        ),

                        //for Zip Code
                        MyComponents().inputText(context,
                            controller: receiverZipCodeCon,
                            hintText: 'Receiver ZIP Code',
                            prefixIcon: Icons.location_on_outlined,
                            autoFillHints: AutofillHints.addressCityAndState,
                            type: TextInputType.number),

                        //For Order Note
                        MyComponents().inputText(context,
                            controller: receiverOrderNoteCon,
                            hintText: 'Receiver Order Note',
                            prefixIcon: Icons.edit,
                            autoFillHints: AutofillHints.addressCityAndState),
                      ],
                    ),
                  )
                : const SizedBox(),

            //for cupon
            const SizedBox(
              height: 20,
            ),

            const Divider(
              thickness: 2,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('\nSubTotal:'),
                    Text('\n৳${cartController.totalPrice()}')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Shipping charge:'),
                    Text(
                        '৳${cartController.deliveryCharge != null ? cartController.deliveryCharge.toString().replaceAll('.000000', '.00') : '0'}')
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Promo Code',
                            border: OutlineInputBorder(),
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(10)),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 11)),
                        onPressed: () {},
                        child: const Text('APPLY'))
                  ],
                )
              ],
            ),

            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget DropDown({text, list, value, id}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2), color: MyColors.shadow),
      child: DropdownSearch<String>(
        dropdownSearchBaseStyle: const TextStyle(fontSize: 18),
        popupShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        mode: Mode.DIALOG,
        showSearchBox: true,
        dropdownSearchDecoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 16),
          hintText: text,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          isDense: true,
          prefixIcon: const Icon(Icons.location_city_outlined),
          contentPadding: const EdgeInsets.only(left: 40, top: 12),
        ),
        items: [
          for (int i = 0; i < list.length; i++) ...{
            list[i].name.toString(),
          },
        ],
        onChanged: (newVal) {
          setState(() {
            value = newVal;
            int index = list.indexWhere((element) => element.name == newVal);
            if (id == locController.districtId) {
              print('111111111111111111');
              locController.districtId.value = list.elementAt(index).id;
              locController.districtValue.value = list.elementAt(index).name;
              Areas();
              shippingCharge = list.elementAt(index).shippingCost;
              cartController.deliveryCharge.value =
                  double.parse(shippingCharge);
            } else if (id == areaId) {
              print('222222222222222222');
              areaId = list.elementAt(index).id;
              areaValue = list.elementAt(index).name;
            }

            // else{
            //   print('333333333333333333');
            //   setState(() {
            //     timeController.selectTime = newVal.toString();
            //     int index = timeController.timeList.indexWhere((element) => '${element['starting_time']} - ${element['ending_time']}' == newVal);
            //     timeController.timeId      = timeController.timeList[index]['id'];
            //     timeController.selectTime  = timeController.timeList.elementAt(index)['name'];
            //   });
            // }

            // else if(id == receiverAreaId){
            //   print('4444444444444444444');
            //  setState(() {
            //    receiverAreaId = list.elementAt (index).id;
            //    receiverAreaValue = list.elementAt (index).name;
            //  });
            // }
            // else{
            //   print('55555555555555555');
            // }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              color: MyColors.primary,
            )),
        titleSpacing: 0,
        title: Text(
          'Order',
          style: TextStyle(color: MyColors.primary, fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          pickup(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(right: 10),
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
          children: [
            widget.type != 'update'
                ? Text(
                    "   Total: ৳${double.parse(cartController.totalPrice().toString()) + cartController.deliveryCharge.toDouble()}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  )
                : Container(),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final formstate = formKey.currentState;
                if (formstate!.validate()) {
                  formstate.save();

                  if ((locController.districtId != null ||
                          loginController.loginDistrictId() != '0') &&
                      (areaId != null ||
                          loginController.loginAreaId() != '0') &&
                      timeId != null &&
                      selectDate != null) {
                    if (selectCheck == true) {
                      if (locController.receiverDistrictId != null &&
                          receiverAreaId != null) {
                        widget.type != 'update' ? createOrder() : updateOrder();
                      } else if (locController.receiverDistrictId == null) {
                        MyComponents().wrongSnackBar(
                            context, 'Please Select Receiver District');
                      } else if (receiverAreaId == null) {
                        MyComponents().wrongSnackBar(
                            context, 'Please Select Receiver Area');
                      }
                    } else {
                      widget.type != 'update' ? createOrder() : updateOrder();
                    }
                  } else if (loginController.loginDistrictId() == '0' &&
                      locController.districtId == null) {
                    MyComponents()
                        .wrongSnackBar(context, 'Please Select A District');
                  } else if (areaId == null &&
                      loginController.loginAreaId() == '0') {
                    MyComponents().wrongSnackBar(context, 'Please Select An Area');
                  } else if (timeId == null) {
                    MyComponents().wrongSnackBar(context, 'Please Select A Time');
                  } else if (selectDate == null) {
                    MyComponents().wrongSnackBar(context, 'Please Select A Date');
                  }
                }
              },
              child: Text(
                widget.type != 'update' ? "Continue" : 'Update Order',
                style: TextStyle(color: MyColors.buttonTextColor),
              ),
              style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(), elevation: 0),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void createOrder() {
    MyComponents().showLoaderDialog(context);

    order(context,
        warehouseId: '',
        timeSlotId: '$timeId',
        couponId: '',
        deliveryDate: '$selectDate',
        orderSource: 'App',
        paymentType: 'COD',
        totalQuantity: '${cartController.totalQuantity()}',
        subtotal: '${cartController.subTotalPrice()}',
        totalVatAmount: '${cartController.totalVat()}',
        shippingCost: '${cartController.deliveryCharge}',
        totalDiscountAmount: '${cartController.totalDiscount()}',
        couponDiscountAmount: 'couponDiscountAmount',
        name: widget.type != 'otp' ? fullName.text : fullNameController.text,
        phone: '${widget.phone ?? loginController.loginPhone()}',
        email: widget.type != 'otp' ? email : emailController.text,
        address: widget.type != 'otp' ? address.text : addressController.text,
        areaId: '${areaId != null ? areaId : loginController.loginAreaId()}',
        districtId:
            '${locController.districtId != null ? locController.districtId : loginController.loginDistrictId()}',
        zipCode: widget.type != 'otp' ? zipCode : zipCodeController.text,
        orderNote: orderNote.text,
        shipToDifferentAddress: selectCheck,
        receiverName: receiverFullNameCon.text,
        receiverPhone: receiverPhoneCon.text,
        receiverEmail: receiverEmailCon.text,
        receiverAddress: receiverAddressCon.text,
        receiverAreaId: '$receiverAreaId',
        receiverDistrictId: '${locController.receiverDistrictId}',
        receiverZipCode: receiverZipCodeCon.text,
        receiverOrderNote: receiverOrderNoteCon.text,
        productId: '${cartController.productId()}',
        purchasePrice: '${cartController.purchasePrice()}',
        salePrice: '${cartController.salePrice()}',
        quantity: '${cartController.quantitys()}',
        vatPercent: '${cartController.vatPercent()}',
        vatAmount: '${cartController.vatPercent()}',
        discountPercent: '${cartController.discountPercent()}',
        discountAmount: '${cartController.discountAmount()}',
        localId: '${cartController.localId()}',
        weight: '${cartController.weightIndividual()}',
        totalWeight: '${cartController.totalWeight()}',
        measurementSku: '${cartController.measurementSku()}',
        measurementValue: '${cartController.measurementValue()}',
        measurementTitle: '${cartController.measurementTitle()}');

    final login = Login(
      token: '${loginController.loginToken()}',
      name: '${widget.type != 'otp' ? fullName.text : fullNameController.text}',
      email:
          '${widget.type != 'otp' ? email.toString().contains('┤') ? email.toString().split('┤')[1].split('├')[0].replaceAll(' ', '') : email : emailController.text}',
      phone: '${widget.phone ?? loginController.loginPhone()}',
      user_id: int.parse(loginController.loginUserId()),
      customer_id: int.parse(loginController.loginCustomerId()),
      district_id: int.parse(
          '${locController.districtId != null ? locController.districtId : loginController.loginDistrictId() ?? '0'}'),
      district:
          '${locController.districtValue != null ? locController.districtValue : loginController.loginDistrict() ?? ''}',
      area_id: int.parse(
          '${areaId != null ? areaId : loginController.loginAreaId() ?? '0'}'),
      area:
          '${areaValue != null ? areaValue : loginController.loginArea() ?? ''}',
      address:
          '${widget.type != 'otp' ? address.text : addressController.text}',
      zip_code:
          '${widget.type != 'otp' ? zipCode.toString().contains('┤') ? zipCode.toString().split('┤')[1].split('├')[0].replaceAll(' ', '') : zipCode : zipCodeController.text}',
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
    });
  }

  void updateOrder() {
    MyComponents().showLoaderDialog(context);

    updateOrders(
      context,
      orderId: widget.orderId,
      token: loginController.loginToken(),
      name: widget.type != 'otp' ? fullName.text : fullNameController.text,
      phone: '${widget.phone ?? loginController.loginPhone()}',
      email:
          '${widget.type != 'otp' ? email.toString().contains('┤') ? email.toString().split('┤')[1].split('├')[0].replaceAll(' ', '') : email : emailController.text}',
      address:
          '${widget.type != 'otp' ? address.text : addressController.text}',
      areaId:
          '${areaId != null ? areaId : loginController.loginAreaId() ?? '0'}',
      districtId:
          '${locController.districtId != null ? locController.districtId : loginController.loginDistrictId() ?? '0'}',
      zipCode: widget.type != 'otp' ? zipCode : zipCodeController.text,
      orderNote: orderNote.text,
      shippingCost: '${cartController.deliveryCharge}',
      shipToDifferentAddress: selectCheck,
    );
  }
}

class DeliveryTimeWidget extends StatelessWidget {
  // const DeliveryTimeWidget({Key? key}) : super(key: key);
  String day;
  String date;
  bool select;
  DeliveryTimeWidget(
      {Key? key, required this.day, required this.date, required this.select})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      width: 80,
      decoration: BoxDecoration(
          color: select ? MyColors.primary : MyColors.shadow,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: select ? Colors.white : MyColors.primary,
                fontSize: 16),
          ),
          Text(
            date,
            style: TextStyle(
                color: select ? Colors.white : MyColors.primary, fontSize: 12),
          )
        ],
      ),
    );
  }
}
