import 'package:brasil_card/core/router/app_router.dart';
import 'package:brasil_card/presentation/app/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/crypto.dart';

class CryptoListItem extends StatelessWidget {
  final Crypto crypto;
  final VoidCallback? onTap;

  const CryptoListItem({Key? key, required this.crypto, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'pt_BR',
    );
    final percentFormat = NumberFormat.percentPattern('pt_BR');
    final isPositive =
        crypto.priceChangePercentage24h != null &&
        crypto.priceChangePercentage24h! >= 0;
        
    // Obter dimensões responsivas
    final padding = AppTheme.getResponsivePadding(context);
    final imageSize = AppTheme.getResponsiveImageSize(context);
    final titleFontSize = AppTheme.getResponsiveFontSize(context, baseFontSize: 16);
    final subtitleFontSize = AppTheme.getResponsiveFontSize(context, baseFontSize: 14);
    final priceFontSize = AppTheme.getResponsiveFontSize(context, baseFontSize: 16);
    final percentFontSize = AppTheme.getResponsiveFontSize(context, baseFontSize: 12);

    return Card(
      margin: EdgeInsets.only(bottom: padding),
      elevation: 2,
      child: InkWell(
        onTap:
            onTap ??
            () => {
              context.go(
                AppRouter.cryptoDetail.replaceFirst(':id', crypto.id),
              ),
            },
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              // Imagem da criptomoeda
              if (crypto.image != null)
                Container(
                  width: imageSize,
                  height: imageSize,
                  margin: EdgeInsets.only(right: padding),
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
                  width: imageSize,
                  height: imageSize,
                  margin: EdgeInsets.only(right: padding),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Icon(
                    Icons.currency_bitcoin,
                    color: Colors.white,
                    size: imageSize * 0.6,
                  ),
                ),

              // Informações da criptomoeda
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: padding / 4),
                    Text(
                      crypto.symbol.toUpperCase(),
                      style: TextStyle(color: Colors.grey[600], fontSize: subtitleFontSize),
                    ),
                  ],
                ),
              ),

              // Preço e variação
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(crypto.currentPrice),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: priceFontSize,
                    ),
                  ),
                  SizedBox(height: padding / 4),
                  if (crypto.priceChangePercentage24h != null)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: padding / 2,
                        vertical: padding / 4,
                      ),
                      decoration: BoxDecoration(
                        color: isPositive ? Colors.green[100] : Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (isPositive ? '+' : '') +
                            percentFormat.format(
                              crypto.priceChangePercentage24h! / 100,
                            ),
                        style: TextStyle(
                          color:
                              isPositive ? Colors.green[800] : Colors.red[800],
                          fontWeight: FontWeight.bold,
                          fontSize: percentFontSize,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
