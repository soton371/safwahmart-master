import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/cart_con.dart';
import 'package:grocery/controllers/login_con.dart';
import 'package:grocery/views/cart/CartScreen.dart';
import 'package:http/http.dart' as http;


class StockRequestScreen extends StatefulWidget {
  const StockRequestScreen({Key? key}) : super(key: key);

  @override
  State<StockRequestScreen> createState() => _StockRequestScreenState();
}

class _StockRequestScreenState extends State<StockRequestScreen> {

  var cartController  = Get.put(CartController());
  var loginController = Get.put(LoginController());


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
        title: Text('Stock Request',style: TextStyle(color: MyColors.primary,fontWeight: FontWeight.normal),),
        actions: [
          const SizedBox(width: 8,),
          Column(
            children: [
              const SizedBox(height: 18,),
              InkWell(
                  onTap: (){
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
        future: getProductRequest(context: context,userId: loginController.loginCustomerId(),token: loginController.loginToken().toString()),
          //future: fetchWishlist(loginController.loginUserId(), loginController.loginToken().toString()),
          builder: (BuildContext context,AsyncSnapshot snapshot){
            return snapshot.hasData ?
            ListView.builder(
                itemCount: snapshot.data.length+1,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_,i){
                  var data = snapshot.data;

                  if(i<snapshot.data.length){
                    return Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: MyColors.shadow))
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          CachedNetworkImage(imageUrl: '$imgBaseUrl/${data[i]['product']['thumbnail_image']}',height: 65,width: 65,),

                          const SizedBox(width: 10,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Container(
                                padding: const EdgeInsets.only(bottom: 4),
                                constraints: const BoxConstraints(
                                  minWidth: 0,
                                  minHeight: 0,
                                  maxWidth: 135,
                                  maxHeight: 150,
                                ),
                                child: Text('${data[i]['product']['name']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),

                              Text('৳${data[i]['product']['sale_price']}'),



                            ],
                          ),

                          const Spacer(),

                          //for delete
                          IconButton(
                            padding: EdgeInsets.all(2),
                            onPressed: () async {
                              var url = Uri.parse('$baseUrl/delete-from-stock-request/${data[i]['id']}');
                              var res = await http.delete(url,headers: {
                                HttpHeaders.authorizationHeader: 'Bearer ${loginController.loginToken()}'
                              });

                              var status = json.decode(res.body)['status'];


                              switch(status){
                                case 1:
                                  {
                                    setState((){
                                      data.removeAt(i);
                                    });
                                    MyComponents().wrongSnackBar(context, 'Delete item from stock request');
                                  }
                                  break;
                                case 0:
                                  {
                                    print('object: something wrong delete stock request');
                                  }
                              }

                              //deleteWishlist(context, '${data[i]['id']}', loginController.loginToken().toString());
                            },
                            icon: Image.asset('assets/images/delete.png',height: 20,color: MyColors.red,),
                          ),


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
                          const Text('\nYour stock request is empty',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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

