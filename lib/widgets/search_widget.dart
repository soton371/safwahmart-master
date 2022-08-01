import 'package:flutter/material.dart';
import 'package:grocery/configurations/my_colors.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: MyColors.primary,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: TextFormField(
          decoration: const InputDecoration(
              hintText: 'Search Products',
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none
          ),
        ),
      ),
    );
  }
}
