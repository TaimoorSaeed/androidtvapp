import 'package:androidtvapp/values/constant_colors.dart';
import 'package:flutter/material.dart';

class SideBarCardWidget extends StatelessWidget {
  const SideBarCardWidget({
    super.key,
    required this.thumbnail,
    required this.name,
    required this.onTap,
  });

  final void Function() onTap;
  final String thumbnail;
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(
          thumbnail,
        ),
      ),
      subtitle: const Text(
        "Entertainment",
        style: TextStyle(
          color: ConstantColors.secondMainColor,
          fontSize: 12,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: ConstantColors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}
