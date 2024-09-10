import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ju_express/source/utils/custom_extensions.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../di/injection.dart';
import '../../utils/app_color.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
    this.title,
    this.trailing = const [],
    this.onSearch,
    this.leading,
  }) : super(key: key);
  final String? title;
  final List<Widget> trailing;
  final void Function(String)? onSearch;
  final Widget? leading;
  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _MyAppBarState extends State<MyAppBar> {
  bool isSearchExpanded = false;
  List<Widget> trailing = [];

  @override
  void initState() {
    trailing.addAll(widget.trailing);
    if (widget.onSearch != null) {
      trailing.insert(
          0,
          IconButton(
            onPressed: () {
              setState(() {
                isSearchExpanded = !isSearchExpanded;
              });
            },
            icon: const Icon(Icons.search),
          ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: widget.leading ??
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
      backgroundColor: AppColors.primaryColor.parseColor(),
      automaticallyImplyLeading: false,
      title: isSearchExpanded
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                autofocus: true,
                cursorColor: Colors.white,
                scrollPadding: const EdgeInsets.all(6),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search,
                  hintStyle:
                      TextStyle(color: AppColors.headerTextColor.parseColor()),
                  border: InputBorder.none,
                ),
                style: TextStyle(color: AppColors.headerTextColor.parseColor()),
                onChanged: (value) {
                  widget.onSearch!(value);
                },
              ),
            )
          : widget.title != null
              ? Text(
                  widget.title!,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.title!.length > 17 ? 20 : 22,
                      fontWeight: FontWeight.w700),
                )
              : Text(
                  getIt<PackageInfo>().appName,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700),
                ),
      elevation: 10,
      actions: isSearchExpanded
          ? [
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.onSearch!("");
                      isSearchExpanded = !isSearchExpanded;
                    });
                  },
                  icon: const Icon(Icons.cancel))
            ]
          : trailing,
    );
  }
}
