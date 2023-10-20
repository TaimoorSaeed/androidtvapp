import 'package:androidtvapp/values/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 10),
      decoration: BoxDecoration(
        color: ConstantColors.secondMainColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search Channel",
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: 13,
                ),
              ),
              style: TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ConstantColors.whiteColor,
              borderRadius: BorderRadius.circular(100),
            ),
            height: 30,
            width: 30,
            child: const Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 17,
              color: ConstantColors.secondMainColor,
            ),
          )
        ],
      ),
    );
  }
}
