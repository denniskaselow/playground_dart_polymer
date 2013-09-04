import 'package:polymer/component_build.dart';
import 'dart:io';

void main() {
  var args = new Options().arguments;
  args.addAll(['--', '--deploy']); // Note: the --deploy is what makes this work
  build(args, ['web/playground_dart_polymer.html']);
}