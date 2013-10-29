library weight_watch;

import 'package:polymer/polymer.dart';

@CustomTag('weight-watch-element')
class WeightWatchElement extends PolymerElement {

  @observable String currentWeight, targetWeight, targetDate;

  double _currentWeight, _targetWeight;
  String _lossPerDay, _lossPerWeek, _timeLeft;

  int weeksLeft;
  int daysLeft;

  WeightWatchElement.created() : super.created() {
    new PathObserver(this, 'targetDate').changes.listen((_) {
      var diff = DateTime.parse(targetDate).difference(new DateTime.now());
      daysLeft = diff.inDays;
      weeksLeft = daysLeft ~/ 7;
      _timeLeft = notifyPropertyChange(#timeLeft, _timeLeft, computeTimeLeft());
      _lossPerDay = notifyPropertyChange(#lossPerDay, _lossPerDay, computeLossPerDay());
      _lossPerWeek = notifyPropertyChange(#lossPerWeek, _lossPerWeek, computeLossPerWeek());
    });
    new PathObserver(this, 'currentWeight').changes.listen((_) {
      _currentWeight = double.parse(currentWeight);
      _lossPerDay = notifyPropertyChange(#lossPerDay, _lossPerDay, computeLossPerDay());
      _lossPerWeek = notifyPropertyChange(#lossPerWeek, _lossPerWeek, computeLossPerWeek());
    });
    new PathObserver(this, 'targetWeight').changes.listen((_) {
      _targetWeight = double.parse(targetWeight);
      _lossPerDay = notifyPropertyChange(#lossPerDay, _lossPerDay, computeLossPerDay());
      _lossPerWeek = notifyPropertyChange(#lossPerWeek, _lossPerWeek, computeLossPerWeek());
    });
  }

  String get timeLeft => _timeLeft;
  String get lossPerDay => _lossPerDay;
  String get lossPerWeek => _lossPerWeek;


  String computeTimeLeft() {
    if (null == daysLeft) return '';
    return daysLeft.toString();
  }

  String computeLossPerDay() {
    if (null == daysLeft || null == _currentWeight || null == _targetWeight) return '';
    return ((_targetWeight - _currentWeight) / daysLeft).toStringAsFixed(2);
  }

  String computeLossPerWeek() {
    if (null == weeksLeft || null == _currentWeight || null == _targetWeight) return '';
    return ((_targetWeight - _currentWeight) / weeksLeft).toStringAsFixed(2);
  }

}
