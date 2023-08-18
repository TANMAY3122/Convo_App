import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderWindow extends StatelessWidget {
  final itemscolor;
  const SliderWindow({Key? key, required this.itemscolor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: itemscolor,
      options: CarouselOptions(),
    );
  }
}
