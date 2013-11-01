library calculator;

import 'dart:html';
import 'dart:collection';
import 'package:polymer/polymer.dart';
import 'package:decimal/decimal.dart';

@CustomTag('calculator-element')
class CalculatorElement extends PolymerElement {
  @observable Decimal current = new Decimal.fromInt(0);

  int decimals = 0;
  int multi = 1;

  BinaryOperation operation;
  var operands = new Queue<Term>();
  var operations = new Queue<BinaryOperation>();

  CalculatorElement.created() : super.created();

  void number(Event e, var detail, ButtonElement target) {
    if (decimals > 0) {
      current = current + dec(multi) * dec(target.value) / dec(decimals);
      decimals *= 10;
    } else {
      current = current * dec(10) + dec(multi) * dec(target.value);
    }
  }

  void decimal(Event e, var detail, ButtonElement target) {
    if (decimals == 0) {
      decimals = 10;
    }
  }

  void switchSign(Event e, var detail, ButtonElement target) {
    multi = -multi;
    current = -current;
  }

  void addition(Event e, var detail, ButtonElement target) {
    _prepareNextTerm(Operations.addition);
  }

  void subtraction(Event e, var detail, ButtonElement target) {
    _prepareNextTerm(Operations.subtraction);
  }

  void evaluate(e, detail, target) {
    operands.add(new NullaryTerm(current));
    while (operations.isNotEmpty) {
      var operation = operations.removeFirst();
      var operand = new BinaryTerm(operands.removeFirst(), operands.removeFirst(), operation);
      operands.addFirst(operand);
    }
    if (operands.length != 1) {
      print('Something did not work as expected: $operands');
      throw 'Try again later, trying to figure out what went wrong.';
    } else {
      current = operands.removeFirst().evaluate();
    }
  }

  void _prepareNextTerm(BinaryOperation operation) {
    operands.add(new NullaryTerm(current));
    operations.add(operation);
    current = dec(0);
    decimals = 0;
    multi = 1;
  }
}

typedef Decimal BinaryOperation(Decimal operand1, Decimal operand2);

abstract class Term {
  Decimal evaluate();
}

class NullaryTerm extends Term {
  final Decimal value;
  NullaryTerm(this.value);
  Decimal evaluate() => value;
}

class BinaryTerm extends Term {
  Term operand1, operand2;
  BinaryOperation operation;
  BinaryTerm(this.operand1, this.operand2, this.operation);
  Decimal evaluate() => operation(operand1.evaluate(), operand2.evaluate());
}

class Operations {
  static Decimal addition(Decimal operand1, Decimal operand2) => operand1 + operand2;
  static Decimal subtraction(Decimal operand1, Decimal operand2) => operand1 - operand2;
}

Decimal dec(dynamic value) {
  if (value is int) {
    return new Decimal.fromInt(value);
  } else if (value is String) {
    return Decimal.parse(value);
  }
  throw 'type ${value.runtimeType} of $value is not supported';
}
