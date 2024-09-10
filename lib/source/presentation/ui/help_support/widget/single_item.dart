import 'package:flutter/material.dart';

class SingleItem extends StatefulWidget {
  const SingleItem(
      {Key? key, required this.callback, required this.title, this.prefixIcon})
      : super(key: key);
  final Function()? callback;
  final String title;
  final Icon? prefixIcon;

  @override
  State<SingleItem> createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        decoration: const BoxDecoration(),
        child: Material(
          child: InkWell(
            onTap: widget.callback != null
                ? () {
                    widget.callback!();
                  }
                : null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (widget.prefixIcon != null)
                      Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: widget.prefixIcon!),
                    const SizedBox(
                      width: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.title,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
