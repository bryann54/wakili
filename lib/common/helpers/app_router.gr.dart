// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/material.dart' as _i13;
import 'package:wakili/features/account/presentation/pages/account_screen.dart'
    as _i1;
import 'package:wakili/features/auth/presentation/pages/login_screen.dart'
    as _i6;
import 'package:wakili/features/auth/presentation/pages/register_screen.dart'
    as _i9;
import 'package:wakili/features/auth/presentation/pages/splash_screen.dart'
    as _i10;
import 'package:wakili/features/chat_history/presentation/pages/chat_history_screen.dart'
    as _i3;
import 'package:wakili/features/chat_history/presentation/pages/chat_screen.dart'
    as _i4;
import 'package:wakili/features/overview/presentation/pages/overview_screen.dart'
    as _i8;
import 'package:wakili/features/wakili/data/models/chat_message.dart' as _i15;
import 'package:wakili/features/wakili/data/models/legal_category.dart' as _i14;
import 'package:wakili/features/wakili/presentation/pages/category_chat_screen.dart'
    as _i2;
import 'package:wakili/features/wakili/presentation/pages/general_chat_screen.dart'
    as _i5;
import 'package:wakili/features/wakili/presentation/pages/wakili_chat_screen.dart'
    as _i11;
import 'package:wakili/main_screen.dart' as _i7;

/// generated route for
/// [_i1.AccountScreen]
class AccountRoute extends _i12.PageRouteInfo<void> {
  const AccountRoute({List<_i12.PageRouteInfo>? children})
      : super(
          AccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i1.AccountScreen();
    },
  );
}

/// generated route for
/// [_i2.CategoryChatScreen]
class CategoryChatRoute extends _i12.PageRouteInfo<CategoryChatRouteArgs> {
  CategoryChatRoute({
    _i13.Key? key,
    required _i14.LegalCategory category,
    List<_i15.ChatMessage>? initialMessages,
    String? conversationId,
    List<_i12.PageRouteInfo>? children,
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

  static _i12.PageInfo page = _i12.PageInfo(
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

  final _i13.Key? key;

  final _i14.LegalCategory category;

  final List<_i15.ChatMessage>? initialMessages;

  final String? conversationId;

  @override
  String toString() {
    return 'CategoryChatRouteArgs{key: $key, category: $category, initialMessages: $initialMessages, conversationId: $conversationId}';
  }
}

/// generated route for
/// [_i3.ChatHistoryScreen]
class ChatHistoryRoute extends _i12.PageRouteInfo<void> {
  const ChatHistoryRoute({List<_i12.PageRouteInfo>? children})
      : super(
          ChatHistoryRoute.name,
          initialChildren: children,
        );

  static const String name = 'ChatHistoryRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i3.ChatHistoryScreen();
    },
  );
}

/// generated route for
/// [_i4.ChatScreen]
class ChatRoute extends _i12.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i13.Key? key,
    List<_i15.ChatMessage>? initialMessages,
    String? conversationId,
    List<_i12.PageRouteInfo>? children,
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

  static _i12.PageInfo page = _i12.PageInfo(
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

  final _i13.Key? key;

  final List<_i15.ChatMessage>? initialMessages;

  final String? conversationId;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, initialMessages: $initialMessages, conversationId: $conversationId}';
  }
}

/// generated route for
/// [_i5.GeneralChatScreen]
class GeneralChatRoute extends _i12.PageRouteInfo<GeneralChatRouteArgs> {
  GeneralChatRoute({
    _i13.Key? key,
    String? initialMessage,
    List<_i15.ChatMessage>? initialMessages,
    String? conversationId,
    List<_i12.PageRouteInfo>? children,
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

  static _i12.PageInfo page = _i12.PageInfo(
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

  final _i13.Key? key;

  final String? initialMessage;

  final List<_i15.ChatMessage>? initialMessages;

  final String? conversationId;

  @override
  String toString() {
    return 'GeneralChatRouteArgs{key: $key, initialMessage: $initialMessage, initialMessages: $initialMessages, conversationId: $conversationId}';
  }
}

/// generated route for
/// [_i6.LoginScreen]
class LoginRoute extends _i12.PageRouteInfo<void> {
  const LoginRoute({List<_i12.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i6.LoginScreen();
    },
  );
}

/// generated route for
/// [_i7.MainScreen]
class MainRoute extends _i12.PageRouteInfo<void> {
  const MainRoute({List<_i12.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i7.MainScreen();
    },
  );
}

/// generated route for
/// [_i8.OverviewScreen]
class OverviewRoute extends _i12.PageRouteInfo<void> {
  const OverviewRoute({List<_i12.PageRouteInfo>? children})
      : super(
          OverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'OverviewRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i8.OverviewScreen();
    },
  );
}

/// generated route for
/// [_i9.RegisterScreen]
class RegisterRoute extends _i12.PageRouteInfo<void> {
  const RegisterRoute({List<_i12.PageRouteInfo>? children})
      : super(
          RegisterRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i9.RegisterScreen();
    },
  );
}

/// generated route for
/// [_i10.SplashScreen]
class SplashRoute extends _i12.PageRouteInfo<void> {
  const SplashRoute({List<_i12.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i10.SplashScreen();
    },
  );
}

/// generated route for
/// [_i11.WakiliChatScreen]
class WakiliChatRoute extends _i12.PageRouteInfo<void> {
  const WakiliChatRoute({List<_i12.PageRouteInfo>? children})
      : super(
          WakiliChatRoute.name,
          initialChildren: children,
        );

  static const String name = 'WakiliChatRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return const _i11.WakiliChatScreen();
    },
  );
}
