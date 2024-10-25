import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:natural_encoder/constans.dart';
import 'package:natural_encoder/domain/analys/frequency_analys.dart';
import 'package:natural_encoder/domain/encoders/caesars_encoder.dart';
import 'package:natural_encoder/domain/encoders/tritemius_encoder.dart';
import 'package:natural_encoder/domain/encoders/two_arrays_encoder.dart';
import 'package:natural_encoder/domain/hacks/maximum_likehood_hack.dart';
import 'package:natural_encoder/domain/models/frequency.dart';
import 'package:natural_encoder/enums/encode_types.dart';
import 'package:natural_encoder/presentation/main/main_state.dart';

class MainBloc extends Cubit<MainState>{
  Function(String? e)? showError;

  MainBloc():super(MainState());


  encode(TextEditingController controller){
    final result = state.baseEncoder?.encrypt(state.message, state.key);
    if(result==null) return;
    print(result);
    if(result['error']!=null){
      showError?.call(result['error']);
      return;
    }
    emit(state.copyWith(encodedMessage: result['message'] ?? "",encodedKey: result['key'] ?? ""));

    controller.text=state.encodedMessage;
    setCurrentStatics(state.encodedMessage);
  }

  Future<Map<String,dynamic>> hackCypher(String message)async{
    final result = MaximumLikehoodHack().hackDecode(message);
    if(result==null)   return Future.value({});

    emit(state.copyWith(hackedMessage: result['message'] ?? "",encodedKey: result['key']));
    return Future.value({"message" : result['message'],"key" : result['key']});
  }


  setEncoder(EncodeTypes type){
    switch(type){
      case EncodeTypes.caesar:
        emit(state.copyWith(baseEncoder: CaesarsEncoder()));
        break;
      case EncodeTypes.two_arrays:
        emit(state.copyWith(baseEncoder: TwoArraysEncoder()));
        break;
      case EncodeTypes.triremius:
        emit(state.copyWith(baseEncoder: TritemiusEncoder()));
        break;
    }
  }

  changeMessage(String? v){
    emit(state.copyWith(message: v ?? ""));
  }

  changeKey(String v){
    emit(state.copyWith(key: v));
  }


  setEncodedType(EncodeTypes? type){
    if(type==null) return;
    emit(state.copyWith(type: type));
    setEncoder(type);
  }

  getRandomKey(TextEditingController controller){
    if(state.type==null) return;
    switch(state.type!){
      case EncodeTypes.caesar:
        int key = getCaesarRandomKey();
        emit(state.copyWith(key: key.toString()));
        controller.text=state.key ?? "";
        break;

      case EncodeTypes.two_arrays:
        String key = getTwoArraysRandomKey();
        emit(state.copyWith(key: key));
        controller.text=state.key ?? "";
        break;

      case EncodeTypes.triremius:
        break;
    }
  }

  getFrequencyAnalys(String message,EncodeTypes? type){
    if(type==null) return;
    List<Frequency> result = FrequencyAnalys.getFrequencyAnalys(message);
    switch(type){
      case EncodeTypes.caesar:
        emit(state.copyWith(caesar_statics: result));
        break;
      case EncodeTypes.two_arrays:
        emit(state.copyWith(two_arrays_statics: result));
        break;
      case EncodeTypes.triremius:
        emit(state.copyWith(tritemius_statics: result));
        break;
    }
    return result;
  }

  setCurrentStatics(String message){
    var list = FrequencyAnalys.getFrequencyAnalys(message);
    emit(state.copyWith(current_statics: list));
  }

  int getCaesarRandomKey(){
    Random random = Random();
    return random.nextInt(33);
  }

  String getTwoArraysRandomKey(){
    List<String>  result = [];
    result.addAll(Alphabets.russian);
    result.shuffle();
    return result.join();
  }

}