import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:ju_express/source/presentation/ui/payment/payment_confirm_screen.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../route/route_config.dart';
import '../../../utils/app_color.dart';
import '../../../utils/helper_functions.dart';
import '../../widgets/app_bar.dart';

class WebPaymentScreen extends StatefulWidget {
  const WebPaymentScreen(
      {Key? key, required this.url, required this.vuHash, required this.payID})
      : super(key: key);
  final String url;
  final String vuHash;
  final String payID;

  @override
  State<WebPaymentScreen> createState() => _WebPaymentScreenState();
}

class _WebPaymentScreenState extends State<WebPaymentScreen> {
  double _progress = 0.0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleBack(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor.parseColor(),
        appBar: MyAppBar(
          leading: IconButton(
            onPressed: () {
              handleBack(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: AppLocalizations.of(context)!.payment,
        ),
        body: Column(
          children: [
            if (_progress < 1)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: LinearProgressIndicator(
                  value: _progress,
                ),
              ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest:
                    URLRequest(url: WebUri(Uri.parse(widget.url).toString())),
                onConsoleMessage: (InAppWebViewController controller,
                    ConsoleMessage consoleMessage) {},
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    clearCache: false,
                    javaScriptCanOpenWindowsAutomatically: true,
                    mediaPlaybackRequiresUserGesture: true,
                  ),
                  android: AndroidInAppWebViewOptions(
                    supportMultipleWindows: true,
                    useHybridComposition: true,
                  ),
                  ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
                ),
                onProgressChanged: (controller, progress) {
                  _progress = progress / 100;
                  setState(() {});
                },
                onLoadStart: (controller, url) {
                  print("url -- $url");
                  if (url
                          .toString()
                          .toLowerCase()
                          .contains("payment-confirm") &&
                      url
                          .toString()
                          .toLowerCase()
                          .contains("cwticketingsystem.com")) {
                    Navigator.push(
                        context,
                        createRoute(PaymentConfirmScreen(
                            vuHash: widget.vuHash, payId: widget.payID)));
                  } else if (url.toString().toLowerCase().contains("error") &&
                      url
                          .toString()
                          .toLowerCase()
                          .contains("cwticketingsystem.com")) {
                    context.go(RoutePath.paymentFail);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  handleBack(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        AppLocalizations.of(context)!.cancel_payment,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.yes,
        textColor: Colors.black,
        backgroundColor: Colors.white,
        onPressed: () {
          context.go(RoutePath.home);
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
