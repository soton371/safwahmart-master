import 'package:flutter/material.dart';
import 'package:grocery/controllers/apis.dart';
import 'package:grocery/widgets/appbar_widget.dart';

class BlogDetails extends StatelessWidget {

  var blogImage, blogTitle, blogDescription, createdAt;
  BlogDetails({this.blogImage, this.blogTitle, this.blogDescription, this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network('$imgBaseUrl/$blogImage'),

              Text('\n$blogTitle\n', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),

              Text(blogDescription)
            ],
          ),
        ),
      ),
    );
  }
}
