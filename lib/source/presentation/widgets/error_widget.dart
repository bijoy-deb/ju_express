import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/error/error_message.dart';
import '../../utils/app_images.dart';

class CustomErrorWidget extends StatefulWidget {
  const CustomErrorWidget(
      {Key? key, this.btnText, required this.errorMessage, this.onRetry})
      : super(key: key);
  final ErrorMessage errorMessage;
  final Function? onRetry;
  final String? btnText;
  @override
  State<CustomErrorWidget> createState() => _CustomErrorWidgetState();
}

class _CustomErrorWidgetState extends State<CustomErrorWidget> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print("Error Type: ${widget.errorMessage.errorType}");
      print("Error Message: ${widget.errorMessage.message}");
    }
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Builder(
        builder: (context) {
          if (widget.errorMessage.errorType == ErrorType.ERROR_WITH_MESSAGE) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.somethingWentWrong,
                  width: 250,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    widget.errorMessage.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (widget.onRetry != null)
                  ElevatedButton(
                    onPressed: () {
                      widget.onRetry!();
                    },
                    child: widget.btnText != null
                        ? Text(widget.btnText!)
                        : Text(AppLocalizations.of(context)!.retry),
                  ),
              ],
            );
          } else if (widget.errorMessage.errorType == ErrorType.NO_INTERNET) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(AppImages.noInternet, width: 250),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.no_internet,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.no_internet_sub,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (widget.onRetry != null)
                  ElevatedButton(
                    onPressed: () {
                      widget.onRetry!();
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
              ],
            );
          } else if (widget.errorMessage.errorType == ErrorType.NO_DATA) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.emptyList,
                  width: 250,
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    widget.errorMessage.message.isEmpty
                        ? AppLocalizations.of(context)!.no_data
                        : widget.errorMessage.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                if (widget.errorMessage.subtitle.isNotEmpty)
                  const SizedBox(
                    height: 10,
                  ),
                if (widget.errorMessage.subtitle.isNotEmpty)
                  Text(
                    widget.errorMessage.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (widget.onRetry != null)
                  ElevatedButton(
                    onPressed: () {
                      widget.onRetry!();
                    },
                    child: Text(
                        widget.btnText ?? AppLocalizations.of(context)!.retry),
                  ),
              ],
            );
          } //timeout
          else if (widget.errorMessage.errorType == ErrorType.TIMEOUT) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.somethingWentWrong,
                  width: 250,
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.connection_timeout,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (widget.onRetry != null)
                  ElevatedButton(
                    onPressed: () {
                      widget.onRetry!();
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
              ],
            );
          } // something went wrong
          else if (widget.errorMessage.errorType == ErrorType.ERROR) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.somethingWentWrong,
                  width: 250,
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.something_went_wrong,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (widget.onRetry != null)
                  ElevatedButton(
                    onPressed: () {
                      widget.onRetry!();
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
              ],
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.somethingWentWrong,
                  width: 250,
                ),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.something_went_wrong,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                if (widget.onRetry != null)
                  ElevatedButton(
                    onPressed: () {
                      widget.onRetry!();
                    },
                    child: Text(AppLocalizations.of(context)!.retry),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}
