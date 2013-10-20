import 'dart:html';
import 'dart:math';
import 'package:polymer/polymer.dart';
import 'package:playground_dart_polymer/custom_elements.dart';

var random = new Random();

void main() {
  Polymer.register('tabs-element', TabsElement);
  Polymer.register('phonetic-alphabet-element', PhoneticAlphabet);
  Polymer.register('opinions-element', OpinionsElement);
  Polymer.register('numseqguessr-element', NumseqguessrElement);
  Polymer.register('html-graphviz-element', HtmlGraphviz);
  Polymer.register('weight-watch-element', WeightWatchElement);
  Polymer.register('tilemap-element', TilemapElement);
  initPolymer();

  var phoneticAlphabetElement = new Element.tag('phonetic-alphabet-element');
  var opinionsElement = new Element.tag('opinions-element');
  var numseqguessrElement = new Element.tag('numseqguessr-element');
  var graphvizElement = new Element.tag('html-graphviz-element');
  var weightWatchElement = new Element.tag('weight-watch-element');
  var tilemapElement = new Element.tag('tilemap-element');

  var tabs = (querySelector('#tabs') as TabsElement).items;
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

void initTilemapElement(TilemapElement element) {
  element.tilemap.addAll(new Map.fromIterable([232450, 11020, 235340, 226410],
      value: (item) => new Tile(item)));
}

void initOpinionsElement(opinionsElement) {
  var opinionsElementXTag = opinionsElement as OpinionsElement;
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
  var numseqguessrElementXTag = numseqguessrElement as NumseqguessrElement;
  for (int i = 0; i < 10; i++) {
    numseqguessrElementXTag.sequences.add(new SequenceGenerator().generate());
  }
}

void initHtmlGraphvizElement(graphvizElement) {
  (graphvizElement as HtmlGraphviz).root = document.documentElement;
}

