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
  String positionAxis = "xyz";
  String rotationAxis = "xyz";
  List<double> rotOffset = [0, 0, 0];
  List<double> rotMult = [1, 1, 1];
  List<double> posMult = [1, 1, 1];

  void setPositionAxis(String value) {
    positionAxis = value;
    notifyListeners();
  }

  void setRotationAxis(String value) {
    rotationAxis = value;
    notifyListeners();
  }

  void setPosMult(double x, double y, double z) {
    posMult = [x, y, z];
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