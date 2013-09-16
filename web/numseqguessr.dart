library numseqguessr;

import 'dart:math';
import 'package:polymer/polymer.dart';

var random = new Random();

abstract class SequenceGenerator {
  Sequence generate();
  SequenceGenerator._();
  factory SequenceGenerator() {
    int genId = random.nextInt(2);
    switch (genId) {
      case 0: return new IncremetingSequenceGenerator();
      case 1: return new QuadraticSequenceGenerator();
    }
  }
  int get start => random.nextInt(20);
  int get count => 5;
}

class IncremetingSequenceGenerator extends SequenceGenerator {
  IncremetingSequenceGenerator() : super._();
  Sequence generate() {
    var s = start;
    var step = random.nextInt(100);
    var numbers = new List(count);
    for (int i = 0; i < count; i++) {
      numbers[i] = s + i * step;
    }
    return new Sequence(numbers, s + count * step);
  }
}

class QuadraticSequenceGenerator extends SequenceGenerator {
  QuadraticSequenceGenerator() : super._();
  Sequence generate() {
    var s = start;
    var numbers = new List(count);
    for (int i = 0; i < count; i++) {
      numbers[i] = (s+i) * (s+i);
    }
    return new Sequence(numbers,  (s+count)*(s+count));
  }
}

class Sequence extends Object with ObservableMixin {
  List<num> numbers;
  num expectedSolution;
  @observable
  String solution;
  Sequence(this.numbers, this.expectedSolution) {
    bindProperty(this, const Symbol('solution'), () => notifyProperty(this, const Symbol('solutionBackground')));
  }

  String get solutionBackground {
    if (null == solution || '' == solution) return '#ddd';
    if (expectedSolution.toString() == solution) return '#9e9';
    return '#F99';
  }
}

@CustomTag('numseqguessr-element')
class NumseqguessrElement extends PolymerElement with ObservableMixin {
  var sequences = new ObservableList<Sequence>();
}