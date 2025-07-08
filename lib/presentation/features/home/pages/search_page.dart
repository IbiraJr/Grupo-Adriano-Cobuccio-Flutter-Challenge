import 'package:brasil_card/presentation/features/home/viewmodels/crypto_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/crypto_view_model.dart';
import '../../../shared/widgets/crypto_list_item.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Focar no campo de busca quando a página for aberta
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Adicionar um pequeno atraso para evitar muitas chamadas durante a digitação
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == query) {
        ref.read(cryptoViewModelProvider.notifier).searchCryptos(query);
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
    });
    ref.read(cryptoViewModelProvider.notifier).getCryptos();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cryptoViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Buscar criptomoedas...',
            border: InputBorder.none,
            hintStyle: const TextStyle(color: Colors.white70),
            suffixIcon:
                _isSearching
                    ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: _clearSearch,
                    )
                    : null,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: _onSearch,
        ),
      ),
      body:
          _isSearching
              ? state.when(
                initial:
                    () => const Center(child: Text('Digite para buscar...')),
                loading: () => const LoadingWidget(),
                loaded:
                    (cryptos, isLoadingMore) => _buildSearchResults(cryptos),
                error:
                    (message) => CustomErrorWidget(
                      message: message,
                      onRetry: () => _onSearch(_searchController.text),
                    ),
              )
              : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Digite o nome ou símbolo da criptomoeda',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildSearchResults(List<dynamic> cryptos) {
    if (cryptos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Nenhum resultado encontrado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tente buscar por outro termo',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cryptos.length,
      itemBuilder: (context, index) {
        return CryptoListItem(crypto: cryptos[index]);
      },
    );
  }
}
