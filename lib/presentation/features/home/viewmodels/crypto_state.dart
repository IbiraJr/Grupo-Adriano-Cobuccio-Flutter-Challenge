import 'package:brasil_card/domain/entities/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'crypto_state.freezed.dart';

@freezed
class CryptoState with _$CryptoState {
  const factory CryptoState.initial() = _Initial;
  const factory CryptoState.loading() = _Loading;
  const factory CryptoState.loaded(
    List<Crypto> cryptos, {
    @Default(false) bool isLoadingMore,
  }) = _Loaded;
  const factory CryptoState.error(String message) = _Error;
  
}
