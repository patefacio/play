import "dart:html";
import "package:polymer/polymer.dart";
import "package:logging/logging.dart";


final _logger = new Logger("classSelectorFail");


class GoodEvil extends PolymerElement { 

  // custom <class GoodEvil>
  void inserted() {
    onClick.listen((MouseEvent e) {
      Element clickedElement = (e.toElement as Element); 
      print("Clicked Element (${clickedElement.outerHtml}) classes => ${clickedElement.classes}");
      var cls = clickedElement.classes;
      if(cls.contains('good')) {
        print("It is good: ${this.query('.good')}");
        print("But regular query of .color-good: ${this.query('.color-good')}");
        print("But shadowRoot query of .color-good: ${shadowRoot.query('.color-good')}");
      } else if(cls.contains('evil')) {
        print("It is good: ${this.query('.evil')}");
        print("But regular query of .color-evil: ${this.query('.color-evil')}");
        print("But shadowRoot query of .color-evil: ${shadowRoot.query('.color-evil')}");
      } else {
        print("It is neither!!");
      }

      print("From body '.color-good' ${document.body.query('.color-good')}");
      print("From body '.good' ${document.body.query('.good')}");
      print("From body '#cake-is-good' ${document.body.query('#cake-is-good')}");
      print("From body '#good-wrapper' ${document.body.query('#good-wrapper')}");

    });

  }
  // end <class GoodEvil>
}



// custom <class_selector_fail>
// end <class_selector_fail>

