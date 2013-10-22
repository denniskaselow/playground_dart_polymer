import 'dart:html';
import 'dart:math';
import 'package:polymer/polymer.dart';
import 'package:playground_dart_polymer/custom_elements.dart';

var random = new Random();

void main() {
  var tabs = (query('#tabs').xtag as TabsElement).items;
  var phoneticAlphabetElement = createElement('phonetic-alphabet-element');
  var opinionsElement = createElement('opinions-element');
  var numseqguessrElement = createElement('numseqguessr-element');
  var graphvizElement = createElement('html-graphviz-element');
  var weightWatchElement = createElement('weight-watch-element');
  var tilemapElement = createElement('tilemap-element');

  tabs..add(new Item('Buchstabiertafel', phoneticAlphabetElement))
      ..add(new Item('Q&A', opinionsElement))
      ..add(new Item('NumberSequenceGuessr', numseqguessrElement))
      ..add(new Item('graphviz', graphvizElement))
      ..add(new Item('WeightWatch', weightWatchElement))
      ..add(new Item('''Drag'n'Drop Tiles''', tilemapElement));

  initOpinionsElement(opinionsElement);
  initNumSeqElement(numseqguessrElement);
  initHtmlGraphvizElement(graphvizElement);
  initTilemapElement(tilemapElement);
}

void initTilemapElement(Element tilemapElement) {
  var xtag = tilemapElement.xtag as TilemapElement;
  xtag.tilemap.addAll(new Map.fromIterable([232450, 11020, 235340, 226410],
      value: (item) => new Tile(item)));
}

void initOpinionsElement(opinionsElement) {
  var opinionsElementXTag = opinionsElement.xtag as OpinionsElement;
  List<Question> questions = [new Question('Did you like your breakfast?', ['It was gross!', 'Not so much.', 'I\'ve had better', 'It was okay', 'It was tasty', 'I had a mouthgasm!']),
                    new Question('Have you voted in the last election?', ['No', 'Yes']),
                    new Question('How much do you like this application?', ['WTF is this?!', 'Nope, it\'s ugly', 'Maybe', 'Yes', 'Yeah! It\'s awesome!'])
                  ];

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
    opinionsElementXTag.opinions.add(new OpinionMatcher(opinion, otherOpinions, minValue: 0, maxValue: question.answers.length - 1));
  }
  opinionsElementXTag.otherOpinions.addAll(otherOpinionIds);
  opinionsElementXTag.questions.addAll(new Map.fromIterable(questions, key: (question) => question.id));
}

void initNumSeqElement(numseqguessrElement) {
  var numseqguessrElementXTag = numseqguessrElement.xtag as NumseqguessrElement;
  for (int i = 0; i < 10; i++) {
    numseqguessrElementXTag.sequences.add(new SequenceGenerator().generate());
  }
}

void initHtmlGraphvizElement(graphvizElement) {
  (graphvizElement.xtag as HtmlGraphviz).root = document.documentElement;
}

