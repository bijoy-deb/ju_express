import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OTPSelectionDialog extends StatefulWidget {
  const OTPSelectionDialog(
      {Key? key,
      required this.phn,
      required this.email,
      required this.type,
      required this.code})
      : super(key: key);
  final String phn;
  final String email;
  final String code;
  final Function(int) type;

  @override
  State<OTPSelectionDialog> createState() => _OTPSelectionDialogState();
}

class _OTPSelectionDialogState extends State<OTPSelectionDialog> {
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _value = 1;
              widget.type(1);
            });
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio(
                visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                value: 1,
                groupValue: _value,
                onChanged: (value) {
                  setState(() {
                    _value = 1;
                    widget.type(1);
                  });
                },
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.text_message,
                    ),
                    Text(
                      "${widget.code}${widget.phn}",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Visibility(
          visible: widget.email.isNotEmpty,
          child: InkWell(
            onTap: () {
              setState(() {
                _value = 2;
                widget.type(2);
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Radio(
                  visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: 2,
                  groupValue: _value,
                  onChanged: (value) {
                    setState(() {
                      _value = 2;
                      widget.type(2);
                    });
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.email),
                      Wrap(
                        children: [
                          Text(
                            widget.email,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
