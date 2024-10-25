import 'package:natural_encoder/domain/hacks/base_hacks_cypher.dart';

import '../../constans.dart';
import '../../helpers/calculator.dart';

class HillHack{

  Map<String, dynamic> hackDecode(String originalMessage,String decodedMessage,int keyLength) {


    print('original fragment ${originalMessage}');
    print('decoded fragment ${decodedMessage}');

    List<String> cuttedMessage = originalMessage.split('');

    List<List<int>> originalMessageList = List.generate(keyLength, (_)=>List.generate(keyLength,(_)=>0));

    int charIndex = 0;
    for (int i = 0; i < originalMessageList.length; i++) {
      for (int j = 0; j < originalMessageList[i].length; j++) {
        if(cuttedMessage.length>charIndex){
          var letter = cuttedMessage[charIndex++];
          // Преобразуем символ в ключ
          originalMessageList[i][j] = Alphabets
              .russianAlphabetKeys
              .firstWhere((element) => element.character.toUpperCase() == letter.toUpperCase())
              .key;
        }

      }
    }

    List<String> decodedCuttedMessage = decodedMessage.split('');

    List<List<int>> decodedMessageList = List.generate(keyLength, (_)=>List.generate(keyLength,(_)=>0));

    charIndex = 0;
    for (int i = 0; i < decodedMessageList.length; i++) {
      for (int j = 0; j < decodedMessageList[i].length; j++) {
        if(decodedCuttedMessage.length>charIndex){
          var letter = decodedCuttedMessage[charIndex++];
          // Преобразуем символ в ключ
          decodedMessageList[i][j] = Alphabets
              .russianAlphabetKeys
              .firstWhere((element) => element.character.toUpperCase() == letter.toUpperCase())
              .key;
        }

      }
    }

    print("original Matrix ${originalMessageList}");
    print("decode Matrix ${decodedMessageList}");

    var originMessageCheck = checkArray(originalMessageList);
    var decodedMessageCheck = checkArray(decodedMessageList);
    if(originMessageCheck!=null || decodedMessageCheck!=null){
      print('from if for error ${originMessageCheck} or ${decodedMessageCheck}');
      return {"error" : originMessageCheck,"message" : []};
    }
    // 1. Находим обратную матрицу для открытого текста
    List<List<int>> inversePlaintextMatrix = Calculator.inversedModMatrix(originalMessageList,Alphabets.russianAlphabetKeys.length);

/*    var check = Calculator.arrayMultiply(originalMessageList, inversePlaintextMatrix);

    for(var i = 0;i<check.length;i++){
      for(var j=0;j<check[i].length;j++){
        if(check[i][j]<0){
          check[i][j]=Alphabets.russianAlphabetKeys.length+check[i][j];
        }
        else{
          check[i][j]=check[i][j].remainder(Alphabets.russianAlphabetKeys.length);

        }
      }
    }
    print('after check hack ${check}');*/


    // 2. Умножаем матрицу обратную матрицу открытого текст на матрицу шифротекста
    List<List<int>> keyMatrix = Calculator.arrayMultiply(inversePlaintextMatrix,decodedMessageList );


    // 3. Приводим результат по модулю размера алфавита
    for (var i = 0; i < keyMatrix.length; i++) {
      for (var j = 0; j < keyMatrix[i].length; j++) {
        keyMatrix[i][j] = keyMatrix[i][j].remainder(Alphabets.russianAlphabetKeys.length);
      }
    }

    print('result in hack class ${keyMatrix}');
    return {"message" : keyMatrix,"error" : ""};

  }


  String? checkArray(List<List<int>> array){
    int determinant = Calculator.determinant(array);
    if(determinant==0){
      print("Детерминант матрицы равен нулю");
      return "Детерминант матрицы равен нулю";
    }

    List<int> keyDivisorsList = Calculator.getDivisorsList(determinant);
    List<int> alphabetsDivisorsList = Calculator.getDivisorsList(Alphabets.russianAlphabetKeys.length);
    List<int> commonDivisors = [];
    for(var i=0;i<keyDivisorsList.length;i++){
      if(alphabetsDivisorsList.contains(keyDivisorsList[i])){
        commonDivisors.add(keyDivisorsList[i]);
      }
    }

    if(commonDivisors.isNotEmpty){
      print("Детерминант матрицы и длина массива не взаимно простые");
      return "Детерминант матрицы и длина массива не взаимно простые";
    }
    return null;

  }
}
