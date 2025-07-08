// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatMessageAdapter extends TypeAdapter<ChatMessage> {
  @override
  final int typeId = 0;

  @override
  ChatMessage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatMessage(
      id: fields[0] as String,
      content: fields[1] as String,
      isUser: fields[2] as bool,
      timestamp: fields[3] as DateTime,
      messageType: fields[4] as String?,
      metadata: (fields[5] as Map?)?.cast<String, dynamic>(),
      parentMessageId: fields[6] as String?,
      isEdited: fields[7] as bool,
      editedAt: fields[8] as DateTime?,
      originalContent: fields[9] as String?,
      attachments: (fields[10] as List?)?.cast<String>(),
      confidenceScore: fields[11] as double?,
      isBookmarked: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChatMessage obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.isUser)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.messageType)
      ..writeByte(5)
      ..write(obj.metadata)
      ..writeByte(6)
      ..write(obj.parentMessageId)
      ..writeByte(7)
      ..write(obj.isEdited)
      ..writeByte(8)
      ..write(obj.editedAt)
      ..writeByte(9)
      ..write(obj.originalContent)
      ..writeByte(10)
      ..write(obj.attachments)
      ..writeByte(11)
      ..write(obj.confidenceScore)
      ..writeByte(12)
      ..write(obj.isBookmarked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
