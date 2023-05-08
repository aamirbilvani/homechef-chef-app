import 'package:flutter/material.dart';

class DishImage extends StatelessWidget {
  final String image;

  DishImage(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(5, 5, 10, 5),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(image,
                height: 120, width: 120, fit: BoxFit.cover)));
  }
}
