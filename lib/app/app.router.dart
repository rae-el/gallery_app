// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/foundation.dart' as _i8;
import 'package:flutter/material.dart';
import 'package:gallery_app/models/this_image.dart' as _i9;
import 'package:gallery_app/ui/auth/auth_view.dart' as _i4;
import 'package:gallery_app/ui/change_pw/change_pw_view.dart' as _i6;
import 'package:gallery_app/ui/gallery/gallery_view.dart' as _i3;
import 'package:gallery_app/ui/image/image_view.dart' as _i7;
import 'package:gallery_app/ui/profile/profile_view.dart' as _i5;
import 'package:gallery_app/ui/startup/startup_view.dart' as _i2;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i10;

class Routes {
  static const startupView = '/';

  static const galleryView = '/gallery-view';

  static const authView = '/auth-view';

  static const profileView = '/profile-view';

  static const changePwView = '/change-pw-view';

  static const imageView = '/image-view';

  static const all = <String>{
    startupView,
    galleryView,
    authView,
    profileView,
    changePwView,
    imageView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.startupView,
      page: _i2.StartupView,
    ),
    _i1.RouteDef(
      Routes.galleryView,
      page: _i3.GalleryView,
    ),
    _i1.RouteDef(
      Routes.authView,
      page: _i4.AuthView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i5.ProfileView,
    ),
    _i1.RouteDef(
      Routes.changePwView,
      page: _i6.ChangePwView,
    ),
    _i1.RouteDef(
      Routes.imageView,
      page: _i7.ImageView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.StartupView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.StartupView(),
        settings: data,
      );
    },
    _i3.GalleryView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.GalleryView(),
        settings: data,
      );
    },
    _i4.AuthView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.AuthView(),
        settings: data,
      );
    },
    _i5.ProfileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.ProfileView(),
        settings: data,
      );
    },
    _i6.ChangePwView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.ChangePwView(),
        settings: data,
      );
    },
    _i7.ImageView: (data) {
      final args = data.getArgs<ImageViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i7.ImageView(key: args.key, image: args.image),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;
  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class ImageViewArguments {
  const ImageViewArguments({
    this.key,
    required this.image,
  });

  final _i8.Key? key;

  final _i9.ThisImage image;
}

extension NavigatorStateExtension on _i10.NavigationService {
  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToGalleryView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.galleryView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAuthView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.authView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToChangePwView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.changePwView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToImageView({
    _i8.Key? key,
    required _i9.ThisImage image,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.imageView,
        arguments: ImageViewArguments(key: key, image: image),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
