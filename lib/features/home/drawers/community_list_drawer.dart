import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/commen/error_text.dart';
import 'package:reddit/core/commen/loader.dart';
import 'package:reddit/core/commen/sigin_button.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/models/community_model.dart';

import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_controller.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({Key? key}) : super(key: key);

  void navigateToCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuset = !user.isAuthenticated;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuset
                ? SignInButton()
                : ListTile(
                    title: Text('Create a community'),
                    leading: Icon(Icons.add),
                    onTap: () => navigateToCommunity(context),
                  ),
            if (!isGuset)
              ref.watch(userCommunityProvider).when(
                  data: (communitise) => Expanded(
                        child: ListView.builder(
                            itemCount: communitise.length,
                            itemBuilder: (context, index) {
                              final community = communitise[index];
                              return ListTile(
                                leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(community.banner)),
                                title: Text('r/${community.name}'),
                                onTap: () {
                                  navigateCommunity(context, community);
                                },
                              );
                            }),
                      ),
                  error: (error, stackTrace) => ErrorText(error: e.toString()),
                  loading: () => Loader()),
          ],
        ),
      ),
    );
  }
}
