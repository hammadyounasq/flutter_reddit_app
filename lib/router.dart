import 'package:flutter/material.dart';
import 'package:reddit/features/auth/screens/login_screen.dart';
import 'package:reddit/features/community/screens/add_mods_screen.dart';
import 'package:reddit/features/community/screens/community_screen.dart';
import 'package:reddit/features/community/screens/edits_community_screen.dart';

import 'package:reddit/features/community/screens/mods_tools_screen.dart';
import 'package:reddit/features/home/screen/home_screen.dart';
import 'package:reddit/features/post/screen/add_post_type_screen.dart';
import 'package:reddit/features/post/screen/comments_screen.dart';
import 'package:reddit/features/user_profile/screen/edit_profile_screen.dart';
import 'package:reddit/features/user_profile/screen/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

import 'features/community/screens/create_community_screen.dart';

final loggedOutRoute =
    RouteMap(routes: {'/': (_) => MaterialPage(child: LoginScreen())});
final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: HomeScreen()),
  '/create-community': (_) => MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(
          child: CommunityScreen(
        name: route.pathParameters['name']!,
      )),
  '/mod-tools/:name': (routeData) => MaterialPage(
          child: ModTools(
        name: routeData.pathParameters['name']!,
      )),
  '/edit-community/:name': (routeData) => MaterialPage(
          child: EditCommunityScreen(
        name: routeData.pathParameters['name']!,
      )),
  '/add-mods/:name': (routeData) => MaterialPage(
          child: AddModsscreen(
        name: routeData.pathParameters['name']!,
      )),
  '/u/:uid': (routeData) => MaterialPage(
          child: UserProfileScreen(
        uid: routeData.pathParameters['uid']!,
      )),
  '/edit-profile/:uid': (routeData) => MaterialPage(
          child: EditprofileScreen(
        uid: routeData.pathParameters['uid']!,
      )),
  '/add-post/:type': (routeData) => MaterialPage(
          child: AddPostTypeScreen(
        type: routeData.pathParameters['type']!,
      )),
  '/post/:postId/comments': (route) => MaterialPage(
          child: CommentsScreen(
        postId: route.pathParameters['postId']!,
      )),
});
