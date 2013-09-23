library phonetic_alphabet;

import 'package:polymer/polymer.dart';

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