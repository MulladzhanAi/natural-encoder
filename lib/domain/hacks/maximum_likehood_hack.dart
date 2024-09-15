import 'package:natural_encoder/constans.dart';
import 'package:natural_encoder/domain/encoders/caesars_encoder.dart';
import 'package:natural_encoder/domain/hacks/base_hacks_cypher.dart';
import 'package:natural_encoder/domain/models/frequency.dart';

class MaximumLikehoodHack implements BaseHackCypher {


  @override
  Map<String,dynamic> hackDecode(String message) {
    int maxk = Alphabets.russianAlphabetFrequencies.length;
    List<double> sums = [];
    List<String> temp = [];

    String originalMessage = message;

    for (int j = 0; j < maxk; j++) {
      String encodeMessage = CaesarsEncoder().encrypt(originalMessage, j.toString())['message'];
      String encryptedMessage = encodeMessage;

      List<String> uniqueCharacters = [];
      for (var character in encryptedMessage.split('')) {
        if (!uniqueCharacters.contains(character) &&  ((character.codeUnitAt(0) >= 1040 && character.codeUnitAt(0) <= 1071
    || character.codeUnitAt(0)==1025) ||
    (character.codeUnitAt(0) >= 1072 && character.codeUnitAt(0) <= 1105))) {
          uniqueCharacters.add(character);
        }
      }

      List<Frequency> frequencys = List.generate(
        uniqueCharacters.length,
            (index) => Frequency.calc(encryptedMessage, uniqueCharacters[index]),
      );

      double sum = 0;
      frequencys.sort((a, b) => b.count.compareTo(a.count));
      for (int i = 0; i < frequencys.length; i++) {
        double f = Alphabets.russianAlphabetFrequencies.
        firstWhere((test)=>test.character==frequencys[i].character.toLowerCase()).frequencyOfUse;
        sum += frequencys[i].count * f;
      }
      sums.add(sum);
      temp.add(encryptedMessage);
    }

    int indexOfSum = sums.indexOf(sums.reduce((curr, next) => curr > next ? curr : next));

    return {"message" : temp[indexOfSum], "key" : indexOfSum.toString()};
  }
}
