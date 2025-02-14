import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:madsm/routing/routes.dart';

class Utils {
  Utils._();

  static Future<bool> haveConnection() async {
    final connectivityResults = await Connectivity().checkConnectivity();
    return !connectivityResults.contains(ConnectivityResult.none);
  }

  static DateTime today() {
    final today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  static void openPhotoView({required BuildContext context, required ImageProvider imageProvider}) {
    context.push(
      Routes.photoView,
      extra: imageProvider,
    );
  }

  static String calculateTimeDifference(DateTime date) {
    final difference = DateTime.now().toUtc().difference(date);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inSeconds}s ago';
    }
  }
}
