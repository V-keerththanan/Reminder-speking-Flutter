import 'package:flutter_tts/flutter_tts.dart';

class Assistant {
  Assistant(this.message);

  String message;
  FlutterTts alexa = FlutterTts();

  Future<void> speak() async {
    await alexa.setSpeechRate(0.55);
    // await alexa.setVoice("en-us-x-sfg#male_1-local" );
    // await alexa.setVolume();
    // await alexa.setPitch(100.0);
    //await alexa.setLanguage("ta");
    await alexa.speak(message);
  }
}
