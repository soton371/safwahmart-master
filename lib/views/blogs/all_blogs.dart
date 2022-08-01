import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:grocery/configurations/my_colors.dart';
import 'package:grocery/configurations/my_components.dart';
import 'package:grocery/configurations/my_sizes.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/views/blogs/blog_details.dart';
import 'package:shimmer/shimmer.dart';
import 'package:recase/recase.dart';


class AllBlogsScreen extends StatefulWidget {
  const AllBlogsScreen({Key? key}) : super(key: key);

  @override
  _AllBlogsScreenState createState() => _AllBlogsScreenState();
}

class _AllBlogsScreenState extends State<AllBlogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyComponents().secondAppbar(context, 'All Blogs'),
      body: FutureBuilder(
          future: fetchGetBlogs(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            return snapshot.hasData ? StaggeredGridView.countBuilder(
                padding: EdgeInsets.symmetric(horizontal: MySizes.bodyPadding,vertical: MySizes.containInsidePadding),
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                itemCount: snapshot.data.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_,i){
                  var data = snapshot.data[i];
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => BlogDetails(
                        blogImage: data.image ?? null, blogTitle: data.name, blogDescription: data.description, createdAt: data.createdAt,
                      )));
                    },
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 20),
                        child: Column(
                          children: [
                            data.image != null ? Image.network('$imgBaseUrl/${data.image}',height: 80,) : Image.asset('assets/images/picture.png',height: 80, color: MyColors.inactive,),

                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                Icon(Icons.date_range,color: MyColors.primary,size: 14,),
                                Text(data.createdAt.toString().substring(0,10),textAlign: TextAlign.start,style: TextStyle(
                                  color: MyColors.primary
                                ),),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            Align(
                              alignment: Alignment.centerLeft,
                                child: Text(data.name.toString(),textAlign: TextAlign.start),
                            ),
                          ],
                        ),
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
