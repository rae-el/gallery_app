import 'package:gallery_app/services/auth_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import '../services/gallery_service.dart';
import '../services/user_service.dart';
import '../ui/home/home_view.dart';
import '../ui/image/image_view.dart';
import '../ui/startup/startup_view.dart';
import '../ui/auth/auth_view.dart';
import '../ui/profile/profile_view.dart';

@StackedApp(routes: [
  MaterialRoute(page: StartupView, initial: true),
  MaterialRoute(page: HomeView),
  MaterialRoute(page: AuthView),
  MaterialRoute(page: ProfileView),
  MaterialRoute(page: ImageView),
], dependencies: [
  LazySingleton(classType: AuthenticationService),
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: UserService),
  LazySingleton(classType: GalleryService),
  LazySingleton(classType: DialogService),
])
class AppSetup {}
