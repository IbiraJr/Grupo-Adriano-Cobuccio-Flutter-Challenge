import 'package:brasil_card/presentation/features/home/viewmodels/crypto_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/crypto_view_model.dart';
import '../../../shared/widgets/crypto_list_item.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cryptoViewModelProvider.notifier).getCryptos();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    final state = ref.read(cryptoViewModelProvider);
    state.maybeWhen(
      loaded: (cryptos, isLoadingMore) {
        if (!isLoadingMore && cryptos.isNotEmpty) {
          _currentPage++;
          ref
              .read(cryptoViewModelProvider.notifier)
              .getCryptos(page: _currentPage);
        }
      },
      orElse: () {},
    );
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    await ref.read(cryptoViewModelProvider.notifier).refreshCryptos();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cryptoViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BrasilCripto'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _onRefresh),
        ],
      ),
      body: state.when(
        initial: () => const Center(child: Text('Carregando...')),
        loading: () => const LoadingWidget(),
        loaded:
            (cryptos, isLoadingMore) =>
                _buildCryptoList(cryptos, isLoadingMore),
        error:
            (message) => CustomErrorWidget(
              message: message,
              onRetry:
                  () => ref.read(cryptoViewModelProvider.notifier).getCryptos(),
            ),
      ),
    );
  }

  Widget _buildCryptoList(List<dynamic> cryptos, bool isLoadingMore) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: cryptos.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == cryptos.length) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          return CryptoListItem(crypto: cryptos[index]);
        },
      ),
    );
  }
}
