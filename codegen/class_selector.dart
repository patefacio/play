import "dart:io";
import "package:ebisu/ebisu_dart_meta.dart";
import "package:ebisu_web_ui/ebisu_web_ui.dart";
import "package:pathos/path.dart" as path;

main() {

  Options options = new Options();
  String here = path.dirname(path.absolute(options.script));
  String topDir = "${here}/..";
  ComponentLibrary lib = componentLibrary('class_selector_fail')
    ..rootPath = topDir
    ..examples = [
      example(id('example')),
    ]
    ..libraries = [
    ]
    ..components = [
      component('good_evil'),
      component('non_wrapping'),
    ]
    ..dependencies = [
    ];
  
  lib.generate();
    
}