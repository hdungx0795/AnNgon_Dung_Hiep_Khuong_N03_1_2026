// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 2;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      orderId: fields[0] as String,
      userId: fields[1] as int,
      items: (fields[2] as List).cast<OrderItemModel>(),
      totalAmount: fields[3] as int,
      paymentMethod: fields[4] as PaymentMethod,
      deliveryAddress: fields[5] as String,
      note: fields[6] as String,
      status: fields[7] as OrderStatus,
      shipperName: fields[8] as String,
      createdAt: fields[9] as DateTime,
      voucherCode: fields[10] as String?,
      discount: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.paymentMethod)
      ..writeByte(5)
      ..write(obj.deliveryAddress)
      ..writeByte(6)
      ..write(obj.note)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.shipperName)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.voucherCode)
      ..writeByte(11)
      ..write(obj.discount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
