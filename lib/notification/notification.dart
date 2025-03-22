// notification/notification.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';
import 'package:ev_/core/core/color/color.dart';

class NotificationHandler {
  static snakBarSuccess(
      {required String message, required BuildContext context}) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.solidCircleCheck,
              color: colorWhite,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        backgroundColor: colorGreen,
      ),
    );
  }

  static snakBarWarning({
    required String message,
    required BuildContext context,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.solidCircleQuestion,
              color: colorWhite,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
        backgroundColor: colorRed,
      ),
    );
  }

  static snakBarError(
      {required String message, required BuildContext context}) {
    return ToastService.showErrorToast(
      context,
      length: ToastLength.medium,
      expandedHeight: 100,
      message: message,
    );
  }
}
