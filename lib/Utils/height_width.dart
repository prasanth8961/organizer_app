import 'package:flutter/material.dart';



double height(double height , BuildContext ctx){
  return MediaQuery.of(ctx).size.height * height;
}


double width(double width , BuildContext ctx){
  return MediaQuery.of(ctx).size.height * width;
}