import 'package:brasil_card/core/providers/providers.dart';
import 'package:brasil_card/domain/entities/crypto.dart';
import 'package:brasil_card/domain/repositories/crypto_repository.dart';
import 'package:brasil_card/presentation/features/favorites/viewmodels/favorites_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesViewModel extends StateNotifier<FavoritesState> {
  final CryptoRepository _repository;

  FavoritesViewModel(this._repository) : super(const FavoritesState.initial());

  Future<void> getFavorites() async {
    state = const FavoritesState.loading();

    final result = await _repository.getFavorites();

    result.fold(
      (failure) => state = FavoritesState.error(failure.toString()),
      (favorites) => state = FavoritesState.loaded(favorites),
    );
  }

  Future<void> removeFromFavorites(String cryptoId) async {
    final result = await _repository.removeFromFavorites(cryptoId);

    result.fold((failure) => state = FavoritesState.error(failure.toString()), (
      _,
    ) {
      state = state.maybeWhen(
        loaded: (favorites) {
          final updatedFavorites =
              favorites.where((crypto) => crypto.id != cryptoId).toList();
          return FavoritesState.loaded(updatedFavorites);
        },
        orElse: () => state,
      );
    });
  }

  Future<void> addToFavorites(Crypto crypto) async {
    final result = await _repository.addToFavorites(crypto);

    result.fold((failure) => state = FavoritesState.error(failure.toString()), (
      _,
    ) {
      state = state.maybeWhen(
        loaded: (favorites) {
          final List<Crypto> updatedFavorites = [...favorites, crypto];
          return FavoritesState.loaded(updatedFavorites);
        },
        orElse: () => FavoritesState.loaded([crypto]),
      );
    });
  }

  Future<bool> isFavorite(String cryptoId) async {
    final result = await _repository.isFavorite(cryptoId);
    return result.fold((failure) => false, (isFavorite) => isFavorite);
  }
}

// Provider for FavoritesViewModel
final favoritesViewModelProvider =
    StateNotifierProvider<FavoritesViewModel, FavoritesState>((ref) {
      final repository = ref.watch(cryptoRepositoryProvider);
      return FavoritesViewModel(repository);
    });
