// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoDto _$CryptoDtoFromJson(Map<String, dynamic> json) => CryptoDto(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  name: json['name'] as String,
  image: json['image'] as String?,
  currentPrice: (json['current_price'] as num).toDouble(),
  marketCap: (json['market_cap'] as num?)?.toDouble(),
  marketCapRank: (json['market_cap_rank'] as num?)?.toInt(),
  totalVolume: (json['total_volume'] as num?)?.toDouble(),
  high24h: (json['high_24h'] as num?)?.toDouble(),
  low24h: (json['low_24h'] as num?)?.toDouble(),
  priceChange24h: (json['price_change_24h'] as num?)?.toDouble(),
  priceChangePercentage24h:
      (json['price_change_percentage_24h'] as num?)?.toDouble(),
  circulatingSupply: (json['circulating_supply'] as num?)?.toDouble(),
  totalSupply: (json['total_supply'] as num?)?.toDouble(),
  maxSupply: (json['max_supply'] as num?)?.toDouble(),
  lastUpdated: json['last_updated'] as String,
);

Map<String, dynamic> _$CryptoDtoToJson(CryptoDto instance) => <String, dynamic>{
  'id': instance.id,
  'symbol': instance.symbol,
  'name': instance.name,
  'image': instance.image,
  'current_price': instance.currentPrice,
  'market_cap': instance.marketCap,
  'market_cap_rank': instance.marketCapRank,
  'total_volume': instance.totalVolume,
  'high_24h': instance.high24h,
  'low_24h': instance.low24h,
  'price_change_24h': instance.priceChange24h,
  'price_change_percentage_24h': instance.priceChangePercentage24h,
  'circulating_supply': instance.circulatingSupply,
  'total_supply': instance.totalSupply,
  'max_supply': instance.maxSupply,
  'last_updated': instance.lastUpdated,
};
