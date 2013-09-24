library html_graphviz;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('html-graphviz-element')
class HtmlGraphviz extends PolymerElement with ObservableMixin {

  int _elemCounter = 0;

  List<String> get graph {
    if (null == parent) {
      return [''];
    }
    var result = new List<String>();
    var child = document.documentElement;
    var childName = child.tagName.toLowerCase();
    var gvElem = new _GraphvizElem('$childName${_elemCounter++}', child);
    result.add('"${gvElem.id}" [color="0.0, 0.0, 0.85", label="${gvElem.label}"];');
    _createGraph(gvElem, result);
    return result;
  }

  void _createGraph(_GraphvizElem currentElement, List<String> result) {
    var children = currentElement.children;
    children.forEach((child) {
      var childName = child.tagName.toLowerCase();
      var gvElem = new _GraphvizElem('$childName${_elemCounter++}', child);
      result.add('"${gvElem.id}" [color="0.0, 0.0, 0.85", label="${gvElem.label}"];');
      result.add('"${currentElement.id}" -> "${gvElem.id}";');
      _createGraph(gvElem, result);
    });
  }
}

class _GraphvizElem {
  String id;
  Element elem;
  _GraphvizElem(this.id, this.elem);

  List<Element> get children => elem.children;
  String get label => elem.tagName.toLowerCase();
}