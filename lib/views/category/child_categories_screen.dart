import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/views/all_product/all_product_screen.dart';
import 'package:grocery/widgets/drawer_widget.dart';

class ChildCategoriesScreen extends StatefulWidget {
  // const ChildCategoriesScreen({Key? key}) : super(key: key);

  var title, length, value, reciever, bannerImage;
  ChildCategoriesScreen({this.title, this.length, this.value, this.reciever, this.bannerImage});

  @override
  State<ChildCategoriesScreen> createState() => _ChildCategoriesScreenState();
}

class _ChildCategoriesScreenState extends State<ChildCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyComponents().secondAppbar(context, '${widget.title}'),
      drawer: DrawerWidget(),
      body: ListView.builder(
          itemCount: widget.length,
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                print('Name: ${widget.value[i]['name']}');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) {
                          if(widget.reciever=='drawer_widget'){
                            return widget.value[i]['child_categories_show_on_menu']
                                .length ==
                                0
                                ? AllProductScreen(
                              type: 'category',
                              slug: widget.value[i]['slug'],
                            )
                                : ChildCategoriesScreen(
                              title: widget.value[i]['name'],
                              bannerImage: widget.value[i]['banner_image'],
                              length: widget
                                  .value[i]['child_categories_show_on_menu']
                                  .length,
                              value: widget.value[i]
                              ['child_categories_show_on_menu'],
                            );
                          }else{
                            return  widget.value[i]['child_categories']
                                .length ==
                                0
                                ? AllProductScreen(
                              type: 'category',
                              slug: widget.value[i]['slug'],
                            )
                                : ChildCategoriesScreen(
                              title: widget.value[i]['name'],
                              length: widget
                                  .value[i]['child_categories']
                                  .length,
                              value: widget.value[i]
                              ['child_categories'],
                            );
                          }
                        } ));
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    image:widget.bannerImage == null ? const DecorationImage(
                      image: AssetImage(
                          'assets/images/33-333216_no-offers-available-promotional-schemes.png'),
                      fit: BoxFit.cover,
                    ):
                    DecorationImage(
                        image: NetworkImage('$imgBaseUrl/${widget.bannerImage}'),
                      fit: BoxFit.cover,
                    ),
                    border: const Border(
                        bottom: BorderSide(color: Colors.white, width: 1))),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 0,
                    sigmaY: 0,
                  ),
                  child: Container(
                    color: Colors.black12,
                    height: 150,
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      // '${widget.bannerImage}',
                      '${widget.value[i]['name']}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}


/*
widget
                                    .value[i]['child_categories_show_on_menu']
                                    .length ==
                                0
                            ? AllProductScreen(
                                type: 'category',
                                slug: widget.value[i]['slug'],
                              )
                            : ChildCategoriesScreen(
                                title: widget.value[i]['name'],
                                length: widget
                                    .value[i]['child_categories_show_on_menu']
                                    .length,
                                value: widget.value[i]
                                    ['child_categories_show_on_menu'],
                              )
 */