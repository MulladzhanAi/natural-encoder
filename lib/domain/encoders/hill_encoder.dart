import 'package:natural_encoder/constans.dart';
import 'package:natural_encoder/domain/encoders/base_encoder.dart';
import 'package:natural_encoder/domain/hacks/base_hacks_cypher.dart';
import 'package:natural_encoder/helpers/calculator.dart';

class HillEncoder implements BaseEncoder{
  @override
  Map<String, dynamic> decrypt<T>(String message,T key) {

    key as List<List<int>>;

    int n = key.length;


    List<String> cuttedMessage = message.split('');

    while (cuttedMessage.length % n != 0) {
      cuttedMessage.add(' ');
    }

    // Формируем матрицу сообщения
    int numCols = cuttedMessage.length ~/ n; // Число столбцов в матрице сообщения
    List<List<int>> messageKeys = List.generate(numCols, (_) => List.generate(n, (_) => 0));

    int charIndex = 0;
    for (int col = 0; col < numCols; col++) {
      for (int row = 0; row < n; row++) {
        var letter = cuttedMessage[charIndex++];
        // Преобразуем символ в ключ
        messageKeys[col][row] = Alphabets
            .russianAlphabetKeys
            .firstWhere((element) => element.character.toUpperCase() == letter.toUpperCase())
            .key;
      }
    }



    var transparentMatrix = Calculator.inversedModMatrix(key, Alphabets.russianAlphabetKeys.length);
    var decodedMatrix = Calculator.arrayMultiply(messageKeys, transparentMatrix);
    for (var i = 0; i < decodedMatrix.length; i++) {
      for (var j = 0; j < decodedMatrix[i].length; j++) {
        decodedMatrix[i][j] = Calculator.modWithSign(decodedMatrix[i][j], Alphabets.russianAlphabetKeys.length);
      }
    }



    for(var i=0;i<decodedMatrix.length;i++){
      for(var j=0;j<decodedMatrix[i].length;j++){
        if(decodedMatrix[i][j]<0){
          decodedMatrix[i][j]=Alphabets.russianAlphabetKeys.length+decodedMatrix[i][j];
        }
        else{
          decodedMatrix[i][j]=decodedMatrix[i][j];
        }
      }
    }


    List<String> answer = [];
    for(var i=0;i<decodedMatrix.length;i++){
      for(var j=0;j<decodedMatrix[i].length;j++){
          answer.add(Alphabets.russianAlphabetKeys.
          firstWhere((item)=>item.key==decodedMatrix[i][j].remainder(Alphabets.russianAlphabetKeys.length)).character.toLowerCase());
      }
    }


    Calculator.inversedModMatrix(key, 37);

    return {"message" : "${answer.join()}", "key" : "",};
  }



  @override
  Map<String, dynamic> encrypt<T>(String message, T key) {

    print(key.runtimeType);
    //if(key !is List<List<int>>) return {"message" : "", "key" : "","error" : "Неверный ключ"};

    key as List<List<int>>;


    int n = key.length;

    List<String> cuttedMessage = message.split('');

    while (cuttedMessage.length % n != 0) {
      cuttedMessage.add(' ');
    }

    // Формируем матрицу сообщения
    int numCols = cuttedMessage.length ~/ n; // Число столбцов в матрице сообщения
    List<List<int>> messageKeys = List.generate(numCols, (_) => List.generate(n, (_) => 0));

    int charIndex = 0;
    for (int col = 0; col < numCols; col++) {
      for (int row = 0; row < n; row++) {
        var letter = cuttedMessage[charIndex++];
        // Преобразуем символ в ключ
        messageKeys[col][row] = Alphabets
            .russianAlphabetKeys
            .firstWhere((element) => element.character.toUpperCase() == letter.toUpperCase())
            .key;
      }
    }



    var multyplyed = Calculator.arrayMultiply(messageKeys, key);

    print("матрица зашифрованного сообщения ${multyplyed}");
    List<String> resultedList = [];
    for(var column in multyplyed){

      for(var value in column){
        resultedList.add(Alphabets.russianAlphabetKeys.firstWhere(
                (item)=>item.key==value.remainder(Alphabets.russianAlphabetKeys.length)).character.toLowerCase());
      }
    }

    print('матрица ключа ${key}');
    print('матрица сообщения ${messageKeys}');

    //Детерминант матрицы ключа
    int keyDeterminant = Calculator.determinant(key);
    print("Детерминант матрицы ключа : ${keyDeterminant}");

    //Список делителей матрицы ключа
    List<int> keyDivisorsList = Calculator.getDivisorsList(keyDeterminant);
    print('Список делителей матрицы ключа ${keyDivisorsList}');

    //Список делителей длины алфавита шифруемого текста/основание модуля
    List<int> alphabetsDivisorsList = Calculator.getDivisorsList(Alphabets.russianAlphabetKeys.length);
    print('Список делителей длины алфавита ${alphabetsDivisorsList}');

    //Список общих делителей матрицы ключа и алфавита
    List<int> commonDivisors = [];
    for(int i = 0;i<keyDivisorsList.length;i++){
      Iterable<int> common = alphabetsDivisorsList.where((item)=>item==keyDivisorsList[i]);
      commonDivisors.addAll(common);
    }

    print("Список общих делителей матрицы ключа и алфавита ${commonDivisors}");



    return {"message" : "${resultedList.join()}", "key" : ""};
  }

}