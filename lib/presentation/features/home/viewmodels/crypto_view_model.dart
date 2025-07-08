import 'package:brasil_card/core/providers/providers.dart';
import 'package:brasil_card/domain/entities/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/repositories/crypto_repository.dart';
import 'crypto_state.dart';

class CryptoViewModel extends StateNotifier<CryptoState> {
  final CryptoRepository _repository;

  CryptoViewModel(this._repository) : super(const CryptoState.initial());

  Future<void> getCryptos({
    String? query,
    int page = 1,
    int perPage = 20,
    bool isRefresh = false,
  }) async {
    // if (isRefresh) {
    //   state = const CryptoState.loading();
    // } else if (page == 1) {
    //   state = const CryptoState.loading();
    // } else {
    //   state = state.copyWith(isLoadingMore: true);
    // }

    final result = await _repository.getCryptos(
      query: query,
      page: page,
      perPage: perPage,
    );

    result.fold(
      (failure) => state = CryptoState.error(failure.toString()),
      (cryptos) {
        if (page == 1 || isRefresh) {
          state = CryptoState.loaded(cryptos);
        } else {
          // Append new cryptos to existing list
          final currentCryptos = state.maybeWhen(
            loaded: (cryptos, isLoadingMore) => cryptos,
            orElse: () => <Crypto>[],
          );
          state = CryptoState.loaded([...currentCryptos, ...cryptos]);
        }
      },
    );
  }

  Future<void> searchCryptos(String query) async {
    if (query.isEmpty) {
      await getCryptos();
      return;
    }

    state = const CryptoState.loading();

    final result = await _repository.searchCryptos(query);

    result.fold(
      (failure) => state = CryptoState.error(failure.toString()),
      (cryptos) => state = CryptoState.loaded(cryptos),
    );
  }

  Future<void> refreshCryptos() async {
    await getCryptos(isRefresh: true);
  }
}

// Provider for CryptoViewModel
final cryptoViewModelProvider = StateNotifierProvider<CryptoViewModel, CryptoState>((ref) {
  final repository = ref.watch(cryptoRepositoryProvider);
  return CryptoViewModel(repository);
});