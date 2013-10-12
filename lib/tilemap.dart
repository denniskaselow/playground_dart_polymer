library tilemap;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('tilemap-element')
class TilemapElement extends PolymerElement {
  var tiles = new ObservableList<String>();

  var dragEle;

  void dragstart(MouseEvent e, var detail, DivElement target) {
    dragEle = target;
    target.classes.add('ghost');
    e.dataTransfer.setData('content', target.innerHtml);
  }

  void dragend(MouseEvent e, var detail, DivElement target) {
    target.classes.remove('ghost');
  }

  void drop(MouseEvent e, var detail, DivElement target) {
    target.classes.remove('over');
    dragEle.innerHtml = target.innerHtml;
    target.innerHtml = e.dataTransfer.getData('content');
  }

  void dragenter(MouseEvent e, var detail, DivElement target) {
    target.classes.add('over');
  }

  void dragover(MouseEvent e, var detail, DivElement target) {
    e.preventDefault();
  }

  void dragleave(MouseEvent e, var detail, DivElement target) {
    target.classes.remove('over');
  }

}