import 'package:brasil_card/core/router/app_router.dart';
import 'package:brasil_card/domain/entities/crypto.dart';
import 'package:brasil_card/presentation/features/crypto/viewmodels/crypto_detail_state.dart';
import 'package:brasil_card/presentation/features/crypto/viewmodels/crypto_detail_view_model.dart';
import 'package:brasil_card/presentation/shared/widgets/error_widget.dart';
import 'package:brasil_card/presentation/shared/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CryptoDetailPage extends ConsumerStatefulWidget {
  final String cryptoId;

  const CryptoDetailPage({super.key, required this.cryptoId});

  @override
  ConsumerState<CryptoDetailPage> createState() => _CryptoDetailPageState();
}

class _CryptoDetailPageState extends ConsumerState<CryptoDetailPage> {
  @override
  void initState() {
    super.initState();
    // Carregar detalhes da criptomoeda quando a página for inicializada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(cryptoDetailViewModelProvider.notifier)
          .getCryptoDetail(widget.cryptoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cryptoDetailViewModelProvider);
    final isFavorite = ref.watch(isFavoriteProvider(widget.cryptoId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRouter.home),
        ),
        actions: [
          state.maybeWhen(
            loaded:
                (crypto) => IconButton(
                  icon: Icon(
                    isFavorite.when(
                      data:
                          (isFav) =>
                              isFav ? Icons.favorite : Icons.favorite_border,
                      loading: () => Icons.favorite_border,
                      error: (_, __) => Icons.favorite_border,
                    ),
                    color: isFavorite.maybeWhen(
                      data: (isFav) => isFav ? Colors.red : null,
                      orElse: () => null,
                    ),
                  ),
                  onPressed: () {
                    ref
                        .read(cryptoDetailViewModelProvider.notifier)
                        .toggleFavorite(crypto);
                  },
                ),
            orElse: () => const SizedBox(),
          ),
        ],
      ),
      body: state.when(
        initial: () => const Center(child: Text('Carregando...')),
        loading: () => const LoadingWidget(),
        loaded: (crypto) => _buildCryptoDetails(crypto),
        error:
            (message) => CustomErrorWidget(
              message: message,
              onRetry:
                  () => ref
                      .read(cryptoDetailViewModelProvider.notifier)
                      .getCryptoDetail(widget.cryptoId),
            ),
      ),
    );
  }

  Widget _buildCryptoDetails(Crypto crypto) {
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
    );
    final percentFormat = NumberFormat.percentPattern('pt_BR');
    final numberFormat = NumberFormat.decimalPattern('pt_BR');
    final dateFormat = DateFormat('dd/mm/yyyy HH:mm');

    final isPositive =
        crypto.priceChangePercentage24h != null &&
        crypto.priceChangePercentage24h! >= 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho com imagem e informações básicas
          Row(
            children: [
              // Imagem da criptomoeda
              if (crypto.image != null)
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(crypto.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: const Icon(
                    Icons.currency_bitcoin,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

              // Nome e símbolo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      crypto.symbol.toUpperCase(),
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    if (crypto.marketCapRank != null)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Rank #${crypto.marketCapRank}',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Preço atual
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Preço Atual',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(crypto.currentPrice),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (crypto.priceChangePercentage24h != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color:
                              isPositive ? Colors.green[700] : Colors.red[700],
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${isPositive ? '+' : ''}${currencyFormat.format(crypto.priceChange24h ?? 0)}',
                          style: TextStyle(
                            color:
                                isPositive
                                    ? Colors.green[700]
                                    : Colors.red[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isPositive
                                    ? Colors.green[100]
                                    : Colors.red[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${isPositive ? '+' : ''}${percentFormat.format(crypto.priceChangePercentage24h! / 100)}',
                            style: TextStyle(
                              color:
                                  isPositive
                                      ? Colors.green[800]
                                      : Colors.red[800],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Variação de preço em 24h
          if (crypto.high24h != null && crypto.low24h != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Variação em 24h',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Mínimo 24h'),
                            const SizedBox(height: 4),
                            Text(
                              currencyFormat.format(crypto.low24h),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Máximo 24h'),
                            const SizedBox(height: 4),
                            Text(
                              currencyFormat.format(crypto.high24h),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Informações de mercado
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações de Mercado',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    'Cap. de Mercado',
                    crypto.marketCap != null
                        ? currencyFormat.format(crypto.marketCap)
                        : 'N/A',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Volume 24h',
                    crypto.totalVolume != null
                        ? currencyFormat.format(crypto.totalVolume)
                        : 'N/A',
                  ),
                  const Divider(),
                  _buildInfoRow(
                    'Fornecimento Circulante',
                    crypto.circulatingSupply != null
                        ? '${numberFormat.format(crypto.circulatingSupply)} ${crypto.symbol.toUpperCase()}'
                        : 'N/A',
                  ),
                  if (crypto.totalSupply != null) ...[
                    const Divider(),
                    _buildInfoRow(
                      'Fornecimento Total',
                      '${numberFormat.format(crypto.totalSupply)} ${crypto.symbol.toUpperCase()}',
                    ),
                  ],
                  if (crypto.maxSupply != null) ...[
                    const Divider(),
                    _buildInfoRow(
                      'Fornecimento Máximo',
                      '${numberFormat.format(crypto.maxSupply)} ${crypto.symbol.toUpperCase()}',
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Última atualização
          Align(
            alignment: Alignment.center,
            child: Text(
              'Última atualização: ${dateFormat.format(crypto.lastUpdated)}',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
