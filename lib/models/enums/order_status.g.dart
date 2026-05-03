// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderStatusAdapter extends TypeAdapter<OrderStatus> {
  @override
  final int typeId = 7;

  @override
  OrderStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrderStatus.created;
      case 1:
        return OrderStatus.confirmed;
      case 2:
        return OrderStatus.preparing;
      case 3:
        return OrderStatus.delivering;
      case 4:
        return OrderStatus.delivered;
      case 5:
        return OrderStatus.completed;
      default:
        return OrderStatus.created;
    }
  }

  @override
  void write(BinaryWriter writer, OrderStatus obj) {
    switch (obj) {
      case OrderStatus.created:
        writer.writeByte(0);
        break;
      case OrderStatus.confirmed:
        writer.writeByte(1);
        break;
      case OrderStatus.preparing:
        writer.writeByte(2);
        break;
      case OrderStatus.delivering:
        writer.writeByte(3);
        break;
      case OrderStatus.delivered:
        writer.writeByte(4);
        break;
      case OrderStatus.completed:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
