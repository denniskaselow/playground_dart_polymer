library opinions;

import 'package:polymer/polymer.dart';

class Question {
  static int _count = 0;
  String id;
  String question;
  List<String> answers;
  Question(this.question, this.answers) {
    id = 'q${_count++}';
  }
}

class Opinion extends Object with ObservableMixin {
  String id;
  @observable
  String value;
  Opinion(this.id, [this.value]);
  Opinion otherOpinion(String value) {
    return new Opinion(id, value);
  }
}

class OpinionMatcher extends Object with ObservableMixin {
  final Map<String, Opinion> otherOpinions;
  @observable
  final Opinion userOpinion;
  final int minValue;
  final int maxValue;
  int maxDiff;

  OpinionMatcher(this.userOpinion, this.otherOpinions, {this.minValue: 1, this.maxValue: 10}) {
    maxDiff = maxValue - minValue;
    bindProperty(userOpinion, const Symbol('value'), () => notifyProperty(this, const Symbol('value')));
    bindProperty(userOpinion, const Symbol('value'), () => notifyProperty(this, const Symbol('getMatch')));
  }

  String get id => userOpinion.id;

  String get value => userOpinion.value;
  void set value(String value) {
    userOpinion.value = value;
  }

  double _getMatch(String groupId) {
    if (null == userOpinion.value) return null;
    var other = int.parse(otherOpinions[groupId].value);
    var user = int.parse(userOpinion.value);
    var diff = 1 - ((other - user).abs() / maxDiff);
    return diff;
  }

  String getMatch(String groupId) {
    var match = _getMatch(groupId);
    if (null == match) return 'you have to decide!';
    return (match*100).toStringAsFixed(2) + '%';
  }
}

@CustomTag('opinions-element')
class OpinionsElement extends PolymerElement with ObservableMixin {

  final ObservableList<OpinionMatcher> opinions = new ObservableList<OpinionMatcher>();
  final ObservableList<String> otherOpinions = new ObservableList<String>();
  final ObservableMap<String, Question> questions = new ObservableMap<String, Question>();

  OpinionsElement() {
    opinions.changes.listen((List<ChangeRecord> records) {
      records.where((record) => record is ListChangeRecord).forEach((record) {
        var index = (record as ListChangeRecord).index;
        var addedCount = (record as ListChangeRecord).addedCount;

        for (int i = index; i < index + addedCount; i++) {
          bindProperty(opinions[i], const Symbol('value'), () => notifyProperty(this, const Symbol('getTotalMatch')));
        }
      });
    });
  }

  String getTotalMatch(String groupId) {
    var match = 0.0;
    for (var opinion in opinions) {
      var singleMatch = opinion._getMatch(groupId);
      if (null != singleMatch) {
        match += opinion._getMatch(groupId) / opinions.length;
      }
    }
    return (match*100).toStringAsFixed(2) + '%';
  }
}