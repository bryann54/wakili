// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:flutter/material.dart' as _i9;
import 'package:wakili/features/account/presentation/pages/account_screen.dart'
    as _i1;
import 'package:wakili/features/history/presentation/pages/chat_history_screen.dart'
    as _i3;
import 'package:wakili/features/overview/presentation/pages/overview_screen.dart'
    as _i6;
import 'package:wakili/features/wakili/data/models/legal_category.dart' as _i10;
import 'package:wakili/features/wakili/presentation/pages/category_chat_screen.dart'
    as _i2;
import 'package:wakili/features/wakili/presentation/pages/general_chat_screen.dart'
    as _i4;
import 'package:wakili/features/wakili/presentation/pages/wakili_chat_screen.dart'
    as _i7;
import 'package:wakili/main_screen.dart' as _i5;

/// generated route for
/// [_i1.AccountScreen]
class AccountRoute extends _i8.PageRouteInfo<void> {
  const AccountRoute({List<_i8.PageRouteInfo>? children})
      : super(AccountRoute.name, initialChildren: children);

  static const String name = 'AccountRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.AccountScreen();
    },
  );
}

/// generated route for
/// [_i2.CategoryChatScreen]
class CategoryChatRoute extends _i8.PageRouteInfo<CategoryChatRouteArgs> {
  CategoryChatRoute({
    _i9.Key? key,
    required _i10.LegalCategory category,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          CategoryChatRoute.name,
          args: CategoryChatRouteArgs(key: key, category: category),
          initialChildren: children,
        );

  static const String name = 'CategoryChatRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryChatRouteArgs>();
      return _i2.CategoryChatScreen(key: args.key, category: args.category);
    },
  );
}

class CategoryChatRouteArgs {
  const CategoryChatRouteArgs({this.key, required this.category});

  final _i9.Key? key;

  final _i10.LegalCategory category;

  @override
  String toString() {
    return 'CategoryChatRouteArgs{key: $key, category: $category}';
  }
}

/// generated route for
/// [_i3.ChatHistoryScreen]
class ChatHistoryRoute extends _i8.PageRouteInfo<void> {
  const ChatHistoryRoute({List<_i8.PageRouteInfo>? children})
      : super(ChatHistoryRoute.name, initialChildren: children);

  static const String name = 'ChatHistoryRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i3.ChatHistoryScreen();
    },
  );
}

/// generated route for
/// [_i4.GeneralChatScreen]
class GeneralChatRoute extends _i8.PageRouteInfo<GeneralChatRouteArgs> {
  GeneralChatRoute({
    _i9.Key? key,
    required String initialMessage,
    List<_i8.PageRouteInfo>? children,
  }) : super(
          GeneralChatRoute.name,
          args: GeneralChatRouteArgs(key: key, initialMessage: initialMessage),
          initialChildren: children,
        );

  static const String name = 'GeneralChatRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<GeneralChatRouteArgs>();
      return _i4.GeneralChatScreen(
        key: args.key,
        initialMessage: args.initialMessage,
      );
    },
  );
}

class GeneralChatRouteArgs {
  const GeneralChatRouteArgs({this.key, required this.initialMessage});

  final _i9.Key? key;

  final String initialMessage;

  @override
  String toString() {
    return 'GeneralChatRouteArgs{key: $key, initialMessage: $initialMessage}';
  }
}

/// generated route for
/// [_i5.MainScreen]
class MainRoute extends _i8.PageRouteInfo<void> {
  const MainRoute({List<_i8.PageRouteInfo>? children})
      : super(MainRoute.name, initialChildren: children);

  static const String name = 'MainRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.MainScreen();
    },
  );
}

/// generated route for
/// [_i6.OverviewScreen]
class OverviewRoute extends _i8.PageRouteInfo<void> {
  const OverviewRoute({List<_i8.PageRouteInfo>? children})
      : super(OverviewRoute.name, initialChildren: children);

  static const String name = 'OverviewRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.OverviewScreen();
    },
  );
}

/// generated route for
/// [_i7.WakiliChatScreen]
class WakiliChatRoute extends _i8.PageRouteInfo<void> {
  const WakiliChatRoute({List<_i8.PageRouteInfo>? children})
      : super(WakiliChatRoute.name, initialChildren: children);

  static const String name = 'WakiliChatRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.WakiliChatScreen();
    },
  );
}
