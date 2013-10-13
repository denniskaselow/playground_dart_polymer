library tilemap;

import 'dart:html';
import 'package:polymer/polymer.dart';

@CustomTag('tilemap-element')
class TilemapElement extends PolymerElement {
  var tilemap = new ObservableMap<int, Tile>();
  var tileIds = new ObservableList<int>();

  // weird behaviour requires weird code :(. leave event gets fired after
  // entering the parent when switching from child to parent in animation
  var inElement = new Map<int, int>();
  int draggedId;

  TilemapElement() {
    tilemap.changes.listen((List<ChangeRecord> records) {
      records.where((record) => record is MapChangeRecord).forEach((MapChangeRecord record) {
        if (record.isInsert) {
          tileIds.add(record.key);
          inElement[record.key] = 0;
        }
      });
    });
  }

  void dragstart(MouseEvent e, var detail, DivElement target) {
    target.classes.add('ghost');
    draggedId = int.parse(target.parent.dataset['id']);
  }

  void dragend(MouseEvent e, var detail, DivElement target) {
    target.classes.remove('ghost');
  }

  void drop(MouseEvent e, var detail, DivElement target) {
    if (target.classes.contains('tile')) {
      target = target.parent;
    }
    target.classes.remove('over');
    var currentId = int.parse(target.dataset['id']);
    bool isCurrentElement = currentId != draggedId;
    if (isCurrentElement) {
      var index = tileIds.indexOf(currentId);
      tileIds.remove(draggedId);
      tileIds.insert(index, draggedId);
    }
  }

  void dragenter(MouseEvent e, var detail, DivElement target) {
    if (target.classes.contains('tile')) {
      target = target.parent;
    }
    var id = getTileId(target);
    inElement[id]++;
    if (id != draggedId) {
      target.classes.add('over');
    }
  }

  void dragover(MouseEvent e, var detail, DivElement target) {
    e.preventDefault();
  }

  void dragleave(MouseEvent e, var detail, DivElement target) {
    if (target.classes.contains('tile')) {
      target = target.parent;
    }
    var id = getTileId(target);
    inElement[id]--;
    if (inElement[id] == 0) {
      target.classes.remove('over');
    }
  }

  int getTileId(DivElement target) {
    return int.parse(target.dataset['id']);
  }
}

class Tile {
  int id;
  Tile(this.id);
}