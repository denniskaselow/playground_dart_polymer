library opinions;

import 'package:polymer/polymer.dart';

class Opinion extends Object with ObservableMixin {
  final String id;
  @observable
  String value;
  Opinion(this.id, [this.value = null]);
}

@CustomTag('opinions-element')
class OpinionsElement extends PolymerElement with ObservableMixin {

  final ObservableList<Opinion> opinions = new ObservableList<Opinion>();
  @observable
  int minValue = 0;
  @observable
  int maxValue = 9;

  OpinionsElement() {
    opinions.changes.listen((List<ChangeRecord> records) {
      records.forEach((record) {
        print(record);
      });
    });
  }
}