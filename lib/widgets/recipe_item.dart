import 'package:flutter/material.dart';

class RecipeItem extends StatelessWidget {
  final String imageUrl;
  final String title;

  RecipeItem({@required this.title, @required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: Image.network(
            imageUrl,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 20,
          right: 10,
          child: Container(
            width: 320,
            color: Colors.black54,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Text(
              title,
              style: TextStyle(fontSize: 26, color: Colors.white),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      ],
    );
  }
}
