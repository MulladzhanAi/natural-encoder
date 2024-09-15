import 'package:natural_encoder/constans.dart';
import 'package:natural_encoder/domain/encoders/base_encoder.dart';
import 'package:natural_encoder/domain/hacks/base_hacks_cypher.dart';

class CaesarsEncoder implements BaseEncoder {

  @override
  Map<String,dynamic> encrypt<T>(String message, T key) {
    if(key is! String) return {'message' : message,'key' : '','error' : 'Ошибка шифрования в методе Цезаря'};

    int? newKey = int.tryParse(key);
    if(newKey==null) return {'message' : message,'key' : '','error' : 'Ошибка шифрования в методе Цезаря\nВведите ключ-число'};

    List<String> letters = message.split('').where((c)=>c.isNotEmpty).toList();
    List<String> result = [];
    for(int i=0;i<letters.length; i++){
      int p = Alphabets.russian.indexOf(letters[i].toUpperCase());
      if(p==-1){
        result.add(letters[i]);
        continue;
      }
      int c = (p+newKey)% Alphabets.russian.length;
      result.add(Alphabets.russian[c].toLowerCase());
    }
    return {'message' : result.join(),'key' : key };
  }


  @override
  Map<String,dynamic> decrypt(String message,BaseHackCypher baseHackCypher) {
    return baseHackCypher.hackDecode(message);
  }




}