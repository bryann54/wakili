// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_conversation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatConversationAdapter extends TypeAdapter<ChatConversation> {
  @override
  final int typeId = 1;

  @override
  ChatConversation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatConversation(
      id: fields[0] as String?,
      title: fields[1] as String,
      messages: (fields[2] as List).cast<ChatMessage>(),
      timestamp: fields[3] as DateTime?,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
      category: fields[6] as String?,
      tags: (fields[7] as List?)?.cast<String>(),
      isArchived: fields[8] as bool,
      isFavorite: fields[9] as bool,
      summary: fields[10] as String?,
      messageCount: fields[11] as int?,
      searchKeywords: (fields[12] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatConversation obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.messages)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.isArchived)
      ..writeByte(9)
      ..write(obj.isFavorite)
      ..writeByte(10)
      ..write(obj.summary)
      ..writeByte(11)
      ..write(obj.messageCount)
      ..writeByte(12)
      ..write(obj.searchKeywords);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConversationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
