import 'package:chat/shared/components/components.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePictureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatAppCubit, ChatAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var chatAppCubit = ChatAppCubit.get(context);
        var userModel = chatAppCubit.user;
        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              title: "Preview profile picture",
              actions: [
                Center(
                  child: defaultTextButton(
                      onPressed: () {
                        ChatAppCubit.get(context)
                            .updateUserProfilePic()
                            .then((value) {
                          Navigator.pop(context);
                        });
                      },
                      text: 'save'),
                )
              ]),
          body: Column(
            children: [
              if(state is ChatAppUpdateUserProfilePicLoadingState)
                const LinearProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            child: Container(
                              height: 140.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0)
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(userModel!.coverPic),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          CircleAvatar(
                            radius: 64.0,
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            child: CircleAvatar(
                              radius: 60.0,
                              backgroundImage: FileImage(chatAppCubit.profileImage!),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
