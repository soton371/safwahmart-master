import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/controllers/sidebar_con.dart';
import 'package:grocery/views/all_product/all_product_screen.dart';
import 'package:grocery/views/category/child_categories_screen.dart';
import 'package:grocery/views/offer_products/offer_products_scr.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatefulWidget {
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  //const DrawerWidget({Key? key}) : super(key: key);
  var sidebarController = Get.put(SidebarController());

  List showChildCategories = [];

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40,left: 10,right: 10,bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/splash.png', height: 40,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('  Version',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                        Text('  1.0.14',
                          style: TextStyle(
                              color: MyColors.inactive,
                              fontSize: 12,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),

                  ],
                ),

                //offer
                // const Divider(thickness: 2,height: 25,),
                // InkWell(
                //   onTap: (){
                //     Navigator.push(context, MaterialPageRoute(builder: (_)=>const OfferProductsScreen()));
                //   },
                //   child: Row(
                //     children: [
                //       Image.asset('assets/images/discount.png',height: 30,),
                //       const Text('   Offers',style: TextStyle(fontSize: 18),),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),




          //for category list
          const Divider(),
          Expanded(
            child: ListView.builder(
                itemCount: sidebarController.sidebarItems.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 0,left: 10),
                itemBuilder: (_,i){

                  var data = sidebarController.sidebarItems;
                  showChildCategories.add(ShowChildCategories(false));

                  return Column(
                    children: [
                      InkWell(
                        onTap: ()=>Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                data[i]['child_categories_show_on_menu'].length == 0
                                    ? AllProductScreen(
                                  type: 'category',
                                  slug: data[i]['slug'],
                                )
                                    : ChildCategoriesScreen(
                                  reciever: 'drawer_widget',
                                  bannerImage: data[i]['banner_image'],
                                  title: data[i]['name'],
                                  length: data[i]['child_categories_show_on_menu']
                                      .length,
                                  value: data[i]['child_categories_show_on_menu'],
                                ))),
                        child: Row(
                          children: [
                            data[i]['icon'] != null ? CachedNetworkImage(imageUrl: '$imgBaseUrl/${data[i]['icon']}',height: 30,width: 30,):const Icon(Icons.image_outlined,size: 30,),
                            Text('   ${data[i]['name']}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),),
                            const Spacer(),
                            data[i]['child_categories_show_on_menu'].length != 0?
                            InkWell(
                                onTap: (){
                                  setState((){
                                    showChildCategories[i].show = !showChildCategories[i].show;
                                  });
                                },
                                child: showChildCategories[i].show?const Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.black54,): const Icon(Icons.keyboard_arrow_right, size: 30, color: Colors.black54,)
                            ): const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.transparent,),
                          ],
                        ),
                      ),
                      //for child categories
                      showChildCategories[i].show?
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: data[i]['child_categories_show_on_menu'].length,
                          itemBuilder: (_,index){
                            return InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_)=>AllProductScreen(
                                  type: 'category',
                                  slug: data[i]['child_categories_show_on_menu'][index]['slug'],
                                )));
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5,left: 50,bottom: 5),
                                child: Text('${data[i]['child_categories_show_on_menu'][index]['name']}',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54
                                  ),
                                ),
                              ),
                            );
                          }
                      ):const SizedBox(height: 0,),

                      const SizedBox(height: 5,)
                    ],
                  );
                }
            ),

          ),




          const Divider(),
          InkWell(
            onTap: (){
              throwUrl('https://play.google.com/store/apps/details?id=com.smartsoftware.sarabosorekrate');
            },
            child: Row(
              children: [
                const SizedBox(width: 8,),
                Image.asset('assets/images/star.png',height: 30,),
                const Text('   Rating Us',style: TextStyle(fontSize: 18),),
              ],
            ),
          ),
          const SizedBox(height: 10,)
        ],
      ),
    );
  }
}



//for show child categories (true,false)
class ShowChildCategories {
  bool show;
  ShowChildCategories(this.show);
}