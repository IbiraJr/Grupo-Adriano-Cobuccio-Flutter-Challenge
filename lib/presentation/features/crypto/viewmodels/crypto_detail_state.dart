import 'package:brasil_card/domain/entities/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_detail_state.freezed.dart';

@freezed
class CryptoDetailState with _$CryptoDetailState {
  const factory CryptoDetailState.initial() = _Initial;
  const factory CryptoDetailState.loading() = _Loading;
  const factory CryptoDetailState.loaded(Crypto crypto) = _Loaded;
  const factory CryptoDetailState.error(String message) = _Error;
}
