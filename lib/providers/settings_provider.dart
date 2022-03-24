import 'package:flutter/material.dart';

enum RotationAxis {
  xyz,
  xzy,
  yxz,
  yzx,
  zxy,
  zyx
}

class Settings with ChangeNotifier {
  RotationAxis rotationAxis = RotationAxis.xyz;
  List<double> rotOffset = [0, 0, 0];
  List<double> rotMult = [1, 1, 1];

  void setRotationAxis(int index) {
    rotationAxis = RotationAxis.values[index];
    notifyListeners();
  }

  void setRotMult(double x, double y, double z) {
    rotMult = [x, y, z];
    notifyListeners();
  }

  void setRotOffset(double x, double y, double z) {
    rotOffset = [x, y, z];
    notifyListeners();
  }
}