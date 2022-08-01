import 'package:flutter/material.dart';
import 'package:grocery/widgets/appbar_widget.dart';
import 'package:grocery/widgets/drawer_widget.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: DrawerWidget(),
      body: Container(
        child: Column(
          children: [
            Text('Total: 3567 Points'),

          ],
        ),
      ),
    );
  }
}
