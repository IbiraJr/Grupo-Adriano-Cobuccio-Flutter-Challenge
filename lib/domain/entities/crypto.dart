import 'package:equatable/equatable.dart';
import 'package:hive_ce/hive.dart';


part 'crypto.g.dart';

@HiveType(typeId: 0)
class Crypto extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String symbol;
  
  @HiveField(2)
  final String name;
  
  @HiveField(3)
  final String? image;
  
  @HiveField(4)
  final double currentPrice;
  
  @HiveField(5)
  final double? marketCap;
  
  @HiveField(6)
  final int? marketCapRank;
  
  @HiveField(7)
  final double? totalVolume;
  
  @HiveField(8)
  final double? high24h;
  
  @HiveField(9)
  final double? low24h;
  
  @HiveField(10)
  final double? priceChange24h;
  
  @HiveField(11)
  final double? priceChangePercentage24h;
  
  @HiveField(12)
  final double? circulatingSupply;
  
  @HiveField(13)
  final double? totalSupply;
  
  @HiveField(14)
  final double? maxSupply;
  
  @HiveField(15)
  final DateTime lastUpdated;

  const Crypto({
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

  @override
  List<Object?> get props => [
        id,
        symbol,
        name,
        image,
        currentPrice,
        marketCap,
        marketCapRank,
        totalVolume,
        high24h,
        low24h,
        priceChange24h,
        priceChangePercentage24h,
        circulatingSupply,
        totalSupply,
        maxSupply,
        lastUpdated,
      ];
}