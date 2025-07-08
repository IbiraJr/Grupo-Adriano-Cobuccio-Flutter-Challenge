import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/crypto.dart';

part 'crypto_dto.g.dart';

@JsonSerializable()
class CryptoDto {
  final String id;
  final String symbol;
  final String name;
  final String? image;
  
  @JsonKey(name: 'current_price')
  final double currentPrice;
  
  @JsonKey(name: 'market_cap')
  final double? marketCap;
  
  @JsonKey(name: 'market_cap_rank')
  final int? marketCapRank;
  
  @JsonKey(name: 'total_volume')
  final double? totalVolume;
  
  @JsonKey(name: 'high_24h')
  final double? high24h;
  
  @JsonKey(name: 'low_24h')
  final double? low24h;
  
  @JsonKey(name: 'price_change_24h')
  final double? priceChange24h;
  
  @JsonKey(name: 'price_change_percentage_24h')
  final double? priceChangePercentage24h;
  
  @JsonKey(name: 'circulating_supply')
  final double? circulatingSupply;
  
  @JsonKey(name: 'total_supply')
  final double? totalSupply;
  
  @JsonKey(name: 'max_supply')
  final double? maxSupply;
  
  @JsonKey(name: 'last_updated')
  final String lastUpdated;

  const CryptoDto({
    required this.id,
    required this.symbol,
    required this.name,
    this.image,
    required this.currentPrice,
    this.marketCap,
    this.marketCapRank,
    this.totalVolume,
    this.high24h,
    this.low24h,
    this.priceChange24h,
    this.priceChangePercentage24h,
    this.circulatingSupply,
    this.totalSupply,
    this.maxSupply,
    required this.lastUpdated,
  });

  factory CryptoDto.fromJson(Map<String, dynamic> json) =>
      _$CryptoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoDtoToJson(this);

  Crypto toEntity() {
    return Crypto(
      id: id,
      symbol: symbol,
      name: name,
      image: image,
      currentPrice: currentPrice,
      marketCap: marketCap,
      marketCapRank: marketCapRank,
      totalVolume: totalVolume,
      high24h: high24h,
      low24h: low24h,
      priceChange24h: priceChange24h,
      priceChangePercentage24h: priceChangePercentage24h,
      circulatingSupply: circulatingSupply,
      totalSupply: totalSupply,
      maxSupply: maxSupply,
      lastUpdated: DateTime.parse(lastUpdated),
    );
  }
}