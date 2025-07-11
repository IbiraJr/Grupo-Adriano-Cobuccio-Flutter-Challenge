import 'package:brasil_card/presentation/app/theme.dart';
import 'package:brasil_card/presentation/features/favorites/viewmodels/favorites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../viewmodels/favorites_view_model.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/error_widget.dart';
import '../../../shared/widgets/crypto_list_item.dart';

class FavoritesPage extends ConsumerStatefulWidget {
  const FavoritesPage({super.key});

  @override
  ConsumerState<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends ConsumerState<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    // Carregar favoritos quando a página for inicializada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoritesViewModelProvider.notifier).getFavorites();
    });
  }

  Future<void> _onRefresh() async {
    await ref.read(favoritesViewModelProvider.notifier).getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favoritesViewModelProvider);
    final padding = AppTheme.getResponsivePadding(context);
    final fontSize = AppTheme.getResponsiveFontSize(context);
    final iconSize = AppTheme.getResponsiveIconSize(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _onRefresh),
        ],
      ),
      body: state.when(
        initial: () => Center(child: Text('Carregando favoritos...', style: TextStyle(fontSize: fontSize))),
        loading: () => const LoadingWidget(),
        loaded: (favorites) => _buildFavoritesList(favorites, padding, fontSize, iconSize),
        error:
            (message) => CustomErrorWidget(
              message: message,
              onRetry:
                  () =>
                      ref
                          .read(favoritesViewModelProvider.notifier)
                          .getFavorites(),
            ),
      ),
    );
  }

  Widget _buildFavoritesList(List<dynamic> favorites, double padding, double fontSize, double iconSize) {
    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: iconSize * 2, color: Colors.grey[400]),
            SizedBox(height: padding),
            Text(
              'Você ainda não tem favoritos',
              style: TextStyle(
                fontSize: fontSize * 1.1,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: padding / 2),
            Text(
              'Adicione criptomoedas aos favoritos na tela inicial',
              style: TextStyle(fontSize: fontSize * 0.9, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: EdgeInsets.all(padding),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return CryptoListItem(crypto: favorites[index]);
        },
      ),
    );
  }
}
