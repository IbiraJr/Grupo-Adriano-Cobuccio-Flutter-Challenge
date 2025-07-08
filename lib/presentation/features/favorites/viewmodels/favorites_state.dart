import 'package:brasil_card/domain/entities/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorites_state.freezed.dart';

@freezed
class FavoritesState with _$FavoritesState {
  const factory FavoritesState.initial() = _Initial;
  const factory FavoritesState.loading() = _Loading;
  const factory FavoritesState.loaded(List<Crypto> favorites) = _Loaded;
  const factory FavoritesState.error(String message) = _Error;
}