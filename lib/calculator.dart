library calculator;

import 'dart:html';
import 'dart:collection';
import 'package:polymer/polymer.dart';
import 'package:decimal/decimal.dart';

@CustomTag('calculator-element')
class CalculatorElement extends PolymerElement {
  @observable Decimal current = new Decimal.fromInt(0);
  @observable List<Term> history = new ObservableList<Term>();

  int decimals = -1;
  int multi = 1;
  bool solved = false;

  BinaryOperation currentOperation;
  var operands = new Queue<Term>();
  var operations = new Queue<String>();

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
      _prepareNextTerm(target.dataset['op']);


  void solve(e, detail, target) {
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
      Term term = operands.removeFirst();
      history.insert(0, term);
      current = term.evaluate();
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

  void _prepareNextTerm(String operation) {
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
  String toString() => '$value';
}

class BinaryTerm extends Term {
  Term operand1, operand2;
  String operation;
  BinaryTerm._(this.operand1, this.operand2, this.operation);
  factory BinaryTerm(Term operand1, Term operand2, String operation) {
    if (operand1 is BinaryTerm
        && Operations.ops[operand1.operation].priority < Operations.ops[operation].priority) {
      BinaryTerm op1 = operand1;
      operand1 = op1.operand1;
      operand2 = new BinaryTerm(op1.operand2, operand2, operation);
      operation = op1.operation;
    }
    return new BinaryTerm._(operand1, operand2, operation);
  }
  Decimal evaluate() => Operations.ops[operation].op(operand1.evaluate(), operand2.evaluate());
  String toString() => '($operand1 ${Operations.ops[operation]} $operand2)';
}

class Operations {
  static Map<String, Operation> ops = {
                                     'multiplication': new Operation(multiplication, 2, '*'),
                                     'division': new Operation(division, 2, '/'),
                                     'addition': new Operation(addition, 1, '+'),
                                     'subtraction': new Operation(subtraction, 1, '-')
                                     };
  static Decimal addition(Decimal operand1, Decimal operand2) => operand1 + operand2;
  static Decimal subtraction(Decimal operand1, Decimal operand2) => operand1 - operand2;
  static Decimal multiplication(Decimal operand1, Decimal operand2) => operand1 * operand2;
  static Decimal division(Decimal operand1, Decimal operand2) => operand1 / operand2;
}

class Operation {
  BinaryOperation op;
  int priority;
  String display;
  Operation(this.op, this.priority, this.display);
  String toString() => display;
}

Decimal dec(dynamic value) {
  if (value is int) {
    return new Decimal.fromInt(value);
  } else if (value is String) {
    return Decimal.parse(value);
  }
  throw 'type ${value.runtimeType} of $value is not supported';
}
