// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:wakili/features/account/presentation/pages/account_screen.dart'
    as _i1;
import 'package:wakili/features/chat_history/presentation/pages/chat_history_screen.dart'
    as _i3;
import 'package:wakili/features/chat_history/presentation/pages/chat_screen.dart'
    as _i4;
import 'package:wakili/features/overview/presentation/pages/overview_screen.dart'
    as _i7;
import 'package:wakili/features/wakili/data/models/chat_message.dart' as _i12;
import 'package:wakili/features/wakili/data/models/legal_category.dart' as _i11;
import 'package:wakili/features/wakili/presentation/pages/category_chat_screen.dart'
    as _i2;
import 'package:wakili/features/wakili/presentation/pages/general_chat_screen.dart'
    as _i5;
import 'package:wakili/features/wakili/presentation/pages/wakili_chat_screen.dart'
    as _i8;
import 'package:wakili/main_screen.dart' as _i6;

/// generated route for
/// [_i1.AccountScreen]
class AccountRoute extends _i9.PageRouteInfo<void> {
  const AccountRoute({List<_i9.PageRouteInfo>? children})
      : super(
          AccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i1.AccountScreen();
    },
  );
}

/// generated route for
/// [_i2.CategoryChatScreen]
class CategoryChatRoute extends _i9.PageRouteInfo<CategoryChatRouteArgs> {
  CategoryChatRoute({
    _i10.Key? key,
    required _i11.LegalCategory category,
    List<_i12.ChatMessage>? initialMessages,
    String? conversationId,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          CategoryChatRoute.name,
          args: CategoryChatRouteArgs(
            key: key,
            category: category,
            initialMessages: initialMessages,
            conversationId: conversationId,
          ),
          initialChildren: children,
        );

  static const String name = 'CategoryChatRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryChatRouteArgs>();
      return _i2.CategoryChatScreen(
        key: args.key,
        category: args.category,
        initialMessages: args.initialMessages,
        conversationId: args.conversationId,
      );
    },
  );
}

class CategoryChatRouteArgs {
  const CategoryChatRouteArgs({
    this.key,
    required this.category,
    this.initialMessages,
    this.conversationId,
  });

  final _i10.Key? key;

  final _i11.LegalCategory category;

  final List<_i12.ChatMessage>? initialMessages;

  final String? conversationId;

  @override
  String toString() {
    return 'CategoryChatRouteArgs{key: $key, category: $category, initialMessages: $initialMessages, conversationId: $conversationId}';
  }
}

/// generated route for
/// [_i3.ChatHistoryScreen]
class ChatHistoryRoute extends _i9.PageRouteInfo<void> {
  const ChatHistoryRoute({List<_i9.PageRouteInfo>? children})
      : super(
          ChatHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatHistoryRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i3.ChatHistoryScreen();
    },
  );
}

/// generated route for
/// [_i4.ChatScreen]
class ChatRoute extends _i9.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i10.Key? key,
    List<_i12.ChatMessage>? initialMessages,
    String? conversationId,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          ChatRoute.name,
          args: ChatRouteArgs(
            key: key,
            initialMessages: initialMessages,
            conversationId: conversationId,
          ),
          initialChildren: children,
        );

  static const String name = 'ChatRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<ChatRouteArgs>(orElse: () => const ChatRouteArgs());
      return _i4.ChatScreen(
        key: args.key,
        initialMessages: args.initialMessages,
        conversationId: args.conversationId,
      );
    },
  );
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    this.initialMessages,
    this.conversationId,
  });

  final _i10.Key? key;

  final List<_i12.ChatMessage>? initialMessages;

  final String? conversationId;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, initialMessages: $initialMessages, conversationId: $conversationId}';
  }
}

/// generated route for
/// [_i5.GeneralChatScreen]
class GeneralChatRoute extends _i9.PageRouteInfo<GeneralChatRouteArgs> {
  GeneralChatRoute({
    _i10.Key? key,
    String? initialMessage,
    List<_i12.ChatMessage>? initialMessages,
    String? conversationId,
    List<_i9.PageRouteInfo>? children,
  }) : super(
          GeneralChatRoute.name,
          args: GeneralChatRouteArgs(
            key: key,
            initialMessage: initialMessage,
            initialMessages: initialMessages,
            conversationId: conversationId,
          ),
          initialChildren: children,
        );

  static const String name = 'GeneralChatRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GeneralChatRouteArgs>(
          orElse: () => const GeneralChatRouteArgs());
      return _i5.GeneralChatScreen(
        key: args.key,
        initialMessage: args.initialMessage,
        initialMessages: args.initialMessages,
        conversationId: args.conversationId,
      );
    },
  );
}

class GeneralChatRouteArgs {
  const GeneralChatRouteArgs({
    this.key,
    this.initialMessage,
    this.initialMessages,
    this.conversationId,
  });

  final _i10.Key? key;

  final String? initialMessage;

  final List<_i12.ChatMessage>? initialMessages;

  final String? conversationId;

  @override
  String toString() {
    return 'GeneralChatRouteArgs{key: $key, initialMessage: $initialMessage, initialMessages: $initialMessages, conversationId: $conversationId}';
  }
}

/// generated route for
/// [_i6.MainScreen]
class MainRoute extends _i9.PageRouteInfo<void> {
  const MainRoute({List<_i9.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i6.MainScreen();
    },
  );
}

/// generated route for
/// [_i7.OverviewScreen]
class OverviewRoute extends _i9.PageRouteInfo<void> {
  const OverviewRoute({List<_i9.PageRouteInfo>? children})
      : super(
          OverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'OverviewRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i7.OverviewScreen();
    },
  );
}

/// generated route for
/// [_i8.WakiliChatScreen]
class WakiliChatRoute extends _i9.PageRouteInfo<void> {
  const WakiliChatRoute({List<_i9.PageRouteInfo>? children})
      : super(
          WakiliChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'WakiliChatRoute';

  static _i9.PageInfo page = _i9.PageInfo(
    name,
    builder: (data) {
      return const _i8.WakiliChatScreen();
    },
  );
}
