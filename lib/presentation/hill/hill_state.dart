import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:natural_encoder/constans.dart';
import 'package:natural_encoder/domain/models/alphabets_key.dart';
import 'package:natural_encoder/domain/models/frequency.dart';

part 'hill_state.freezed.dart';

@freezed
class HillState with _$HillState{
  factory HillState({
  @Default(true) bool pageIsLoading,
  @Default([]) List<List<int>> array,
  String? message,
  String? decodedMessage,
  @Default(false) bool showError,
  String? errorMessage,
  String? decryptedMessage,
  String? fragmentText,
  String? hackErrorMessage,
  @Default([]) List<AlphabetsKeys> alphabetsKeys,
  @Default([]) List<Frequency> hillFrequency,
})=_HillState;

}