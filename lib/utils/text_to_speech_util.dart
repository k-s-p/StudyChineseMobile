import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechUtil {
  final FlutterTts flutterTts = FlutterTts();

  Future speak(String text) async {
    // flutterTts.getLanguages.then((value) => print(value));
    await flutterTts.setLanguage("zh-CN");
    // await flutterTts.setVoice({"name": "yue-hk-x-yuf-network", "locale": "yue-HK"});
    // await flutterTts.setVoice({"name": "cmn-cn-x-cce-local", "locale": "zh-CN"});
    // await flutterTts.setVoice({"name": "cmn-cn-x-ssa-local", "locale": "zh-CN"});
    // await flutterTts.setVoice({"name": "cmn-cn-x-ccd-network", "locale": "zh-CN"});
    // await flutterTts.setVoice({"name": "zh-CN-language", "locale": "zh-CN"});
    // await flutterTts.setVoice({"name": "cmn-cn-x-ccc-local", "locale": "zh-CN"});
    // await flutterTts.setVoice({"name": "cmn-cn-x-ccc-network", "locale": "zh-CN"}); // 結構いい
    // await flutterTts.setVoice({"name": "cmn-cn-x-ccd-local", "locale": "zh-CN"});
    await flutterTts.setVoice({"name": "cmn-cn-x-cce-network", "locale": "zh-CN"}); // 結構いい
    // await flutterTts.setVoice({"name": "cmn-cn-x-ssa-network", "locale": "zh-CN"});
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
    // var result = await flutterTts.speak(text);
    // if (result == 1){
    //   print("成功");
    // }else{
    //   print("失敗");
    // }
    // flutterTts.getVoices.then((value){
    //   for (var element in value) {
    //     if(element["locale"] == "zh-CN"){
    //     print(element);

    //     }
    //   }
    // });
  }
}