import 'package:fact_fuel/helper/colors.dart';
import 'package:fact_fuel/widgets/my_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:glass_kit/glass_kit.dart';
import '../helper/custom_text_style.dart';
import '../helper/fact_utils.dart';
import '../helper/my_dialogs.dart';

class CategoriesFactCard extends StatefulWidget {
  final String fact;
  const CategoriesFactCard({super.key, required this.fact});

  @override
  State<CategoriesFactCard> createState() => _CategoriesFactCardState();
}

class _CategoriesFactCardState extends State<CategoriesFactCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: GlassContainer(
        height: size.height * 0.2,
        gradient: LinearGradient(
          colors: [Colors.black.withAlpha(80), Colors.black.withAlpha(10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderGradient: LinearGradient(
          colors: [
            AppColors.primary.withAlpha(60),
            AppColors.primaryDark.withAlpha(40),
            AppColors.primary.withAlpha(40),
            AppColors.primaryDark.withAlpha(80),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.39, 0.40, 1.0],
        ),
        borderRadius: BorderRadius.circular(12),
        blur: 12.0,
        borderWidth: 1.5,
        elevation: 3.0,
        isFrostedGlass: false,
        shadowColor: Colors.black.withAlpha(40),
        alignment: Alignment.center,
        frostedOpacity: 0.19,

        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.fact,
                style: myTextStyle16(textColor: Colors.white70),
              ),
              SizedBox(height: size.height * 0.01),

              Divider(color: Colors.white10, thickness: 2),
              SizedBox(height: size.height * 0.01),

              /// fav button
              /// ---> add to fav button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FactUtils.favoriteStatusStream(widget.fact),
                    builder: (context, favSnapshot) {
                      bool isSaved = favSnapshot.data?.exists ?? false;

                      /// save to favorites
                      return MyIconButton(
                        icon:
                            isSaved
                                ? CupertinoIcons.heart_fill
                                : CupertinoIcons.heart,
                        iconColor:
                            isSaved ? Colors.red : AppColors.iconSecondary,

                        onTap:
                            () =>
                                FactUtils.toggleFavorite(widget.fact, isSaved),
                      );
                    },
                  ),

                  /// Copy icon with onTap to copy the text
                  MyIconButton(
                    icon: Icons.copy_rounded,
                    iconColor: AppColors.iconSecondary,
                    onTap: () {
                      FactUtils.copyToClipboard(widget.fact).then((_) {
                        MyDialogs.myShowSnackBar(
                          context,
                          "Copied to clipboard",
                          AppColors.success,
                          AppColors.textPrimary,
                        );
                      });
                    },
                  ),

                  MyIconButton(
                    icon: Icons.share_rounded,
                    iconColor: AppColors.iconSecondary,
                    onTap: () {
                      FactUtils.shareFact(context, widget.fact);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
