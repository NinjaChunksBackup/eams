import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  final double height;
  final double width;

  const LogoWidget({
    Key? key,
    this.height = 60,
    this.width = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      height: height,
      width: width,
      fit: BoxFit.contain,
    );
  }
}