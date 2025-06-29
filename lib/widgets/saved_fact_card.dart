import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fact_fuel/helper/custom_text_style.dart';
import 'package:fact_fuel/helper/fact_utils.dart';
import 'package:fact_fuel/widgets/my_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../helper/colors.dart';
import '../helper/my_dialogs.dart';

class SavedFactCard extends StatelessWidget {
  final String fact;

  const SavedFactCard({super.key, required this.fact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                fact,
                style: myTextStyle16(textColor: AppColors.textSecondary),
              ),
              const SizedBox(height: 8),

              Divider(color: AppColors.iconSecondary.withValues(alpha: 0.1)),
              const SizedBox(height: 8),
              Row(
                children: [
                  MyIconButton(
                    icon: Icons.copy_rounded,
                    iconColor: AppColors.iconSecondary,
                    onTap: () {
                      FactUtils.copyToClipboard(fact).then((_) {
                        MyDialogs.myShowSnackBar(
                          context,
                          "Copied to clipboard",
                          AppColors.success,
                          AppColors.textPrimary,
                        );
                      });
                    },
                  ),
                  SizedBox(width: 8),

                  MyIconButton(
                    icon: Icons.share_rounded,
                    onTap: () {
                      FactUtils.shareFact(context, fact);
                    },
                    iconColor: AppColors.iconSecondary,
                  ),

                  const Spacer(),
                  Row(
                    children: [
                      /// like show
                      StreamBuilder<DocumentSnapshot>(
                        stream: FactUtils.favoriteStatusStream(fact),
                        builder: (context, snapshot) {
                          final isSaved = snapshot.data?.exists ?? false;
                          return MyIconButton(
                            icon:
                                isSaved
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                            iconColor:
                                isSaved ? Colors.red : AppColors.iconSecondary,
                            onTap:
                                () => FactUtils.toggleFavorite(fact, isSaved),
                          );
                        },
                      ),
                      const SizedBox(width: 4),
                    ],
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
