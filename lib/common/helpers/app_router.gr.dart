// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:wakili/features/account/presentation/pages/account_screen.dart'
    as _i1;
import 'package:wakili/features/favourites/presentation/pages/favourites_screen.dart'
    as _i2;
import 'package:wakili/features/hotels/presentation/pages/full_image_screen.dart'
    as _i3;
import 'package:wakili/features/hotels/presentation/pages/hotels_screen.dart'
    as _i4;
import 'package:wakili/features/overview/presentation/pages/overview_screen.dart'
    as _i6;
import 'package:wakili/main_screen.dart' as _i5;
import 'package:flutter/material.dart' as _i8;

/// generated route for
/// [_i1.AccountScreen]
class AccountRoute extends _i7.PageRouteInfo<void> {
  const AccountRoute({List<_i7.PageRouteInfo>? children})
      : super(
          AccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'AccountRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.AccountScreen();
    },
  );
}

/// generated route for
/// [_i2.FavouritesScreen]
class FavouritesRoute extends _i7.PageRouteInfo<void> {
  const FavouritesRoute({List<_i7.PageRouteInfo>? children})
      : super(
          FavouritesRoute.name,
          initialChildren: children,
        );

  static const String name = 'FavouritesRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.FavouritesScreen();
    },
  );
}

/// generated route for
/// [_i3.FullImageScreen]
class FullImageRoute extends _i7.PageRouteInfo<FullImageRouteArgs> {
  FullImageRoute({
    _i8.Key? key,
    required _i3.FullImageViewArgs args,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          FullImageRoute.name,
          args: FullImageRouteArgs(
            key: key,
            args: args,
          ),
          initialChildren: children,
        );

  static const String name = 'FullImageRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FullImageRouteArgs>();
      return _i3.FullImageScreen(
        key: args.key,
        args: args.args,
      );
    },
  );
}

class FullImageRouteArgs {
  const FullImageRouteArgs({
    this.key,
    required this.args,
  });

  final _i8.Key? key;

  final _i3.FullImageViewArgs args;

  @override
  String toString() {
    return 'FullImageRouteArgs{key: $key, args: $args}';
  }
}

/// generated route for
/// [_i4.HotelsScreen]
class HotelsRoute extends _i7.PageRouteInfo<void> {
  const HotelsRoute({List<_i7.PageRouteInfo>? children})
      : super(
          HotelsRoute.name,
          initialChildren: children,
        );

  static const String name = 'HotelsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.HotelsScreen();
    },
  );
}

/// generated route for
/// [_i5.MainScreen]
class MainRoute extends _i7.PageRouteInfo<void> {
  const MainRoute({List<_i7.PageRouteInfo>? children})
      : super(
          MainRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.MainScreen();
    },
  );
}

/// generated route for
/// [_i6.OverviewScreen]
class OverviewRoute extends _i7.PageRouteInfo<void> {
  const OverviewRoute({List<_i7.PageRouteInfo>? children})
      : super(
          OverviewRoute.name,
          initialChildren: children,
        );

  static const String name = 'OverviewRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.OverviewScreen();
    },
  );
}
