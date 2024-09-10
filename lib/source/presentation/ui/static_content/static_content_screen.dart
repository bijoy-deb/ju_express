import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:ju_express/source/presentation/widgets/app_bar.dart';
import 'package:ju_express/source/presentation/widgets/shimmer_effect.dart';
import 'package:ju_express/source/utils/app_color.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/error/error_message.dart';

import '../../../../di/injection.dart';
import '../../../utils/helper_functions.dart';
import '../../bloc/static_content/static_content_bloc.dart';
import '../../widgets/error_widget.dart';

class StaticContentScreen extends StatefulWidget {
  const StaticContentScreen({required this.contentKey, Key? key})
      : super(key: key);
  final String contentKey;

  @override
  State<StaticContentScreen> createState() => _StaticContentScreenState();
}

class _StaticContentScreenState extends State<StaticContentScreen> {
  late String title;
  String content = "";
  final bloc = getIt<StaticContentsBloc>();
  @override
  void initState() {
    title = "";
    Future(() {
      title = getTitle(widget.contentKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc..add(GetStaticContentsData()),
      child: BlocBuilder<StaticContentsBloc, StaticContentsState>(
        builder: (context, state) {
          if (state is StaticContentsLoading) {
            return Scaffold(
                backgroundColor: AppColors.backgroundColor.parseColor(),
                appBar: MyAppBar(
                  title: title,
                ),
                body: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: ListShimmer(length: 1, height: 200),
                ));
          } else if (state is StaticContentsLoaded) {
            if (state.res.status == 1) {
              for (int i = 0; i < state.res.staticContent!.length; i++) {
                var item = state.res.staticContent!.elementAt(i);
                if (item.key == widget.contentKey) {
                  title = item.title!;
                  content = item.content!;
                  break;
                }
              }
              return Scaffold(
                backgroundColor: AppColors.backgroundColor.parseColor(),
                appBar: MyAppBar(
                  title: title,
                ),
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: wrapWithContainer(
                    child: SingleChildScrollView(
                      child: Html(
                        data: content,
                        onLinkTap: (String? url, __, ___) async {
                          if (url != null) {
                            Uri uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            } else {
                              showToast(AppLocalizations.of(context)!
                                  .something_went_wrong);
                            }
                          }
                        },
                        style: {
                          "a": Style(
                            textDecorationColor: HexColor('005aaa'),
                          ),
                        },
                      ),
                    ),
                  ),
                ),
              );
            } else {
              return Scaffold(
                  backgroundColor: AppColors.backgroundColor.parseColor(),
                  appBar: MyAppBar(
                    title: title,
                  ),
                  body: CustomErrorWidget(
                    errorMessage: ErrorMessage.getErrorFromMsg(state.res.m),
                    onRetry: () {
                      bloc.add(GetStaticContentsData());
                    },
                  ));
            }
          } else if (state is StaticContentsError) {
            return Scaffold(
                backgroundColor: AppColors.backgroundColor.parseColor(),
                appBar: MyAppBar(
                  title: title,
                ),
                body: CustomErrorWidget(
                  errorMessage: state.error,
                  onRetry: () {
                    bloc.add(GetStaticContentsData());
                  },
                ));
          }
          return Scaffold(
              backgroundColor: AppColors.backgroundColor.parseColor(),
              appBar: MyAppBar(
                title: title,
              ),
              body: const SizedBox.shrink());
        },
      ),
    );
  }

  getTitle(String key) {
    switch (key) {
      case 'termsAndConditions':
        return AppLocalizations.of(context)!.termsAndConditions;
      case 'aboutUs':
        return AppLocalizations.of(context)!.aboutUs;
      case 'refundPolicy':
        return AppLocalizations.of(context)!.refundPolicy;
      case 'cancellationPolicy':
        return AppLocalizations.of(context)!.cancellationPolicy;
      case 'privacyPolicy':
        return AppLocalizations.of(context)!.privacyPolicy;
    }
  }
}
