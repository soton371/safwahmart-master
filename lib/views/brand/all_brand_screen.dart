import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/configurations/my_sizes.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/views/cart/CartScreen.dart';
import 'package:grocery/widgets/drawer_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:recase/recase.dart';


class AllBrandScreen extends StatefulWidget {
  const AllBrandScreen({Key? key}) : super(key: key);

  @override
  _AllBrandScreenState createState() => _AllBrandScreenState();
}

class _AllBrandScreenState extends State<AllBrandScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyComponents().secondAppbar(context, 'All Brands'),
      drawer: DrawerWidget(),
      body: FutureBuilder(
          future: fetchGetBrands(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return snapshot.hasData ? StaggeredGridView.countBuilder(
                padding: EdgeInsets.symmetric(horizontal: MySizes.bodyPadding,vertical: MySizes.containInsidePadding),
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                itemCount: snapshot.data.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_,i){
                  var data = snapshot.data;
                  return Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 20),
                      child: Column(
                        children: [
                          data[i].logo != null ? Image.network('$imgBaseUrl/${data[i].logo}',height: 80,) : Image.asset('assets/images/picture.png',height: 80, color: MyColors.inactive,),
                          const SizedBox(height: 10,),
                          Text(data[i].name.toString()),
                        ],
                      ),
                    ),
                  );
                },
                staggeredTileBuilder: (i) => const StaggeredTile.fit(1)
            ):const Center(child: CircularProgressIndicator(),);
          }
      ),
    );
  }
}
