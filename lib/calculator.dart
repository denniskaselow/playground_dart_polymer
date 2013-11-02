library calculator;

import 'dart:html';
import 'dart:collection';
import 'package:polymer/polymer.dart';
import 'package:decimal/decimal.dart';

@CustomTag('calculator-element')
class CalculatorElement extends PolymerElement {
  @observable Decimal current = new Decimal.fromInt(0);

  int decimals = -1;
  int multi = 1;
  bool solved = false;

  BinaryOperation currentOperation;
  var operands = new Queue<Term>();
  var operations = new Queue<BinaryOperation>();

  CalculatorElement.created() : super.created();

  void number(Event e, var detail, ButtonElement target) {
    if (solved) return;
    if (decimals == 0) {
      current = dec('$current.${target.value}');
      decimals++;
    } else if (decimals > 0) {
      current = dec('$current${target.value}');
      decimals++;
    } else {
      current = current * dec(10) + dec(multi) * dec(target.value);
    }
  }

  void decimal(Event e, var detail, ButtonElement target) {
    if (decimals == -1) {
      decimals = 0;
    }
  }

  void switchSign(Event e, var detail, ButtonElement target) {
    multi = -multi;
    current = -current;
  }

  void operation(Event e, var detail, ButtonElement target) =>
      _prepareNextTerm(Operations.op[target.dataset['op']]);


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
      solved = true;
    }
  }

  void removeLast(e, details, target) {
    if (solved) return;
    var asString = current.abs().toString();
    var cut;
    if (decimals > 0) {
      cut = decimals == 1 ? 2 : 1;
      decimals--;
    } else {
      cut = 1;
      decimals = -1;
    }
    if (asString.length == 1) {
      current = dec(0);
    } else {
      current = dec(multi) * dec(asString.substring(0, asString.length - cut));
    }
  }

  void clear(e, details, target) {
    operands.clear();
    operations.clear();
    solved = false;
    current = dec(0);
    decimals = -1;
    multi = 1;
  }

  void _prepareNextTerm(BinaryOperation operation) {
    operands.add(new NullaryTerm(current));
    operations.add(operation);
    solved = false;
    current = dec(0);
    decimals = -1;
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
  static Map<String, BinaryOperation> op = {'addition': addition,
                                     'subtraction': subtraction
                                     };
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
