import 'package:natural_encoder/domain/models/frequency.dart';

class FrequencyAnalys{
  static List<Frequency> getFrequencyAnalys(String message){
    List<String> uniqueCharacters = [];
    for(var letter in message.split('')){
      if(!(uniqueCharacters.contains(letter)) && ((letter.codeUnitAt(0) >= 1040 && letter.codeUnitAt(0) <= 1071
          || letter.codeUnitAt(0)==1025) ||
          (letter.codeUnitAt(0) >= 1072 && letter.codeUnitAt(0) <= 1105))){
        uniqueCharacters.add(letter);
      }
    }

    List<Frequency> frequencys = [];
    for(var letter in uniqueCharacters){
      frequencys.add(Frequency.calc(message, letter));
    }
    frequencys.sort((a,b)=>b.frequencyOfUse.compareTo(a.frequencyOfUse));

    return frequencys;

  }


}