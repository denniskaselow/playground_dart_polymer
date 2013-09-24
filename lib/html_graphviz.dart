library html_graphviz;

import 'package:polymer/polymer.dart';

@CustomTag('html-graphviz-element')
class HtmlGraphviz extends PolymerElement with ObservableMixin {

  String get graph {
    return 'html -> head';
  }
}