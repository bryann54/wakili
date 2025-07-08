import 'package:injectable/injectable.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/features/wakili/domain/repositories/wakili_chat_repository.dart';
import 'package:dartz/dartz.dart'; // Import dartz for Either
import 'package:wakili/core/errors/failures.dart'; // Import failures

@injectable
class GenerateChatTitleUseCase {
  final WakiliChatRepository _repository;

  GenerateChatTitleUseCase(this._repository);

  // Changed to return Either<Failure, String> to propagate potential errors
  // from the repository's sendMessage method, allowing for more granular error handling
  // in the BLoC if needed, though current implementation handles fallbacks internally.
  Future<Either<Failure, String>> call(List<ChatMessage> messages) async {
    if (messages.isEmpty) return right('Empty Chat');

    final firstUserMessage = messages.firstWhere(
      (message) => message.isUser,
      orElse: () => messages.first,
    );

    if (firstUserMessage.content.length <= 50) {
      return right(_cleanupTitle(firstUserMessage.content));
    }

    try {
      final titlePrompt = _buildTitlePrompt(messages);
      final result = await _repository.sendMessage(
          titlePrompt); // This should return Either<Failure, String>

      return result.fold(
        (failure) {
          // If sendMessage failed, use a fallback title
          return right(_generateFallbackTitle(firstUserMessage.content));
        },
        (generatedTitle) {
          final cleanTitle = _cleanupGeneratedTitle(generatedTitle.toString());

          if (cleanTitle.length > 60 || cleanTitle.contains('\n')) {
            return right(_generateFallbackTitle(firstUserMessage.content));
          }
          return right(cleanTitle);
        },
      );
    } catch (e) {
      // This catch block handles unexpected exceptions during the process,
      // though ideally, the repository should return an Either.
      return right(_generateFallbackTitle(firstUserMessage.content));
    }
  }

  String _buildTitlePrompt(List<ChatMessage> messages) {
    final contextMessages = messages.take(3).toList();
    final conversationContext = contextMessages
        .map((msg) => '${msg.isUser ? "User" : "AI"}: ${msg.content}')
        .join('\n');

    return '''
Generate a concise, descriptive title (maximum 50 characters) for this legal consultation chat.
The title should capture the main legal topic or question being discussed.

Conversation:
$conversationContext

Requirements:
- Maximum 50 characters
- Focus on the main legal topic
- No quotes or special characters
- Professional and clear
- One line only

Title:''';
  }

  String _cleanupTitle(String title) {
    String cleaned =
        title.trim().replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ');

    if (cleaned.length > 40) {
      cleaned = cleaned.replaceFirst(
        RegExp(r'^(What|How|Why|When|Where|Can|Should|Is|Are|Do|Does)\s+',
            caseSensitive: false),
        '',
      );
    }

    if (cleaned.isNotEmpty) {
      cleaned = cleaned[0].toUpperCase() + cleaned.substring(1);
    }

    if (cleaned.length > 50) {
      cleaned = '${cleaned.substring(0, 47)}...';
    }

    return cleaned.isEmpty ? 'Legal Consultation' : cleaned;
  }

  String _cleanupGeneratedTitle(String generatedTitle) {
    final lines = generatedTitle.split('\n');
    String title = lines.first.trim();

    title = title.replaceFirst(RegExp(r'^Title:\s*', caseSensitive: false), '');
    title = title.replaceAll(RegExp(r'''^["']+|["']+$'''), '');

    return _cleanupTitle(title);
  }

  String _generateFallbackTitle(String firstMessage) {
    final legalTerms = [
      'contract',
      'agreement',
      'employment',
      'property',
      'divorce',
      'custody',
      'inheritance',
      'will',
      'lawsuit',
      'court',
      'legal',
      'rights',
      'liability',
      'damages',
      'settlement',
      'dispute',
      'business',
      'partnership',
      'trademark',
      'copyright',
      'patent',
      'criminal',
      'civil',
      'tenant',
      'landlord',
      'lease',
      'rent',
      'insurance',
      'claim',
      'accident',
      'injury',
      'compensation'
    ];

    String content = firstMessage.toLowerCase();
    final foundTerms =
        legalTerms.where((term) => content.contains(term)).toList();

    if (foundTerms.isNotEmpty) {
      final mainTerm = foundTerms.first;
      final words = firstMessage.split(' ').take(5).toList();
      final preview = words.join(' ');

      if (preview.length <= 45) {
        return _cleanupTitle(preview);
      } else {
        return _cleanupTitle(
            '${mainTerm[0].toUpperCase()}${mainTerm.substring(1)} Question');
      }
    }

    final timestamp = DateTime.now();
    return 'Legal Chat ${timestamp.day}/${timestamp.month}';
  }

  // The generateSummary methods should also ideally return Either<Failure, String>
  // if they interact with a repository that can fail.
  Future<Either<Failure, String>> generateSummary(
      List<ChatMessage> messages) async {
    if (messages.length < 4) {
      return right('Brief legal consultation chat');
    }

    try {
      final summaryPrompt = _buildSummaryPrompt(messages);
      final result = await _repository.sendMessage(
          summaryPrompt); // This should return Either<Failure, String>

      return result.fold(
        (failure) {
          // If sendMessage failed, use a fallback summary
          return right(_generateFallbackSummary(messages));
        },
        (generatedSummary) {
          return right(_cleanupSummary(generatedSummary.toString()));
        },
      );
    } catch (e) {
      return right(_generateFallbackSummary(messages));
    }
  }

  String _buildSummaryPrompt(List<ChatMessage> messages) {
    final keyMessages = messages.take(6).toList();
    final conversationContext = keyMessages
        .map((msg) => '${msg.isUser ? "User" : "AI"}: ${msg.content}')
        .join('\n');

    return '''
Create a brief summary (maximum 150 characters) of this legal consultation chat.
Focus on the main legal issue and key points discussed.

Conversation:
$conversationContext

Requirements:
- Maximum 150 characters
- Focus on main legal issue
- Professional tone
- No quotes
- One sentence if possible

Summary:''';
  }

  String _cleanupSummary(String summary) {
    String cleaned =
        summary.trim().replaceAll('\n', ' ').replaceAll(RegExp(r'\s+'), ' ');
    cleaned =
        cleaned.replaceFirst(RegExp(r'^Summary:\s*', caseSensitive: false), '');
    cleaned = cleaned.replaceAll(RegExp(r'''^["']+|["']+$'''), '');

    if (cleaned.length > 150) {
      cleaned = '${cleaned.substring(0, 147)}...';
    }

    return cleaned.isEmpty ? 'Legal consultation discussion' : cleaned;
  }

  String _generateFallbackSummary(List<ChatMessage> messages) {
    final userCount = messages.where((msg) => msg.isUser).length;
    final aiCount = messages.where((msg) => !msg.isUser).length;

    return 'Legal consultation with $userCount questions and $aiCount responses';
  }
}
