import 'package:gallery_app/services/auth_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import '../ui/home/home_view.dart';
import '../ui/startup/startup_view.dart';

@StackedApp(routes: [
  MaterialRoute(page: StartupView, initial: true),
  MaterialRoute(page: HomeView),
], dependencies: [
  LazySingleton(classType: AuthenticationService),
  Singleton(classType: NavigationService),
])
class AppSetup {}
