import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../storage/session_storage.dart';

/// Logs out on the server (revokes the token), clears the saved session and
/// opens the sign-in page with no way back.
Future<void> logoutAndGoToSignIn(BuildContext context) async {
  final navigator = Navigator.of(context);

  try {
    await GetIt.instance<LogoutUseCase>().execute();
  } catch (_) {
    // Server not reachable: still remove the session from this phone.
    await SessionStorage.clear();
  }

  navigator.pushNamedAndRemoveUntil('/signin', (route) => false);
}

/// Asks "Log out?" first, then calls [logoutAndGoToSignIn].
Future<void> confirmLogout(BuildContext context) async {
  final yes = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Do you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text('Logout'),
        ),
      ],
    ),
  );

  if (yes == true && context.mounted) {
    await logoutAndGoToSignIn(context);
  }
}
