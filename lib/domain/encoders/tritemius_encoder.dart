import 'package:natural_encoder/constans.dart';
import 'package:natural_encoder/domain/encoders/base_encoder.dart';
import 'package:natural_encoder/domain/hacks/base_hacks_cypher.dart';

class TritemiusEncoder implements BaseEncoder {
  @override
  Map<String, dynamic> decrypt(String message, BaseHackCypher baseHackCypher) {
    return baseHackCypher.hackDecode(message);
  }

  @override
  Map<String, dynamic> encrypt<T>(String message, T key) {
    if (key is! String)
      return {
        "message": message,
        'key': '',
        'error' : 'Ошибка в  шифровизации метода Тритемиуса'
      };

    List<String> keys = key.split('');
    List<String> result = [];
    int keysIndex = 0;
    for (var letter in message.split('')) {
      if (((letter.codeUnitAt(0) >= 1040 && letter.codeUnitAt(0) <= 0x1071 ||
              letter.codeUnitAt(0) == 1025) ||
          (letter.codeUnitAt(0) >= 1072 && letter.codeUnitAt(0) <= 1105))) {
        int p = Alphabets.russian
            .indexWhere((c) => c.toLowerCase() == letter.toLowerCase());
        int addedIndex = Alphabets.russian
            .indexWhere((c) => c.toLowerCase() == keys[keysIndex].toLowerCase());
        keysIndex++;
        if (keysIndex >= keys.length) keysIndex = 0;

        int c = (p + addedIndex) % Alphabets.russian.length;

        result.add(Alphabets.russian[c].toLowerCase());
        continue;
      }
      result.add(letter);

    }

    String encodedMessage = result.join();
    return {'message': encodedMessage, 'key': key};
  }
}
