// import 'package:any_link_preview/any_link_preview.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reddit/core/commen/error_text.dart';
// import 'package:reddit/core/commen/loader.dart';
// import 'package:reddit/features/community/controller/community_controller.dart';
// import 'package:reddit/features/post/controller/post.controller.dart';
// import 'package:reddit/theme/pallete.dart';
// import 'package:routemaster/routemaster.dart';
// import '../../features/auth/controller/auth_controller.dart';
// import '../../models/post_model.dart';
// import '../constants/constants.dart';

// class PostCart extends ConsumerWidget {
//   final Post post;
//   PostCart({required this.post});

//   void deletePost(WidgetRef ref, BuildContext context) {
//     ref.watch(postController.notifier).delete(post, context);
//   }

//   void upvote(WidgetRef ref) async {
//     ref.read(postController.notifier).upvote(post);
//   }

//   void downvote(WidgetRef ref) async {
//     ref.read(postController.notifier).downvote(post);
//   }

//   void awardpoas(WidgetRef ref, String award, BuildContext context) async {
//     ref
//         .read(postController.notifier)
//         .awardPost(post: post, context: context, award: award);
//   }

//   void navgaterTocommunity(BuildContext context) {
//     Routemaster.of(context).push('/r/${post.communityName}');
//   }

//   void navgaterTouserProfilr(BuildContext context) {
//     Routemaster.of(context).push('/u/${post.uid}');
//   }

//   void navgaterTocomment(BuildContext context) {
//     Routemaster.of(context).push('/post/${post.id}/comments');
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isTypeImage = post.type == 'image';
//     final isTypeText = post.type == 'text';
//     final isTypeLink = post.type == 'link';
//     final user = ref.watch(userProvider)!;
//     final isGuset = !user.isAuthenticated;

//     final currentTheme = ref.watch(themeNotifieProvider);
//     return Column(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: currentTheme.drawerTheme.backgroundColor,
//           ),
//           padding: EdgeInsets.symmetric(vertical: 10),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
//                           .copyWith(right: 0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () => navgaterTocommunity(context),
//                                     child: Image.network(
//                                       post.communityProfilePic,
//                                       width: 40,
//                                       height: 40,
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 8),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'r/${post.communityName}',
//                                           style: TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                         GestureDetector(
//                                           onTap: () =>
//                                               navgaterTouserProfilr(context),
//                                           child: Text(
//                                             'u/${post.username}',
//                                             style: TextStyle(
//                                               fontSize: 12,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               if (post.uid == user.uid)
//                                 IconButton(
//                                   onPressed: () => deletePost(ref, context),
//                                   icon: Icon(
//                                     Icons.delete,
//                                     color: Pallete.redColor,
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           if (post.awards.isNotEmpty) ...[
//                             SizedBox(
//                               height: 5,
//                             ),
//                             SizedBox(
//                               height: 25,
//                               child: ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: post.awards.length,
//                                   itemBuilder: (context, index) {
//                                     final award = post.awards[index];
//                                     return Image.asset(
//                                       Constants.awards[award]!,
//                                       height: 23,
//                                     );
//                                   }),
//                             )
//                           ],
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               post.title,
//                               style: TextStyle(
//                                   fontSize: 19, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           if (isTypeImage)
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.35,
//                               width: double.infinity,
//                               child: Image.network(
//                                 post.link!,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           if (isTypeLink)
//                             Container(
//                               height: 150,
//                               width: double.infinity,
//                               child: AnyLinkPreview(
//                                 displayDirection:
//                                     UIDirection.uiDirectionHorizontal,
//                                 link: post.link!,
//                               ),
//                             ),
//                           if (isTypeText)
//                             Container(
//                               alignment: Alignment.bottomLeft,
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 15.0),
//                                 child: Text(
//                                   post.description!,
//                                   style: TextStyle(color: Colors.grey),
//                                 ),
//                               ),
//                             ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     onPressed: () => upvote(ref),
//                                     icon: Icon(
//                                       Constants.up,
//                                       size: 30,
//                                       color: post.upvotes.contains(user.uid)
//                                           ? Pallete.redColor
//                                           : null,
//                                     ),
//                                   ),
//                                   Text(
//                                     '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
//                                     style: TextStyle(fontSize: 17),
//                                   ),
//                                   IconButton(
//                                     onPressed: () => downvote(ref),
//                                     icon: Icon(
//                                       Constants.down,
//                                       size: 30,
//                                       color: post.downvotes.contains(user.uid)
//                                           ? Pallete.blueColor
//                                           : null,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     onPressed: () => navgaterTocomment(context),
//                                     icon: Icon(Icons.comment),
//                                   ),
//                                   Text(
//                                     '${post.commentCount == 0 ? 'Communt' : post.commentCount}',
//                                     style: TextStyle(fontSize: 17),
//                                   ),
//                                 ],
//                               ),
//                               ref
//                                   .watch(getCommunityByNameProvide(
//                                       post.communityName))
//                                   .when(
//                                       data: (data) {
//                                         if (data.mods.contains(user.uid)) {
//                                           return IconButton(
//                                             onPressed: () =>
//                                                 deletePost(ref, context),
//                                             icon: Icon(
//                                                 Icons.admin_panel_settings),
//                                           );
//                                         }
//                                         return SizedBox();
//                                       },
//                                       error: (error, stackTrace) =>
//                                           ErrorText(error: error.toString()),
//                                       loading: () => Loader()),
//                               IconButton(
//                                 onPressed: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => Dialog(
//                                       child: Padding(
//                                         padding: EdgeInsets.all(20),
//                                         child: GridView.builder(
//                                             shrinkWrap: true,
//                                             gridDelegate:
//                                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                                     crossAxisCount: 4),
//                                             itemCount: user.awards!.length,
//                                             itemBuilder: (context, index) {
//                                               final award = user.awards![index];
//                                               return GestureDetector(
//                                                 onTap: () => awardpoas(
//                                                     ref, award, context),
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.all(8.0),
//                                                   child: Image.asset(
//                                                       Constants.awards[award]!),
//                                                 ),
//                                               );
//                                             }),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 icon: Icon(Icons.card_giftcard_outlined),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//       ],
//     );
//   }
// }
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/commen/error_text.dart';
import 'package:reddit/core/commen/loader.dart';
import 'package:reddit/features/community/controller/community_controller.dart';
import 'package:reddit/features/post/controller/post.controller.dart';
import 'package:reddit/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../../features/auth/controller/auth_controller.dart';
import '../../models/post_model.dart';
import '../constants/constants.dart';

class PostCart extends ConsumerWidget {
  final Post post;
  PostCart({required this.post});

  void deletePost(WidgetRef ref, BuildContext context) async {
    ref.read(postController.notifier).delete(post, context);
  }

  void upvotePost(WidgetRef ref) async {
    ref.read(postController.notifier).upvote(post);
  }

  void downvotePost(WidgetRef ref) async {
    ref.read(postController.notifier).downvote(post);
  }

  void awardPost(WidgetRef ref, String award, BuildContext context) async {
    ref
        .read(postController.notifier)
        .awardPost(post: post, award: award, context: context);
  }

  void navigatetoUser(BuildContext context) {
    Routemaster.of(context).push('/u/${post.uid}');
  }

  void navigatetoCommunty(BuildContext context) {
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigatetoComments(BuildContext context) {
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    final user = ref.watch(userProvider)!;
    final isGuset = !user.isAuthenticated;

    final currentTheme = ref.watch(themeNotifieProvider);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                          .copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigatetoCommunty(context),
                                    child: Image.network(
                                      post.communityProfilePic,
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'r/${post.communityName}',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        GestureDetector(
                                          onTap: () => navigatetoUser(context),
                                          child: Text(
                                            'u/${post.username}',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () {
                                    deletePost(ref, context);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                          if (post.awards.isNotEmpty) ...[
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 25,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: post.awards.length,
                                  itemBuilder: (context, index) {
                                    final award = post.awards[index];
                                    return Image.asset(
                                        Constants.awards[award]!);
                                  }),
                            )
                          ],
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              post.title,
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (isTypeImage)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                              width: double.infinity,
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Container(
                              height: 150,
                              width: double.infinity,
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Text(
                                  post.description!,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed:
                                        isGuset ? () {} : () => upvotePost(ref),
                                    icon: Icon(
                                      Constants.up,
                                      size: 30,
                                      color: post.upvotes.contains(user.uid)
                                          ? Pallete.redColor
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  IconButton(
                                    onPressed: isGuset
                                        ? () {}
                                        : () => downvotePost(ref),
                                    icon: Icon(
                                      Constants.down,
                                      size: 30,
                                      color: post.downvotes.contains(user.uid)
                                          ? Pallete.blueColor
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        navigatetoComments(context),
                                    icon: Icon(Icons.comment),
                                  ),
                                  Text(
                                    '${post.commentCount == 0 ? 'Communt' : post.commentCount}',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                              ref
                                  .watch(getCommunityByNameProvide(
                                      post.communityName))
                                  .when(
                                      data: (data) {
                                        if (data.mods.contains(user.uid)) {
                                          return IconButton(
                                            onPressed: () =>
                                                deletePost(ref, context),
                                            icon: Icon(
                                                Icons.admin_panel_settings),
                                          );
                                        }
                                        return SizedBox();
                                      },
                                      error: (error, stackTrace) =>
                                          ErrorText(error: error.toString()),
                                      loading: () => Loader()),
                              IconButton(
                                onPressed: isGuset
                                    ? () {}
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Padding(
                                              padding: EdgeInsets.all(20),
                                              child: GridView.builder(
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 4),
                                                  itemCount:
                                                      user.awards!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final award =
                                                        user.awards![index];
                                                    return GestureDetector(
                                                      onTap: () => awardPost(
                                                          ref, award, context),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.asset(
                                                            Constants.awards[
                                                                award]!),
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        );
                                      },
                                icon: Icon(Icons.card_giftcard_outlined),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
