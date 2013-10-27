library calculator;

import 'dart:html';
import 'package:polymer/polymer.dart';


@CustomTag('calculator-element')
class CalculatorElement extends PolymerElement {
  @observable
  num display = 0;
  int decimals = 0;
  int multi = 1;

  CalculatorElement.created() : super.created();

  void numberPressed(Event e, var detail, ButtonElement target) {
    if (decimals > 0) {
      display = display + multi * int.parse(target.value) / decimals;
      decimals *= 10;
    } else {
      display = display * 10 + multi * int.parse(target.value);
    }
  }

  void decimalPressed(Event e, var detail, ButtonElement target) {
    if (decimals == 0) {
      decimals = 10;
    }
  }

  void switchSign(Event e, var detail, ButtonElement target) {
    multi = -multi;
    display = -display;
  }

}