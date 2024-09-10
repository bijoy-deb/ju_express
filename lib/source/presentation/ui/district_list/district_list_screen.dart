import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ju_express/source/presentation/ui/district_list/widget/district_list.dart';
import 'package:ju_express/source/presentation/widgets/app_bar.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../core/error/error_message.dart';

import '../../../../di/injection.dart';
import '../../../utils/app_color.dart';
import '../../bloc/district_list/district_list_bloc.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/shimmer_effect.dart';

class DistrictListScreen extends StatefulWidget {
  const DistrictListScreen({this.from, Key? key}) : super(key: key);
  final String? from;
  @override
  State<DistrictListScreen> createState() => _DistrictListScreenState();
}

class _DistrictListScreenState extends State<DistrictListScreen> {
  final bloc = getIt<DistrictListBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc
        ..add(widget.from == null
            ? GetDistrictListData()
            : GetFromWiseToData(from: widget.from!)),
      child: BlocBuilder<DistrictListBloc, DistrictListState>(
        builder: (context, state) {
          if (state is DistrictListLoading) {
            return Scaffold(
              backgroundColor: AppColors.backgroundColor.parseColor(),
              appBar: MyAppBar(
                title: widget.from == null
                    ? AppLocalizations.of(context)!.select_from_city
                    : AppLocalizations.of(context)!.select_to_city,
              ),
              body: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ListShimmer(
                  length: 15,
                  height: 50,
                ),
              ),
            );
          } else if (state is DistrictListLoaded) {
            if (state.res.status == 1) {
              if (state.res.districts == null || state.res.districts!.isEmpty) {
                return Scaffold(
                  backgroundColor: AppColors.backgroundColor.parseColor(),
                  appBar: MyAppBar(
                    title: widget.from == null
                        ? AppLocalizations.of(context)!.select_from_city
                        : AppLocalizations.of(context)!.select_to_city,
                  ),
                  body: Center(
                    child: CustomErrorWidget(
                      errorMessage: ErrorMessage(
                          errorType: ErrorType.NO_DATA,
                          subtitle: AppLocalizations.of(context)!.no_city),
                      onRetry: () {
                        bloc.add(widget.from == null
                            ? GetDistrictListData(fromApi: true)
                            : GetFromWiseToData(from: widget.from!));
                      },
                    ),
                  ),
                );
              } else {
                return DistrictList(
                  from: widget.from,
                  districts: state.res.districts!,
                );
              }
            } else {
              return Scaffold(
                backgroundColor: AppColors.backgroundColor.parseColor(),
                appBar: MyAppBar(
                  title: widget.from == null
                      ? AppLocalizations.of(context)!.select_from_city
                      : AppLocalizations.of(context)!.select_to_city,
                ),
                body: Center(
                  child: CustomErrorWidget(
                    errorMessage: ErrorMessage.getErrorFromMsg(state.res.m),
                    onRetry: () {
                      bloc.add(widget.from == null
                          ? GetDistrictListData(fromApi: true)
                          : GetFromWiseToData(from: widget.from!));
                    },
                  ),
                ),
              );
            }
          } else if (state is DistrictListError) {
            return Scaffold(
              backgroundColor: AppColors.backgroundColor.parseColor(),
              appBar: MyAppBar(
                title: widget.from == null
                    ? AppLocalizations.of(context)!.select_from_city
                    : AppLocalizations.of(context)!.select_to_city,
              ),
              body: Center(
                child: CustomErrorWidget(
                  errorMessage: state.error,
                  onRetry: () {
                    bloc.add(widget.from == null
                        ? GetDistrictListData(fromApi: true)
                        : GetFromWiseToData(from: widget.from!));
                  },
                ),
              ),
            );
          } else {
            return Scaffold(
                backgroundColor: AppColors.backgroundColor.parseColor(),
                appBar: MyAppBar(
                  title: widget.from == null
                      ? AppLocalizations.of(context)!.select_from_city
                      : AppLocalizations.of(context)!.select_to_city,
                ),
                body: const SizedBox.shrink());
          }
        },
      ),
    );
  }
}
