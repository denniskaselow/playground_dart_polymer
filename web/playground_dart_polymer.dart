import 'dart:html';
import 'dart:math';
import 'package:polymer/polymer.dart';
import 'tabs.dart';
import 'opinions.dart';
import 'numseqguessr.dart';

var random = new Random();

void main() {
  var alphabet = new PhoneticAlphabet();
  query('#buchstabiertafel').model = alphabet;


  var tabs = (query('#tabs').xtag as TabsElement).items;
  tabs..add(new Item('Label', 'Content'))
      ..add(new Item('Label2', 'Content2'))
      ..add(new Item('Label3', 'Content3'));

  List<Question> questions = [new Question('Did you like your breakfast?', ['It was gross!', 'Not so much.', 'I\'ve had better', 'It was okay', 'It was tasty', 'I had a mouthgasm!']),
                    new Question('Have you voted in the last election?', ['No', 'Yes']),
                    new Question('How much do you like this application?', ['WTF is this?!', 'Nope, it\'s ugly', 'Maybe', 'Yes', 'Yeah! It\'s awesome!'])
                  ];

  var opinionsElement = query('#opinions').xtag as OpinionsElement;

  var opinionCount = 2 + random.nextInt(3);
  var otherOpinionIds = new List<String>();
  for (int i = 1; i <= opinionCount; i++) {
    otherOpinionIds.add('Opinion $i');
  }

  for (var question in questions) {
    var opinion = new Opinion(question.id);
    Map<String, Opinion> otherOpinions = new Map<String, Opinion>();
    for (int i = 0; i < opinionCount; i++) {
      otherOpinions[otherOpinionIds[i]] = opinion.otherOpinion('${random.nextInt(question.answers.length)}');
    }
    opinionsElement.opinions.add(new OpinionMatcher(opinion, otherOpinions, minValue: 0, maxValue: question.answers.length - 1));
  }
  opinionsElement.otherOpinions.addAll(otherOpinionIds);
  opinionsElement.questions.addAll(new Map.fromIterable(questions, key: (question) => question.id));

  var numseqguessrElement = query('#numseqguessr').xtag as NumberSequenceGuesserElement;
  for (int i = 0; i < 10; i++) {
    numseqguessrElement.sequences.add(new SequenceGenerator().generate());
  }
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
