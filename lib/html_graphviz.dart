library html_graphviz;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('html-graphviz-element')
class HtmlGraphviz extends PolymerElement with ObservableMixin {

  @observable
  Element root;

  int _elemCounter = 0;

  HtmlGraphviz() {
    bindProperty(this, const Symbol('root'), () => notifyProperty(this, const Symbol('graph')));
  }

  List<String> get graph {
    if (null == root) {
      return [''];
    }
    var result = new List<String>();
    var child = document.documentElement;
    var childName = child.tagName.toLowerCase();
    var gvElem = new _GraphvizElem(_elemCounter++, child);
    _createElemDefinition(gvElem, result);
    _createGraph(gvElem, result);
    return result;
  }

  void _createGraph(_GraphvizElem currentElement, List<String> result) {
    var children = currentElement.children;
    children.forEach((child) {
      var childName = child.tagName.toLowerCase();
      var gvElem = new _GraphvizElem(_elemCounter++, child);

      _createElemDefinition(gvElem, result);
      result.add('${currentElement.id} -> ${gvElem.id};');
      _createGraph(gvElem, result);
    });
  }

  void _createElemDefinition(gvElem, result) {
    result.add('${gvElem.id} [color="0.0, 0.0, 0.85", label="${gvElem.label}"];');
  }
}

class _GraphvizElem {
  int id;
  Element elem;
  _GraphvizElem(this.id, this.elem);

  List<Element> get children => elem.children;
  String get label => elem.tagName.toLowerCase();
}