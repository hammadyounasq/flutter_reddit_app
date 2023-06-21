import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/provider/utils.dart';
import 'package:reddit/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit/theme/pallete.dart';

import '../../../core/commen/error_text.dart';
import '../../../core/commen/loader.dart';
import '../../../core/constants/constants.dart';
import '../../auth/controller/auth_controller.dart';

class EditprofileScreen extends ConsumerStatefulWidget {
  final String uid;
  EditprofileScreen({required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditprofileScreenState();
}

class _EditprofileScreenState extends ConsumerState<EditprofileScreen> {
  File? profileFile;
  File? bannerFile;
  late TextEditingController nameController;
  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      profileFile = File(res.files.first.path!);
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editUser(
        profile: profileFile,
        bannerFile: bannerFile,
        name: nameController.text.trim(),
        context: context);
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifieProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
        data: (user) => Scaffold(
              
              appBar: AppBar(
                title: Text('Edit Profile'),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () => save(),
                    child: Text('Save'),
                  ),
                ],
              ),
              body: isLoading
                  ? Loader()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: selectBannerImage,
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(10),
                                    dashPattern: [10, 4],
                                    strokeCap: StrokeCap.round,
                                    // color: currentTheme.textTheme.bodyText2!.color!,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: bannerFile != null
                                          ? Image.file(bannerFile!)
                                          : user.banner.isEmpty ||
                                                  user.banner ==
                                                      Constants.bannerDefault
                                              ? Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 40,
                                                  ),
                                                )
                                              : Image.network(user.banner),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: selectProfileImage,
                                    child: profileFile != null
                                        ? CircleAvatar(
                                            backgroundImage: FileImage(
                                              profileFile!,
                                            ),
                                            radius: 32)
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              user.profilePic,
                                            ),
                                            radius: 32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              filled: true,
                              hintText: 'Name',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(10)),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
        loading: () => Loader(),
        error: (error, stackTrace) => ErrorText(error: error.toString()));
  }
}
