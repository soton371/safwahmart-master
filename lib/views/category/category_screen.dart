import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/configurations/my_sizes.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/views/all_product/all_product_screen.dart';
import 'package:grocery/views/category/child_categories_screen.dart';
import 'package:grocery/widgets/drawer_widget.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  //for pagination
  final scrollController = ScrollController();
  List items = [];
  int page = 1;
  bool hasMore = true;

  Future fetch() async {
    const limit = 20;

    var url = Uri.parse('$baseUrl/get-categories?page=$page');
    var res = await http.get(url);

    var status = json.decode(res.body)['status'];

    if (status == 1) {
      final List newItems = json.decode(res.body)['data']['categories']['data'];

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

  @override
  void initState() {
    fetch();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        fetch();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyComponents().secondAppbar(context, 'All Category'),
        drawer: DrawerWidget(),
        body:hasMore?const Center(child: CircularProgressIndicator()): StaggeredGridView.countBuilder(
            padding: EdgeInsets.symmetric(
                horizontal: MySizes.bodyPadding,
                vertical: MySizes.containInsidePadding),
            crossAxisCount: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            itemCount: items.length + 1,
            itemBuilder: (_, i) {
              if (i < items.length) {
                var data = items;

                return Card(
                  elevation: 5,
                  child: InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                            data[i]['child_categories'].length == 0
                                ? AllProductScreen(
                              type: 'category',
                              slug: data[i]['slug'],
                            )
                                : ChildCategoriesScreen(
                              reciever: 'category_screen',
                              bannerImage: data[i]['banner_image'],
                              title: data[i]['name'],
                              length: data[i]
                                  ['child_categories']
                                  .length,
                              value: data[i]['child_categories'],
                            ))),

                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 5, right: 5, top: 5, bottom: 8),
                      child: Column(
                        children: [
                          data[i]['image'] != null
                              ? CachedNetworkImage(imageUrl: '$imgBaseUrl/${data[i]['image']}',fit: BoxFit.fill, height: 110, width: double.infinity,)

                              : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/picture.png',
                              height: 65,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text('${data[i]['name']}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),),
                        ],
                      ),
                    ),
                  ),
                );
              }else{
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: hasMore? const CircularProgressIndicator():const Text(''),
                  ),
                );
              }
            },
            staggeredTileBuilder: (i) => const StaggeredTile.fit(1))
    );
  }
}


