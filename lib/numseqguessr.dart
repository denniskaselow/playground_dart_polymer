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

class Sequence extends Object with Observable {

  @observable String solution;
  @observable String solutionBackground = '#ddd';

  List<num> numbers;
  num expectedSolution;

  Sequence(this.numbers, this.expectedSolution) {
    new PathObserver(this, 'solution').changes.listen((record) => solutionChanged(solution));
  }

  void solutionChanged(String value) {
    if (expectedSolution.toString() == solution) {
      solutionBackground = '#9e9';
    } else {
      solutionBackground = '#f99';
    }
  }

}

@CustomTag('numseqguessr-element')
class NumseqguessrElement extends PolymerElement {
  NumseqguessrElement.created() : super.created();

  var sequences = new ObservableList<Sequence>();
}