import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';

import 'package:routemaster/routemaster.dart';

import '../../../theme/pallete.dart';

class ProfileDrawer extends ConsumerWidget {
  void logout(WidgetRef ref) {
    return ref.watch(authControllerProvider.notifier).logout();
  }

  void navigatorToProfile(BuildContext context, String uid) {
    Routemaster.of(context).push('/u/${uid}');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifieProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
              radius: 70,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'u/${user.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Divider(),
            ListTile(
              title: Text('My Profile'),
              leading: Icon(Icons.person),
              onTap: () {
                navigatorToProfile(context, user.uid);
              },
            ),
            ListTile(
              title: Text('Log Out'),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => logout(ref),
            ),
            Switch.adaptive(
                value: ref.watch(themeNotifieProvider.notifier).mode ==
                    ThemeMode.dark,
                onChanged: (val) => toggleTheme(ref)),
          ],
        ),
      ),
    );
  }
}
