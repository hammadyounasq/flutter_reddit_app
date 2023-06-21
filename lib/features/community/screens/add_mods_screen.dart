import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/commen/error_text.dart';
import 'package:reddit/core/commen/loader.dart';
import 'package:reddit/features/auth/controller/auth_controller.dart';
import 'package:reddit/features/community/controller/community_controller.dart';

class AddModsscreen extends ConsumerStatefulWidget {
  String name;

  AddModsscreen({required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsscreenState();
}

class _AddModsscreenState extends ConsumerState<AddModsscreen> {
  Set<String> uids = {};
  int ctr = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void save() {
    ref
        .watch(communityControllerProvider.notifier)
        .addmod(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              save();
            },
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvide(widget.name)).when(
          data: (community) => ListView.builder(
                itemCount: community.members.length,
                itemBuilder: (BuildContext context, int index) {
                  final member = community.members[index];
                  return ref.watch(getUserDataProvider(member)).when(
                      data: (userdata) {
                        if (community.members.contains(userdata.uid) &&
                            ctr == 0) {
                          uids.add(userdata.uid);
                        }
                        ctr++;
                        return CheckboxListTile(
                          value: uids.contains(userdata.uid),
                          onChanged: (val) {
                            if (val!) {
                              addUid(userdata.uid);
                            } else {
                              removeUid(userdata.uid);
                            }
                          },
                          title: Text(userdata.name),
                        );
                      },
                      // data: (user) {
                      //   if (community.mods.contains(member) && ctr == 0) {
                      //     uids.add(member);
                      //   }
                      //   ctr++;
                      //   return CheckboxListTile(
                      //     value: uids.contains(user.uid),
                      //     onChanged: (val) {
                      //       if (val!) {
                      //         addUid(user.uid);
                      //       } else {
                      //         removeUid(user.uid);
                      //       }
                      //     },
                      //     title: Text(user.name),
                      //   );
                      // },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => Loader());
                },
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => Loader()),
    );
  }
}
