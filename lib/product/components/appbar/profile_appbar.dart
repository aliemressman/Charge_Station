import 'package:evry_app/product/constants/colors.dart';
import 'package:flutter/material.dart';

class ProfileAppbar extends StatefulWidget {
  final String title;
  const ProfileAppbar({super.key, required this.title});

  @override
  State<ProfileAppbar> createState() => _ProfileAppbarState();
}

class _ProfileAppbarState extends State<ProfileAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.whiteColor),
      backgroundColor: AppColors.greyColor,
      title: Text(
        widget.title,
        style: TextStyle(
          color: AppColors.whiteColor,
          letterSpacing: 1.0,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
