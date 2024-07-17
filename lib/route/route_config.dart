import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/src/data/local/app_shared_preferences.dart';
import 'package:ju_express/src/presentation/ui/init_screen.dart';

import '../src/presentation/ui/splash_screen.dart';

@singleton
class AppRoute {
  final AppSharedPreferences appSharedPreferences;
  AppRoute(this.appSharedPreferences);
  late final _router = GoRouter(
    initialLocation: '/',
    routes: [
      // GoRoute(
      //   name: 'splash',
      //   path: RoutePath.splash,
      //   builder: (context, state) => const SplashScreen(),
      // ),
      GoRoute(
        name: 'init',
        path: RoutePath.initPage,
        builder: (context, state) => const InitScreen(),
      ),
      // GoRoute(
      //   name: 'home',
      //   path: RoutePath.home,
      //   builder: (context, state) => const HomeScreen(),
      // ),
      // GoRoute(
      //   name: 'departure_list',
      //   path: RoutePath.departureList,
      //   builder: (context, state) => DepartureListScreen(
      //     searchArgs: state.extra as DepartureSearchArgs,
      //   ),
      // ),
      // GoRoute(
      //   name: 'static_content',
      //   path: RoutePath.staticContent,
      //   builder: (context, state) => StaticContentScreen(
      //     contentKey: state.extra as String,
      //   ),
      // ),
      // GoRoute(
      //   name: 'contact_us',
      //   path: RoutePath.contactUs,
      //   builder: (context, state) => const ContactUsScreen(),
      // ),
      // GoRoute(
      //   name: 'help_support',
      //   path: RoutePath.helpAndSupport,
      //   builder: (context, state) => const HelpSupportScreen(),
      // ),
      // GoRoute(
      //   name: 'language',
      //   path: RoutePath.language,
      //   builder: (context, state) => const LanguageScreen(),
      // ),
      // GoRoute(
      //   name: 'init_lang',
      //   path: RoutePath.initLang,
      //   builder: (context, state) => const InitLangScreen(),
      // ),
      // GoRoute(
      //     name: 'departure_details',
      //     path: RoutePath.departureDetails,
      //     builder: (context, state) {
      //       Map<String, dynamic> args = state.extra as Map<String, dynamic>;
      //       return DepartureDetailsScreen(
      //         searchArgs: args['search'],
      //         departure: args['departure'],
      //         idTypes: args['idTypes'],
      //         crSymbol: args["crSymbol"],
      //       );
      //     }),
      // GoRoute(
      //   name: 'district_list',
      //   path: RoutePath.districtList,
      //   builder: (context, state) => DistrictListScreen(
      //     from: state.extra as String?,
      //   ),
      // ),
      // GoRoute(
      //   name: 'select_boarding_dropping',
      //   path: RoutePath.selectBoardingDropping,
      //   builder: (context, state) {
      //     Map args = state.extra as Map;
      //     return SelectBoardingDropping(
      //       stoppage: args['stoppage'],
      //       dropping: args['dropping'],
      //     );
      //   },
      // ),
      // GoRoute(
      //   name: 'passenger_info',
      //   path: RoutePath.passengerInfo,
      //   builder: (context, state) {
      //     return PassengerInfoScreen(
      //       infoArgs: state.extra as PassengerInfoArgs,
      //     );
      //   },
      // ),
      // GoRoute(
      //   name: 'payment_confirm',
      //   path: RoutePath.paymentConfirm,
      //   builder: (context, state) {
      //     return PaymentConfirmScreen(
      //       details: state.extra as TripDetailsPayment,
      //     );
      //   },
      // ),
      // GoRoute(
      //   name: 'ticket_details',
      //   path: RoutePath.ticketDetails,
      //   builder: (context, state) {
      //     return TicketDetailsScreen(
      //       data: state.extra as DownloadTicketRes,
      //     );
      //   },
      // ),
    ],
  );

  GoRouter get router => _router;
}

class RoutePath {
  static const String splash = "/splash";
  static const String home = "/home";
  static const String staticContent = "/static_content";
  static const String departureList = "/departure_list";
  static const String departureDetails = "/departure_details";
  static const String districtList = "/district_list";
  static const String selectBoardingDropping = "/select_boarding_dropping";
  static const String passengerInfo = "/passenger_info";
  static const String contactUs = "/contact_us";
  static const String helpAndSupport = "/help_support";
  static const String language = "/language";
  static const String intro = "/intro";
  static const String initPage = "/";
  static const String paymentConfirm = "/payment_confirm";
  static const String ticketDetails = "/ticket_details";
}
