library weight_watch;

import 'package:polymer/polymer.dart';

@CustomTag('weight-watch-element')
class WeightWatchElement extends PolymerElement with ObservableMixin {

  @observable
  String currentWeight, targetWeight, targetDate;
  double _currentWeight, _targetWeight;

  int weeksLeft;
  int daysLeft;

  WeightWatchElement() {
    bindProperty(this, const Symbol('targetDate'), () {
      var diff = DateTime.parse(targetDate).difference(new DateTime.now());
      daysLeft = diff.inDays;
      weeksLeft = daysLeft ~/ 7;
      notifyProperty(this, const Symbol('timeLeft'));
      notifyProperty(this, const Symbol('lossPerDay'));
      notifyProperty(this, const Symbol('lossPerWeek'));
    });
    bindProperty(this, const Symbol('currentWeight'), () {
      _currentWeight = double.parse(currentWeight);
      notifyProperty(this, const Symbol('lossPerDay'));
      notifyProperty(this, const Symbol('lossPerWeek'));
    });
    bindProperty(this, const Symbol('targetWeight'), () {
      _targetWeight = double.parse(targetWeight);
      notifyProperty(this, const Symbol('lossPerDay'));
      notifyProperty(this, const Symbol('lossPerWeek'));
    });
  }

  String get timeLeft {
    if (null == daysLeft) return '';
    return daysLeft.toString();
  }

  String get lossPerDay {
    if (null == daysLeft || null == _currentWeight || null == _targetWeight) return '';
    return ((_targetWeight - _currentWeight) / daysLeft).toStringAsFixed(2);
  }

  String get lossPerWeek {
    if (null == weeksLeft || null == _currentWeight || null == _targetWeight) return '';
    return ((_targetWeight - _currentWeight) / weeksLeft).toStringAsFixed(2);
  }

}
