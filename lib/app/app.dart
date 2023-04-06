import 'package:gallery_app/services/auth_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import '../services/gallery_service.dart';
import '../services/image_service.dart';
import '../services/user_service.dart';
import '../services/validation_service.dart';
import '../ui/change_pw/change_pw_view.dart';
import '../ui/gallery/gallery_view.dart';
import '../ui/image/image_view.dart';
import '../ui/startup/startup_view.dart';
import '../ui/auth/auth_view.dart';
import '../ui/profile/profile_view.dart';
import '../ui/forgot_pw/forgot_pw_view.dart';

@StackedApp(logger: StackedLogger(), routes: [
  MaterialRoute(page: StartupView, initial: true),
  MaterialRoute(page: GalleryView),
  MaterialRoute(page: AuthView),
  MaterialRoute(page: ProfileView),
  //how do I make this a subpage
  MaterialRoute(page: ChangePwView),
  MaterialRoute(page: ImageView),
  MaterialRoute(page: ForgotPwView),
], dependencies: [
  LazySingleton(classType: AuthenticationService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: UserService),
  LazySingleton(classType: GalleryService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: ImageService),
  LazySingleton(classType: ValidationService),
])
class AppSetup {}
