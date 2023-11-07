import 'package:androidtvapp/values/constant_colors.dart';
import 'package:flutter/material.dart';

class SideBarCardWidget extends StatelessWidget {
  const SideBarCardWidget({
    super.key,
    required this.thumbnail,
    required this.name,
    required this.category,
    required this.onTap,
    required this.onFocusChange,
    required this.isFocus,
  });

  final void Function() onTap;
  final void Function(bool?) onFocusChange;
  final String thumbnail;
  final String name;
  final String category;
  final bool isFocus;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: ConstantColors.mainColor,
      focusColor: ConstantColors.secondMainColor,
      onFocusChange: onFocusChange,
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(
          thumbnail,
        ),
      ),
      subtitle: Text(
        category,
        style: TextStyle(
          color: isFocus
              ? ConstantColors.whiteColor
              : ConstantColors.secondMainColor,
          fontSize: 12,
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: isFocus ? ConstantColors.whiteColor : ConstantColors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
