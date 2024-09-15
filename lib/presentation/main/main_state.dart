import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:natural_encoder/domain/encoders/base_encoder.dart';
import 'package:natural_encoder/domain/models/frequency.dart';
import 'package:natural_encoder/enums/encode_types.dart';

part 'main_state.freezed.dart';

@freezed
class MainState with _$MainState{
  factory MainState({
    @Default(false) bool screenIsLoading,
    @Default('') String message,
    BaseEncoder? baseEncoder,
    @Default('') String hackedMessage,
    @Default('') String encodedMessage,
    @Default('') dynamic encodedKey,
    EncodeTypes? type,
    String? key,
    @Default([]) List<Frequency> caesar_statics,
    @Default([]) List<Frequency> two_arrays_statics,
    @Default([]) List<Frequency> tritemius_statics,
    @Default([]) List<Frequency> current_statics,
    String? error,
})=_MainState;

}