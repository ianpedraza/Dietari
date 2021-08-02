import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dietari/utils/colors.dart';
import 'package:dietari/utils/icons.dart';

class LinkComponent extends StatelessWidget {
  final Function() onPressed;
  final Widget? child;
  final String textLink;

  const LinkComponent({Key? key, required this.onPressed, this.child, required this.textLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColorLinkComponent,
      elevation: 0,
      isExtended: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                textLink,
                style: TextStyle(
                    color: colorBlack,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20,right: 25),
            child: Transform.scale(
              scale: 1.6,
              child: getIcon(AppIcons.open,color: colorBlack) ,
              alignment: Alignment.center,
            ),
          ),
        ],
      ),
    );
  }

}