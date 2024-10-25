import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natural_encoder/constans.dart';
import 'package:natural_encoder/domain/analys/frequency_analys.dart';
import 'package:natural_encoder/domain/encoders/base_encoder.dart';
import 'package:natural_encoder/domain/encoders/hill_encoder.dart';
import 'package:natural_encoder/domain/hacks/hill_hack.dart';
import 'package:natural_encoder/domain/models/alphabets_key.dart';
import 'package:natural_encoder/domain/models/frequency.dart';
import 'package:natural_encoder/helpers/calculator.dart';

import 'hill_state.dart';

class HillBloc extends Cubit<HillState>{
  HillBloc() : super(HillState());

  final BaseEncoder  encoder= HillEncoder();
  final HillHack hillHack = HillHack();


  setArraySize(int size){
    List<List<int>> array = List.generate(size, (item)=>List.generate(size,(item)=>0));
    emit(state.copyWith.call(array: array));

  }

  randomArray(List<List<int>> array){
    Random random = Random();
    for(int i=0;i<array.length;i++){
      for(int j=0;j<array[i].length;j++){
        array[i][j]=random.nextInt(20);
      }
    }
    emit(state.copyWith.call(array: array));
    checkArray(state.array);
  }

  encode(String message,TextEditingController encodedMessageController){
    var result = encoder.encrypt(message, state.array);
    emit(state.copyWith(decodedMessage: result['message']));
    print(result);
    encodedMessageController.text = result['message'];
    getHillFrequency(result['message'] ?? "");
  }


  changeArray(int i,int j,String? value,List<List<int>> array){
    int v = int.tryParse(value ?? "") ?? 0;
    array[i][j]=v;
    emit(state.copyWith.call(array: array));
    checkArray(state.array);

  }

  changeMessage(String? text){
    emit(state.copyWith.call(message: text));
  }

  changeDecodedMessage(String? v){
    emit(state.copyWith.call(decodedMessage: v));
  }

  Future<Map<String,dynamic>> decodeMessage(String? message){
    var result = encoder.decrypt(message ?? "", state.array);
    emit(state.copyWith.call(decryptedMessage: result['message']));
    print("result of decrypt ${result}");
    return Future.value(result);
  }
  
  checkArray(List<List<int>> array){
    int determinant = Calculator.determinant(array);
    if(determinant==0){
      emit(state.copyWith(errorMessage: "Детерминант матрицы равен нулю",showError: true));
      return;
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
      emit(state.copyWith(errorMessage: "Детерминант матрицы и длина алфавита не взаимно простые",showError: true));
      return;
    }
    emit(state.copyWith.call(errorMessage: null,showError: false));
  }


  Future<List<List<int>>>? hack({String? fragment,String? decodedMessage,String? fromString,String? toString})async{
/*    Map<String,dynamic>? result = {};
    if(fromString != null  && fromString != "" && toString!="" && toString!=null){
      print('for fragment all');
      result = await hackWithRange(fromString: fromString, toString: toString);
    }
    if(fragment!=null && fragment!="" && decodedMessage!="" && decodedMessage!=null){
      print('for mesage all');
      result = await hillHack.hackDecode(fragment, decodedMessage, state.array.length);
    }
    if(result?['error']!=null && result?['error']!=""){
      emit(state.copyWith.call(hackErrorMessage: result?['error']));
      return Future.value(null);
    }

    print('result ${result}');*/

    var result = cycleHack(state.message ?? "", state.decodedMessage, state.array.length);
    //emit(state.copyWith.call(hackErrorMessage: result?['error']));
    if(result==null || result==[]){
      emit(state.copyWith.call(hackErrorMessage: 'Не удалось взломать'));
    }
    else{
      emit(state.copyWith.call(hackErrorMessage: ''));

    }
    return Future.value(result ?? []);

  }


  //Взлом через указывание позиций
  hackWithRange({required String fromString,required String toString}){
    int from = int.tryParse(fromString) ?? 0;
    int to = int.tryParse(toString) ?? 0;
    var cutted = state.message?.substring(from,to);
    var decodedMessage =  state.decodedMessage?.substring(from,to);
    return hillHack.hackDecode(cutted ?? "", decodedMessage ?? "", state.array.length);
  }

  //Взлом через указывание самих сообщений
  hackWithMessage(String fragment,String decodedMessage){
    final  result = hillHack.hackDecode(fragment, decodedMessage, state.array.length);
    return result;
  }

  getHillFrequency(String text){

    var analys = FrequencyAnalys.getFrequencyAnalysByAlpabet(text);
    emit(state.copyWith.call(hillFrequency: analys));
  }


  setAlphabetsKeys(String text){
    List<AlphabetsKeys> alphabetsKeys = [];
    List<String> list = text.split('');
    for(int i=0;i<list.length;i++){
      alphabetsKeys.add(AlphabetsKeys(character: list[i], key: i));
    }
    emit(state.copyWith.call(alphabetsKeys: alphabetsKeys));
  }


  cycleHack(String originText,cyphedText,int arrayLegth){
    int textLegth = originText.length;
    Map<String,dynamic>? result = {};
    int end=arrayLegth*arrayLegth;
    for(var i=0;i<textLegth;i++){
      if(end>textLegth) return;
      print(" i ${i}");
      print(" end ${end}");
      result = hackWithRange(fromString: i.toString(), toString: end.toString());

      if(result?['error']!=null && result?['error']!=""){
        end++;
        continue;
      }

      var check = checkMatrix(result?['message']);
      print('check bool ${check}');
      if(check){
        return result?['message'];
      }
      end++;
    }
  }

/*  checkMatrix(List<List<int>> matrix){
    print(matrix);
    print(state.array);
    for(var i = 0;i<matrix.length;i++){
      for(var j=0;j<matrix[i].length;j++){
        if(matrix[i][j]!=state.array[i][j]){
          print('матрицы не равны');
          return false;
        }
      }
    }
    return true;
  }*/

  checkMatrix(List<List<int>> matrix){
    var decodedResult = encoder.decrypt(state.decodedMessage ?? "", matrix);
    print('check');
    print(decodedResult['message']);
    print(state.message);
    var decodedMessage = decodedResult['message'] as String;
    if(decodedMessage.toLowerCase().trim() !=state.message?.toLowerCase().trim()) return false;

    return true;
  }

}