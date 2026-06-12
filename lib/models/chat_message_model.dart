import 'package:hive/hive.dart';

part 'chat_message_model.g.dart';

@HiveType(typeId: 11)
class ChatMessageModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String text;
  
  @HiveField(2)
  final bool isMe;
  
  @HiveField(3)
  final DateTime timestamp;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}
