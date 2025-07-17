import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

@injectable
class ChatHistoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChatHistoryRemoteDataSource(this._firestore);

  static const String _chatCollectionName = 'chatConversations';

  /// Saves a list of chat messages as a single conversation.

  Future<String> saveConversation({
    required String userId,
    required String category,
    required List<ChatMessage> messages,
    String? conversationId,
  }) async {
    try {
      final conversationData = {
        'userId': userId,
        'category': category,
        'timestamp': FieldValue.serverTimestamp(),
        'messages': messages.map((msg) => _chatMessageToMap(msg)).toList(),
      };

      if (conversationId != null) {
        await _firestore
            .collection(_chatCollectionName)
            .doc(conversationId)
            .update(conversationData);
        return conversationId;
      } else {
        final docRef = await _firestore
            .collection(_chatCollectionName)
            .add(conversationData);
        return docRef.id;
      }
    } catch (e) {
      throw Exception('Failed to save conversation: $e');
    }
  }

  /// Fetches all conversations for a given user.
  Future<List<Map<String, dynamic>>> getConversations(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_chatCollectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch conversations: $e');
    }
  }

  /// Fetches a specific conversation by its ID.
  Future<Map<String, dynamic>?> getConversationById(
      String conversationId) async {
    try {
      final docSnapshot = await _firestore
          .collection(_chatCollectionName)
          .doc(conversationId)
          .get();
      if (docSnapshot.exists) {
        return {...docSnapshot.data()!, 'id': docSnapshot.id};
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get conversation by ID: $e');
    }
  }

  /// Deletes a conversation by its ID.
  Future<void> deleteConversation(String conversationId) async {
    try {
      await _firestore
          .collection(_chatCollectionName)
          .doc(conversationId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete conversation: $e');
    }
  }

  Map<String, dynamic> _chatMessageToMap(ChatMessage message) {
    return {
      'id': message.id,
      'content': message.content,
      'isUser': message.isUser,
      'timestamp': message.timestamp.toIso8601String(),
      'messageType': message.messageType,
      'metadata': message.metadata,
      'parentMessageId': message.parentMessageId,
      'isEdited': message.isEdited,
      'editedAt': message.editedAt?.toIso8601String(),
      'originalContent': message.originalContent,
      'attachments': message.attachments,
      'confidenceScore': message.confidenceScore,
      'isBookmarked': message.isBookmarked,
    };
  }
}
