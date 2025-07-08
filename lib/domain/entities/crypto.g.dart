// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CryptoAdapter extends TypeAdapter<Crypto> {
  @override
  final typeId = 0;

  @override
  Crypto read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Crypto(
      id: fields[0] as String,
      symbol: fields[1] as String,
      name: fields[2] as String,
      image: fields[3] as String?,
      currentPrice: (fields[4] as num).toDouble(),
      marketCap: (fields[5] as num?)?.toDouble(),
      marketCapRank: (fields[6] as num?)?.toInt(),
      totalVolume: (fields[7] as num?)?.toDouble(),
      high24h: (fields[8] as num?)?.toDouble(),
      low24h: (fields[9] as num?)?.toDouble(),
      priceChange24h: (fields[10] as num?)?.toDouble(),
      priceChangePercentage24h: (fields[11] as num?)?.toDouble(),
      circulatingSupply: (fields[12] as num?)?.toDouble(),
      totalSupply: (fields[13] as num?)?.toDouble(),
      maxSupply: (fields[14] as num?)?.toDouble(),
      lastUpdated: fields[15] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Crypto obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.symbol)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.currentPrice)
      ..writeByte(5)
      ..write(obj.marketCap)
      ..writeByte(6)
      ..write(obj.marketCapRank)
      ..writeByte(7)
      ..write(obj.totalVolume)
      ..writeByte(8)
      ..write(obj.high24h)
      ..writeByte(9)
      ..write(obj.low24h)
      ..writeByte(10)
      ..write(obj.priceChange24h)
      ..writeByte(11)
      ..write(obj.priceChangePercentage24h)
      ..writeByte(12)
      ..write(obj.circulatingSupply)
      ..writeByte(13)
      ..write(obj.totalSupply)
      ..writeByte(14)
      ..write(obj.maxSupply)
      ..writeByte(15)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CryptoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
