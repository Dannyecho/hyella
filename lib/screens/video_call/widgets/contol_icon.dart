import 'package:flutter/material.dart';

class ControlIcon extends StatelessWidget {
  final Widget activeIcon;
  final Icon? inActiveIcon;
  final bool? value;
  final Color bgColor;
  final Function() onTap;
  const ControlIcon(
      {Key? key,
      required this.bgColor,
      this.inActiveIcon,
      this.value,
      required this.activeIcon,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return value == null
        ? GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
                radius: 28, backgroundColor: bgColor, child: activeIcon),
          )
        : GestureDetector(
                onTap: onTap,
                child: CircleAvatar(
                    radius: 28,
                    backgroundColor: bgColor,
                    child: value! ? activeIcon : inActiveIcon),
              );
  }
}
