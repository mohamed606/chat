import 'package:chat/module/edit_profile/edit_bio_screen.dart';
import 'package:chat/module/edit_profile/edit_cover_picture_screen.dart';
import 'package:chat/module/edit_profile/edit_profile_picture_screen.dart';
import 'package:chat/module/edit_profile/edit_user_details_screen.dart';
import 'package:chat/shared/components/components.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:chat/shared/styles/ico_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameTextFieldController = TextEditingController();
  var bioTextFieldController = TextEditingController();
  var phoneTextFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatAppCubit, ChatAppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var chatAppCubit = ChatAppCubit.get(context);
          var userModel = chatAppCubit.user;
          nameTextFieldController.text = userModel!.name;
          bioTextFieldController.text = userModel.bio;
          phoneTextFieldController.text = userModel.phone;
          return Scaffold(
            appBar: defaultAppBar(
              context: context,
              title: 'Edit Profile',
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    getDefaultRowForEditingUserProfile(
                      'Profile Picture',
                      context,
                      () {
                        chatAppCubit.getProfileImage().then((value) {
                          navigateTo(
                              context: context,
                              widget: EditProfilePictureScreen());
                        });
                      },
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    CircleAvatar(
                      radius: 80.0,
                      backgroundImage: NetworkImage(userModel.profilePic),
                    ),
                    getMySeparator(),
                    getDefaultRowForEditingUserProfile(
                      'Cover photo',
                      context,
                      () {
                        chatAppCubit.getCoverImage().then((value) {
                          navigateTo(
                              context: context,
                              widget: EditCoverPictureScreen());
                        });
                      },
                    ),
                    Container(
                      height: 160.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4.0)),
                        image: DecorationImage(
                          image: NetworkImage(userModel.coverPic),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    getMySeparator(),
                    getDefaultRowForEditingUserProfile('Bio', context, () {
                      navigateTo(context: context, widget: EditBioScreen());
                    }),
                    Text(
                      userModel.bio,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 16.0,
                          ),
                    ),
                    getMySeparator(),
                    getDefaultRowForEditingUserProfile('Details', context, () {
                      navigateTo(
                          context: context, widget: EditUserDetailsScreen());
                    }),
                    buildDetailsItem(IconBroken.User, userModel.name),
                    const SizedBox(
                      height: 5.0,
                    ),
                    buildDetailsItem(IconBroken.Call, userModel.phone),
                    const SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget getMySeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        width: double.infinity,
        height: 1.2,
        color: Colors.grey[300],
      ),
    );
  }

  Widget getDefaultRowForEditingUserProfile(
      String text, BuildContext context, VoidCallback onClick) {
    return Row(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const Spacer(),
        defaultTextButton(onPressed: onClick, text: 'Edit'),
      ],
    );
  }

  Widget buildDetailsItem(IconData icon, String detailData) {
    return Row(
      children: [
        Icon(
          icon,
        ),
        const SizedBox(
          width: 5.0,
        ),
        Text(
          detailData,
        ),
      ],
    );
  }
}
