import 'dart:html';
import 'package:polymer/polymer.dart';
import 'tabs.dart';
import 'opinions.dart';

void main() {
  var alphabet = new PhoneticAlphabet();
  query('#buchstabiertafel').model = alphabet;


  var tabs = (query('#tabs').xtag as TabsElement).items;
  tabs..add(new Item('Label', 'Content'))
      ..add(new Item('Label2', 'Content2'))
      ..add(new Item('Label3', 'Content3'));

  var opinionsElement = query('#opinions').xtag as OpinionsElement;

  opinionsElement.otherOpinions.addAll(['op1', 'op2']);
  opinionsElement.opinions..add(new OpinionMatcher(new Opinion('id1'), {'op1': new Opinion('id1', '1'), 'op2': new Opinion('id1', '10')}))
                          ..add(new OpinionMatcher(new Opinion('id2'), {'op1': new Opinion('id2', '1'), 'op2': new Opinion('id2', '10')}))
                          ..add(new OpinionMatcher(new Opinion('id2'), {'op1': new Opinion('id3', '1'), 'op2': new Opinion('id3', '10')}));


}

class PhoneticAlphabet extends Object with ObservableMixin {
  static const GERMAN = const {'a': 'Anton', 'ä': 'Ärger', 'b': 'Berta',
    'c': 'Cäsar', 'd': 'Dora', 'e': 'Emil', 'f': 'Friedrich',
    'g': 'Gustav', 'h': 'Heinrich', 'i': 'Ida', 'j': 'Julius', 'k': 'Kaufmann',
    'l': 'Ludwig', 'm': 'Martha', 'n': 'Nordpol', 'o': 'Otto', 'ö': 'Ökonom',
    'p': 'Paula', 'q': 'Quelle', 'r': 'Richard', 's': 'Samuel', 'ß': 'Eszett',
    't': 'Theodor', 'u': 'Ulrich', 'ü': 'Übermut', 'v': 'Viktor', 'w': 'Wilhelm',
    'x': 'Xanthippe', 'y': 'Ypsilon', 'z': 'Zacharias'};
  static const NATO = const {'a': 'Alfa', 'ä': 'Alfa-Echo', 'b': 'Bravo',
    'c': 'Charlie', 'd': 'Delta', 'e': 'Echo', 'f': 'Foxtrot',
    'g': 'Golf', 'h': 'Hotel', 'i': 'India', 'j': 'Juliett', 'k': 'Kilo',
    'l': 'Lima', 'm': 'Mike', 'n': 'November', 'o': 'Oscar', 'ö': 'Oscar-Echo',
    'p': 'Papa', 'q': 'Quebec', 'r': 'Romeo', 's': 'Sierra', 'ß': 'Sierra-Sierra',
    't': 'Tango', 'u': 'Uniform', 'ü': 'Uniform-Echo', 'v': 'Victor', 'w': 'Whiskey',
    'x': 'X-Ray', 'y': 'Yankee', 'z': 'Zulu'};

  @observable
  String text;

  PhoneticAlphabet() {
    bindProperty(this, const Symbol('text'), () => notifyProperty(this, const Symbol('germanPhoneticAlphabet')));
    bindProperty(this, const Symbol('text'), () => notifyProperty(this, const Symbol('natoPhoneticAlphabet')));
  }

  String get germanPhoneticAlphabet => text.split('').map(convertGerman).join(' ');
  String get natoPhoneticAlphabet => text.split('').map(convertNato).join(' ');

  String convertGerman(c) => convert(c, GERMAN);
  String convertNato(c) => convert(c, NATO);

  String convert(String char, Map<String, String> converterMap) {
    var c = char.toLowerCase();
    if (converterMap.containsKey(c)) {
      return converterMap[c];
    }
    return char;
  }
}
