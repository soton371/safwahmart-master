import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';

class CategoryWidget extends StatelessWidget {
  //const CategoryWidget({Key? key}) : super(key: key);

  String? myTitle, myImage;

  CategoryWidget(this.myTitle,this.myImage);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: MyColors.primary.withAlpha(40),
                borderRadius: BorderRadius.circular(10)
            ),
            child: Image(image: AssetImage(myImage??''))
        ),
        Text(myTitle??"",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            //fontSize: 20
          ),
        )
      ],
    );
  }
}
