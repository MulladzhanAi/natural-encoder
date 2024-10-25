import 'package:natural_encoder/domain/hacks/base_hacks_cypher.dart';

abstract interface class BaseEncoder{
  Map<String,dynamic> encrypt<T> (String message,T key);

  Map<String,dynamic> decrypt<T>(String message,T key);

}