import 'package:brasil_card/core/providers/providers.dart';
import 'package:brasil_card/domain/entities/crypto.dart';
import 'package:brasil_card/domain/repositories/crypto_repository.dart';
import 'package:brasil_card/presentation/features/crypto/viewmodels/crypto_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class CryptoDetailViewModel extends StateNotifier<CryptoDetailState> {
  final CryptoRepository _repository;

  CryptoDetailViewModel(this._repository) : super(const CryptoDetailState.initial());

  Future<void> getCryptoDetail(String cryptoId) async {
    state = const CryptoDetailState.loading();

    final result = await _repository.getCryptoById(cryptoId);

    result.fold(
      (failure) => state = CryptoDetailState.error(failure.toString()),
      (crypto) => state = CryptoDetailState.loaded(crypto),
    );
  }

  Future<void> toggleFavorite(Crypto crypto) async {
    final isFavoriteResult = await _repository.isFavorite(crypto.id);
    
    await isFavoriteResult.fold(
      (failure) => null,
      (isFavorite) async {
        if (isFavorite) {
          await _repository.removeFromFavorites(crypto.id);
        } else {
          await _repository.addToFavorites(crypto);
        }
        
        // Update state to reflect the change
        state = state.maybeWhen(
          loaded: (loadedCrypto) => CryptoDetailState.loaded(loadedCrypto),
          orElse: () => state,
        );
      },
    );
  }

  Future<bool> isFavorite(String cryptoId) async {
    final result = await _repository.isFavorite(cryptoId);
    return result.fold(
      (failure) => false,
      (isFavorite) => isFavorite,
    );
  }
}

// Provider for CryptoDetailViewModel
final cryptoDetailViewModelProvider = StateNotifierProvider<CryptoDetailViewModel, CryptoDetailState>((ref) {
  final repository = ref.watch(cryptoRepositoryProvider);
  return CryptoDetailViewModel(repository);
});

// Provider for checking if a crypto is favorite
final isFavoriteProvider = FutureProvider.family<bool, String>((ref, cryptoId) async {
  final repository = ref.watch(cryptoRepositoryProvider);
  final result = await repository.isFavorite(cryptoId);
  return result.fold(
    (failure) => false,
    (isFavorite) => isFavorite,
  );
});