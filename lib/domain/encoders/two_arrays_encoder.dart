import 'package:natural_encoder/constans.dart';
import 'package:natural_encoder/domain/encoders/base_encoder.dart';
import 'package:natural_encoder/domain/hacks/base_hacks_cypher.dart';

class TwoArraysEncoder implements BaseEncoder {
  @override
  Map<String, dynamic> decrypt<T>(String message,T key) {
    return {"message" : "" , "key" : key};
  }

  @override
  Map<String, dynamic> encrypt<T>(String message, T key) {
    if (key is! String)
      return {
        'message': message,
        'key': '',
        'error' : "Ошибка шифрования в методе двумя массивами"
      };
    List<String> chyper = key.split('');

    if(chyper.length<Alphabets.russian.length) {
      return {
        'message': message,
        'key': '',
        'error': "Ошибка шифрования в методе двумя массивами.\nВведите полный ключ-массив"
      };
    }
      List<String> result = [];
      for (var letter in message.split('')) {
        if (((letter.codeUnitAt(0) >= 1040 && letter.codeUnitAt(0) <= 0x1071) ||
            letter.codeUnitAt(0) == 1025) ||
            (letter.codeUnitAt(0) >= 1072 && letter.codeUnitAt(0) <= 1105)) {

          int indexFromBaseAlphabets =
          Alphabets.russian.indexOf(letter.toUpperCase());
          result.add(chyper[indexFromBaseAlphabets].toLowerCase());
          continue;
        }
        result.add(letter);
      }

      return {'message': result.join(), 'key': chyper};
    }
}
