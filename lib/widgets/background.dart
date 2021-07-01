import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: Duration(milliseconds: 1200),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/fondo.jpg'),
                    fit: BoxFit.cover)),
          ),
          Container(
            color: Colors.grey.withOpacity(0.6),
          )
        ],
      ),
    );
  }
}