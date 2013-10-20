library tabs;

import 'dart:html';
import 'package:polymer/polymer.dart';

class Item extends Object with Observable {
  String id, label;
  Element content;
  Item(this.label, this.content);
}

@CustomTag('tabs-element')
class TabsElement extends PolymerElement {

  var items = new ObservableList<Item>();
  var itemMap = new Map<String, Item>();
  String selectedId;

  TabsElement.created() : super.created() {
    items.changes.listen((List<ChangeRecord> records) {
      records.where((record) => record is ListChangeRecord).forEach((record) {
        var index = (record as ListChangeRecord).index;
        var addedCount = (record as ListChangeRecord).addedCount;

        for (int i = index; i < index + addedCount; i++) {
          items[i].id = 'tab$i';
          itemMap['tab$i'] = items[i];
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
      shadowRoot.querySelector(labelSelector).classes.remove('selected');
      shadowRoot.querySelector(contentSelector).classes.remove('selected');
    }
    selectedId = id;
    labelSelector = '#${selectedId}';
    contentSelector = '#${selectedId}_content';
    shadowRoot.querySelector(labelSelector).classes.add('selected');
    var contentNode = shadowRoot.querySelector(contentSelector);
    contentNode.classes.add('selected');
    if (contentNode.children.isEmpty) {
      shadowRoot.querySelector(contentSelector).children.add(itemMap[selectedId].content);
    }
  }
}