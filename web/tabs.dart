library tabs;

import 'dart:html';
import 'package:polymer/polymer.dart';

class Item extends Object with ObservableMixin {
  @observable
  String id, label, content;
  Item(this.label, this.content);
}

@CustomTag('tabs-element')
class TabsElement extends PolymerElement with ObservableMixin {

  ObservableList<Item> items = new ObservableList<Item>();
  String selectedId;

  TabsElement() {
    items.changes.listen((List<ChangeRecord> records) {
      records.where((record) => record is ListChangeRecord).forEach((record) {
        var index = (record as ListChangeRecord).index;
        var addedCount = (record as ListChangeRecord).addedCount;

        for (int i = index; i < index + addedCount; i++) {
          items[i].id = 'tab$i';
        }
      });
    });
  }

  void selectTab(Event e, var detail, Node target) {
    var id = (target as DivElement).id;
    var contentSelector, labelSelector;
    if (id != selectedId && null != selectedId) {
      labelSelector = '#${selectedId}';
      contentSelector = '#${selectedId}_content';
      shadowRoot.query(labelSelector).classes.remove('selected');
      shadowRoot.query(contentSelector).classes.remove('selected');
    }
    selectedId = id;
    labelSelector = '#${selectedId}';
    contentSelector = '#${selectedId}_content';
    shadowRoot.query(labelSelector).classes.add('selected');
    shadowRoot.query(contentSelector).classes.add('selected');
  }
}