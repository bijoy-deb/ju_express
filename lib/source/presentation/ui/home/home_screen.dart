import 'dart:convert';
import 'dart:math';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ju_express/config/app_config.dart';
import 'package:ju_express/source/utils/app_color.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:open_file/open_file.dart';

import '../../../utils/global.dart';
import '../../../utils/helper_functions.dart';
import '../../../utils/notification_service.dart';
import '../download_ticket/download_ticket_screen.dart';
import '../more/more_screen.dart';
import '../profile/widget/profile_tab_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  DateTime preBackPress = DateTime.now();
  static List<Widget> _pages = <Widget>[];
  late final NotificationService notificationService;
  void listenToNotificationStream() =>
      notificationService.behaviorSubject.listen((data) async {
        dynamic payload = jsonDecode(data);
        if (payload['path'] != null) {
          bool? granted = await handleStoragePermission();
          if (granted == null) {
            showPermissionDialog(context);
          } else if (granted == false) {
            showToast(AppLocalizations.of(context)!.storage_permission);
          } else {
            print(payload['path']);
            OpenFile.open(payload['path']);
          }
        }
      });

  late final FirebaseMessaging _messaging;

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        dynamic payload = message.data;
        if (payload['title'] != null && payload['body'] != null) {
          final NotificationService notificationService = NotificationService();
          notificationService.initializePlatformNotifications();
          await notificationService.showLocalNotification(
            id: Random().nextInt(1000),
            title: payload['title'],
            body: payload['body'],
            data: jsonEncode(payload),
          );
        }
      });
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("notification tapped");
  }

  @override
  void initState() {
    notificationService = NotificationService();
    listenToNotificationStream();
    registerNotification();
    setupInteractedMessage();
    _pages = const <Widget>[
      SearchScreen(),
      DownloadTicketScreen(),
      ProfileTabScreen(),
      MoreScreen()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Globals.context = context;
    return WillPopScope(
      onWillPop: () async {
        final timeGap = DateTime.now().difference(preBackPress);
        final cantExit = timeGap >= const Duration(seconds: 2);
        preBackPress = DateTime.now();
        if (cantExit) {
          Fluttertoast.cancel();
          showToast(AppLocalizations.of(context)!.press_back, error: true);
          return false;
        } else {
          return true;
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.backgroundColor.parseColor(),
              body: _pages[_selectedIndex],
              bottomNavigationBar: Container(
                padding: EdgeInsets.only(bottom: 5),
                color: AppColors.primaryColor.parseColor(),
                child: ConvexAppBar(
                  height: 50,
                  elevation: 0,
                  color: Colors.white,
                  activeColor: Colors.white,
                  style: TabStyle.react,
                  top: -18,
                  backgroundColor: AppColors.primaryColor.parseColor(),
                  items: [
                    TabItem(
                        icon: Icons.manage_search_rounded,
                        title: AppLocalizations.of(context)!.search),
                    TabItem(
                        icon: Icons.file_download_rounded,
                        title: AppLocalizations.of(context)!.download),
                    TabItem(
                        icon: Icons.person,
                        title: AppLocalizations.of(context)!.profile),
                    TabItem(
                      icon: Icons.menu_rounded,
                      title: AppLocalizations.of(context)!.more,
                    ),
                  ],
                  onTap: (int i) {
                    _selectedIndex = i;
                    setState(() {});
                  },
                ),
              ),
            ),
            Visibility(
              visible: AppConfig.shared.env?.url.contains("beta") ?? false,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.only(top: 80, right: 50),
                  child: const Banner(
                    message: "Beta",
                    location: BannerLocation.bottomStart,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
