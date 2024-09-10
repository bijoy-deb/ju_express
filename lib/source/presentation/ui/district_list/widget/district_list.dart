import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:ju_express/source/presentation/bloc/district_list/district_list_bloc.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';

import '../../../../../core/error/error_message.dart';
import '../../../../data/model/common/district.dart';
import '../../../../utils/app_color.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/error_widget.dart';

class DistrictList extends StatefulWidget {
  const DistrictList({required this.from, required this.districts, Key? key})
      : super(key: key);
  final String? from;
  final List<District> districts;
  @override
  State<DistrictList> createState() => _DistrictListState();
}

class _DistrictListState extends State<DistrictList> {
  ScrollController scrollController = ScrollController();
  List<District> districts = [];

  @override
  void initState() {
    districts.addAll(widget.districts);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor.parseColor(),
        appBar: MyAppBar(
          title: widget.from == null
              ? AppLocalizations.of(context)!.select_from_city
              : AppLocalizations.of(context)!.select_to_city,
          trailing: [
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: IconButton(
                onPressed: () {
                  context
                      .read<DistrictListBloc>()
                      .add(GetDistrictListData(fromApi: true));
                },
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 3,
            ),
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(width: .5),
                        borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(width: .5),
                        borderRadius: BorderRadius.circular(8)),
                    hintText: AppLocalizations.of(context)!.search,
                    prefixIcon: const Icon(Icons.search),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    fillColor: Colors.white,
                    filled: true),
                onChanged: (p0) {
                  if (p0.isEmpty) {
                    setState(() {
                      districts.clear();
                      districts.addAll(widget.districts);
                    });
                  } else {
                    setState(() {
                      districts.clear();
                      districts.addAll(widget.districts.where((element) =>
                          element.distTitle!
                              .toLowerCase()
                              .contains(p0.toLowerCase()) ||
                          element.distId!
                              .toLowerCase()
                              .contains(p0.toLowerCase())));
                    });
                  }
                },
              ),
            ),
            districts.isNotEmpty
                ? Expanded(
                    child: Scrollbar(
                      controller: scrollController,
                      interactive: true,
                      thumbVisibility: true,
                      thickness: 4,
                      radius: const Radius.circular(6),
                      child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.only(
                              top: 8, right: 8, left: 8, bottom: 8),
                          itemCount: districts.length,
                          itemBuilder: (context, i) => Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(
                                        context, districts.elementAt(i));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: AppColors.primaryColor
                                              .parseColor(),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          districts[i].distTitle!,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const Spacer(),
                                        Icon(
                                          Icons.arrow_forward_ios_outlined,
                                          size: 20,
                                          color: AppColors.primaryColor
                                              .parseColor(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: CustomErrorWidget(
                        errorMessage: ErrorMessage(
                          message: AppLocalizations.of(context)!.no_city,
                          errorType: ErrorType.NO_DATA,
                        ),
                      ),
                    ),
                  ),
          ],
        ));
  }
}
