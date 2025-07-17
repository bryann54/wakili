// features/chat_history/data/datasources/chat_history_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';

@injectable
class ChatHistoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  ChatHistoryRemoteDataSource(this._firestore);

  static const String _chatCollectionName = 'chatConversations';
  Future<String> saveConversation({
    required ChatConversation conversation,
  }) async {
    try {
      final Map<String, dynamic> dataToSave = conversation.toJson();

      if (conversation.id.isNotEmpty &&
          conversation.id != 'new_conversation_temp_id') {
        await _firestore
            .collection(_chatCollectionName)
            .doc(conversation.id)
            .set(dataToSave, SetOptions(merge: true));
        return conversation.id;
      } else {
        final docRef =
            await _firestore.collection(_chatCollectionName).add(dataToSave);
        return docRef.id;
      }
    } catch (e) {
      throw Exception('Failed to save conversation: $e');
    }
  }

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
}
