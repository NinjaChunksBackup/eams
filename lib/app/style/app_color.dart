import 'package:flutter/cupertino.dart';

class AppColor {

  static Color primary = Color(0xFF635BFF); 
  static Color primarySoft = Color(0xFF7578FF); 
  static Color primaryExtraSoft = Color(0xFFC2CBFF); 

  // Nevada shades
  static Color secondary = Color(0xFF32383E); 
  static Color secondarySoft = Color(0xFF636B74);
  static Color secondaryExtraSoft = Color(0xFFDDDFE4); 

  // Gradient using primary colors
  static LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFF432AD8)], 
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Error
  static Color error = Color(0xFFF04438); 

  // Success
  static Color success = Color(0xFF15B79F); 

  // Warning
  static Color warning = Color(0xFFFB9C0C); 
}
