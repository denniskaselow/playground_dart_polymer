library phonetic_alphabet;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:template_binding/template_binding.dart';
import 'package:polymer_expressions/polymer_expressions.dart';

@CustomTag('phonetic-alphabet-element')
class PhoneticAlphabet extends PolymerElement {
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
  String text = '';

  PhoneticAlphabet.created() : super.created();

  DocumentFragment instanceTemplate(Element template) {
    return templateBind(template).createInstance(this, new PolymerExpressions(globals: {
      'german': (text) => text.split('').map(convertGerman).join(' '),
      'nato': (text) => text.split('').map(convertNato).join(' ')
    }));
  }

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

