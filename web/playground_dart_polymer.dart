import 'dart:html';
import 'dart:math';
import 'package:playground_dart_polymer/custom_elements.dart';

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

  var numseqguessrElement = query('#numseqguessr').xtag as NumseqguessrElement;
  for (int i = 0; i < 10; i++) {
    numseqguessrElement.sequences.add(new SequenceGenerator().generate());
  }
}


