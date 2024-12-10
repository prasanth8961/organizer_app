import 'package:get/get_connect/connect.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:organizer_app/Screens/Auth/login_screen.dart';
import 'package:organizer_app/Screens/main_screen.dart';
import 'package:organizer_app/Screens/Auth/signup_screen.dart';

class PageRoutes extends GetConnect {
  static const String loginscreen = "/loginScreen";
  static const String signupscreen = "/signupScreen";
  static const String createEvent = "/createEvent";
  static const String subEvent = "/subEvent";
  static const String bottomNav = "/bottom_navigation";
  static const String mainScreen = "/main_screen";
  static const String dashboard = "/dashboard";
  static const String eventlist = "/eventlist";
  static const String eventDetail = "/event_details";
  static const String videoPlayer = "/video_player";

  static List<GetPage> routes = [
    GetPage(name: loginscreen, page: () => const LoginScreen()),
    GetPage(name: signupscreen, page: () => const SignupScreen()),
    GetPage(name: mainScreen, page: () => const MainScreen()),
  ];
}
