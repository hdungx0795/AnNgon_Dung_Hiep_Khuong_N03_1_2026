// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoucherModelAdapter extends TypeAdapter<VoucherModel> {
  @override
  final int typeId = 10;

  @override
  VoucherModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoucherModel(
      code: fields[0] as String,
      discountAmount: fields[1] as int,
      discountPercent: fields[2] as double,
      minOrderAmount: fields[3] as int,
      expiresAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, VoucherModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.discountAmount)
      ..writeByte(2)
      ..write(obj.discountPercent)
      ..writeByte(3)
      ..write(obj.minOrderAmount)
      ..writeByte(4)
      ..write(obj.expiresAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoucherModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
