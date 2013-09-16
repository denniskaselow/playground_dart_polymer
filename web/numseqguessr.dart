library numseqguessr;

import 'package:polymer/polymer.dart';


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