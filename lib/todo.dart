import 'package:flutter/material.dart';
import 'card.dart';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';


class todoButton extends StatelessWidget {

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          //other page content
          Container(
          //add it here
          ),
          //add icon
          Positioned(
            right: 60.0,
            bottom: 60.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  HeroDialogRoute(
                      builder: (context) => todoCard()
                  ),
                );
              },
              child: Hero(
                  createRectTween: (begin, end) {
                    return CustomRectTween(begin: begin, end: end);
                  },
                  tag: "Popup",
                  child: Container(
                      height: 60.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                        color: Color(0xFF17C3B2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Image(
                          image: AssetImage(
                              'assets/images/add_icon.png'
                          )
                      )
                  )
              ),
            ),
          ),
        ]
      ),
    );

  }
}

