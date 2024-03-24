import 'package:flutter/material.dart';
import 'package:husmerk_vpn/main.dart';
class CustomWidget extends StatelessWidget {

  final String titleText;
  final String subTitleText;
  final Widget roundWidgetWithIcon;
   const CustomWidget({super.key,
     required this.titleText,
     required this.subTitleText,
     required this.roundWidgetWithIcon

   });

  @override
  Widget build(BuildContext context) {
    sizeScreen = MediaQuery.of(context).size;
    return SizedBox(
      width: sizeScreen.width * .46,
      child: Column(
        children: [
          roundWidgetWithIcon,
          const SizedBox(
            height: 7,
          ),
          Text(
            titleText,
            style: const TextStyle(
                fontSize: 16,
              fontWeight: FontWeight.w600,

            ),
          ),

          const SizedBox(
            height: 7,
          ),
          Text(
            subTitleText,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,

            ),
          ),

        ],
      ),
    );
  }
}
