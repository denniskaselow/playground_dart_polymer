library tilemap;

import 'dart:html';
import 'dart:convert';
import 'dart:async';
import 'package:polymer/polymer.dart';

@CustomTag('tilemap-element')
class TilemapElement extends PolymerElement {
  var tilemap = new ObservableMap<int, Tile>();
  var tileIds = new ObservableList<int>();
  var suggestions = new ObservableMap<String, String>();
  var suggestionIds = new ObservableList<String>();

  // weird behaviour requires weird code :(. leave event gets fired after
  // entering the parent when switching from child to parent in animation
  var inElement = new Map<int, int>();
  int draggedId;
  @observable
  String searchTerm, steamPath;
  @observable
  String result;
  @observable
  String gameCount = '0';
  @observable
  bool connected = false;


  TilemapElement() {
    tilemap.changes.listen((List<ChangeRecord> records) {
      records.where((record) => record is MapChangeRecord).forEach((MapChangeRecord record) {
        if (record.isInsert) {
          tileIds.add(record.key);
          inElement[record.key] = 0;
        }
      });
    });
    connectWebsocket();
  }

  void connectWebsocket() {
    WebSocket socket = new WebSocket('ws://127.0.0.1:8081');
    socket.onMessage.listen((msgEvent) => gameCount = msgEvent.data);
    socket.onError.listen((_) {
      print('Could not create WebSocket. Is the server running? Retrying in 10 seconds.');
      new Timer(new Duration(seconds: 10), connectWebsocket);
    });
    socket.onOpen.listen((_) => connected = true);
  }

  void searchTermChanged(String value) {
    HttpRequest.getString(Uri.encodeFull('http://127.0.0.1:8080/?term=$searchTerm')).then((data) {
      suggestions.clear();
      suggestions.addAll(JSON.decode(data));
      suggestionIds.clear();
      suggestionIds.addAll(suggestions.keys);
      suggestionIds.removeWhere((id) => tileIds.contains(int.parse(id)));
    });
  }

  void steamPathChanged(String value) {
    HttpRequest.getString(Uri.encodeFull('http://127.0.0.1:8080/?path=$steamPath'));
  }

  void addToTiles(MouseEvent e, var detail, Element target) {
    var id = int.parse(target.dataset['id']);
    suggestionIds.remove('$id');
    tilemap[id] = new Tile(id);
  }

  void startGame(MouseEvent e, var detail, Element target) {
    var id = int.parse(target.parent.dataset['id']);
    HttpRequest.getString(Uri.encodeFull('steam://run/$id'));
  }

  void dragstart(MouseEvent e, var detail, Element target) {
    target.classes.add('ghost');
    draggedId = int.parse(target.parent.dataset['id']);
  }

  void dragend(MouseEvent e, var detail, Element target) {
    target.classes.remove('ghost');
  }

  void drop(MouseEvent e, var detail, Element target) {
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

  void dragenter(MouseEvent e, var detail, Element target) {
    if (target.classes.contains('tile')) {
      target = target.parent;
    }
    var id = getTileId(target);
    inElement[id]++;
    if (id != draggedId) {
      target.classes.add('over');
    }
  }

  void dragover(MouseEvent e, var detail, Element target) {
    e.preventDefault();
  }

  void dragleave(MouseEvent e, var detail, Element target) {
    if (target.classes.contains('tile')) {
      target = target.parent;
    }
    var id = getTileId(target);
    inElement[id]--;
    if (inElement[id] == 0) {
      target.classes.remove('over');
    }
  }

  int getTileId(Element target) {
    return int.parse(target.dataset['id']);
  }
}

class Tile {
  int id;
  Tile(this.id);
}