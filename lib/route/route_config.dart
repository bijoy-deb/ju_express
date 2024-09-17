import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:ju_express/source/data/local/app_shared_preferences.dart';
import 'package:ju_express/source/data/model/departure_details/departure_search_args.dart';
import 'package:ju_express/source/data/model/download_ticket/download_ticket_res.dart';
import 'package:ju_express/source/data/model/passenger_info/passenger_info_args.dart';

import '../source/data/model/passenger_info/ticket_sale_res.dart';
import '../source/presentation/ui/boarding_dropping/select_boarding_dropping.dart';
import '../source/presentation/ui/booking_history/booking_history_screen.dart';
import '../source/presentation/ui/change_number/change_number_screen.dart';
import '../source/presentation/ui/contact_us/contact_us_screen.dart';
import '../source/presentation/ui/departure_details/depature_details_screen.dart';
import '../source/presentation/ui/departure_list/departure_list_screen.dart';
import '../source/presentation/ui/district_list/district_list_screen.dart';
import '../source/presentation/ui/forgot_password/forgot_password_screen.dart';
import '../source/presentation/ui/help_support/help_support_screen.dart';
import '../source/presentation/ui/home/home_screen.dart';
import '../source/presentation/ui/language/language_screen.dart';
import '../source/presentation/ui/on_board/on_board.dart';
import '../source/presentation/ui/passenger_info/passenger_info_screen.dart';
import '../source/presentation/ui/payment/payment_failed.dart';
import '../source/presentation/ui/payment/payment_selection_screen.dart';
import '../source/presentation/ui/profile/profile_screen.dart';
import '../source/presentation/ui/profile/widget/change_mail_screen.dart';
import '../source/presentation/ui/sign_in/sign_in_screen.dart';
import '../source/presentation/ui/sign_up/sign_up_screen.dart';
import '../source/presentation/ui/splash_screen.dart';
import '../source/presentation/ui/static_content/static_content_screen.dart';
import '../source/presentation/ui/ticket_detail_screen/ticket_detail_screen.dart';
import '../source/utils/helper_functions.dart';

@singleton
class AppRoute {
  final AppSharedPrefs appSharedPreferences;
  AppRoute(this.appSharedPreferences);
  late final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        name: 'splash',
        path: RoutePath.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: 'home',
        path: RoutePath.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: 'departure_list',
        path: RoutePath.departureList,
        builder: (context, state) => DepartureListScreen(
          searchArgs: state.extra as DepartureSearchArgs,
        ),
      ),
      GoRoute(
        name: 'static_content',
        path: RoutePath.staticContent,
        builder: (context, state) => StaticContentScreen(
          contentKey: state.extra as String,
        ),
      ),
      GoRoute(
        name: 'contact_us',
        path: RoutePath.contactUs,
        builder: (context, state) => const ContactUsScreen(),
      ),
      GoRoute(
        name: 'help_support',
        path: RoutePath.helpAndSupport,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        name: 'language',
        path: RoutePath.language,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
          name: 'departure_details',
          path: RoutePath.departureDetails,
          builder: (context, state) {
            Map<String, dynamic> args = state.extra as Map<String, dynamic>;
            return DepartureDetailsScreen(
              searchArgs: args['search'],
              departure: args['departure'],
              idTypes: args['idTypes'],
              crSymbol: args["crSymbol"],
            );
          }),
      GoRoute(
        name: 'district_list',
        path: RoutePath.districtList,
        builder: (context, state) => DistrictListScreen(
          from: state.extra as String?,
        ),
      ),
      GoRoute(
        name: 'select_boarding_dropping',
        path: RoutePath.selectBoardingDropping,
        builder: (context, state) {
          Map args = state.extra as Map;
          return SelectBoardingDropping(
            stoppage: args['stoppage'],
            dropping: args['dropping'],
          );
        },
      ),
      GoRoute(
        name: 'passenger_info',
        path: RoutePath.passengerInfo,
        builder: (context, state) {
          return PassengerInfoScreen(
            infoArgs: state.extra as PassengerInfoArgs,
          );
        },
      ),
      GoRoute(
        name: 'ticket_details',
        path: RoutePath.ticketDetails,
        builder: (context, state) {
          return TicketDetailsScreen(
            data: state.extra as DownloadTicketRes,
          );
        },
      ),
      GoRoute(
        name: 'sign_in',
        path: RoutePath.signIn,
        pageBuilder: (context, state) => createRoutePage(
            pageKey: state.pageKey, widget: const SignInScreen()),
      ),
      GoRoute(
        name: 'forgot_password',
        path: RoutePath.forgot_password,
        pageBuilder: (context, state) => createRoutePage(
            pageKey: state.pageKey, widget: ForgotPasswordScreen()),
      ),
      GoRoute(
        name: 'profile',
        path: RoutePath.profile,
        pageBuilder: (context, state) => createRoutePage(
            pageKey: state.pageKey, widget: const ProfileScreen()),
      ),
      GoRoute(
        name: 'change_number',
        path: RoutePath.change_number,
        pageBuilder: (context, state) => createRoutePage(
            pageKey: state.pageKey, widget: const ChangeNumberScreen()),
      ),
      GoRoute(
        name: 'change_mail',
        path: RoutePath.change_mail,
        pageBuilder: (context, state) => createRoutePage(
            pageKey: state.pageKey, widget: const ChangeMailScreen()),
      ),
      GoRoute(
        name: 'onBoard',
        path: RoutePath.onBoard,
        pageBuilder: (context, state) =>
            createRoutePage(pageKey: state.pageKey, widget: OnBoardScreen()),
      ),
      GoRoute(
        name: 'payment_fail',
        path: RoutePath.paymentFail,
        pageBuilder: (context, state) => createRoutePage(
            pageKey: state.pageKey,
            widget: PaymentFail(error: state.extra as String?)),
      ),
      GoRoute(
        name: 'paymentSelectionScreen',
        path: RoutePath.paymentSelectionScreen,
        pageBuilder: (context, state) => createRoutePage(
            pageKey: state.pageKey,
            widget:
                PaymentSelectionScreen(saleRes: state.extra as TicketSaleRes)),
      ),
      GoRoute(
        name: 'sign_up',
        path: RoutePath.signUp,
        pageBuilder: (context, state) => createRoutePage(
            pageKey: state.pageKey, widget: const SignUpScreen()),
      ),
      GoRoute(
        name: 'view_history',
        path: RoutePath.viewHistory,
        pageBuilder: (context, state) => createRoutePage(
            pageKey: state.pageKey, widget: const BookingHistoryScreen()),
      ),
    ],
  );

  GoRouter get router => _router;
}

class RoutePath {
  static const String splash = "/";
  static const String home = "/home";
  static const String onBoard = "/onBoard";
  static const String signIn = "/sign_in";
  static const String profile = "/profile";
  static const String viewHistory = "/view_history";
  static const String change_number = "/change_number";
  static const String signUp = "/sign_up";
  static const String change_mail = "/change_mail";
  static const String forgot_password = "/forgot_password";
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
  static const String paymentConfirm = "/payment_confirm";
  static const String ticketDetails = "/ticket_details";
  static const String paymentFail = "/payment_fail";
  static const String paymentSelectionScreen = "/paymentSelectionScreen";
}
