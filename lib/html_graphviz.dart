library html_graphviz;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('html-graphviz-element')
class HtmlGraphviz extends PolymerElement {

  @observable Element root;
  @observable bool showShadowDom = false;

  List<String> _graph;
  int _elemCounter = 0;

  HtmlGraphviz.created() : super.created() {
    new PathObserver(this, 'root').changes.listen((_) => _graph = notifyPropertyChange(#graph, _graph, computeGraph()));
    new PathObserver(this, 'showShadowDom').changes.listen((_) => _graph = notifyPropertyChange(#graph, _graph, computeGraph()));
  }

  List<String> get graph => _graph;

  List<String> computeGraph() {
    _elemCounter = 0;
    if (null == root) {
      return [''];
    }
    var result = new List<String>();
    var child = document.documentElement;
    var childName = child.tagName.toLowerCase();
    var gvElem = new _GraphvizElem(_elemCounter++, child, 0);
    _createElemDefinition(gvElem, result);
    _createGraph(gvElem, result);
    return result;
  }

  void _createGraph(_GraphvizElem currentElement, List<String> result) {
    var children = currentElement.children;
    children.forEach((child) {
      addChildToGraph(currentElement, child, result);
    });
    if (showShadowDom) {
      if (currentElement.elem.shadowRoot != null) {
        currentElement.elem.shadowRoot.children.forEach((child) {
          addChildToGraph(currentElement, child, result);
        });
      }
    }
  }

  void addChildToGraph(_GraphvizElem currentElement, child, List<String> result) {
    var childName = child.tagName.toLowerCase();
    var gvElem = new _GraphvizElem(_elemCounter++, child, currentElement.depth + 1);

    _createElemDefinition(gvElem, result);
    result.add('${currentElement.id} -> ${gvElem.id};');
    _createGraph(gvElem, result);
  }

  void _createElemDefinition(_GraphvizElem gvElem, List<String> result) {
    double lightness = (gvElem.depth % 10) / 10;
    String l = lightness.toStringAsFixed(1);
    result.add('${gvElem.id} [color="0, 0, $l", label="${gvElem.label}"];');
  }
}

class _GraphvizElem {
  int id;
  Element elem;
  int depth;
  _GraphvizElem(this.id, this.elem, this.depth);

  List<Element> get children => elem.children;
  String get label => elem.tagName.toLowerCase();
}