import 'dart:io';

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
          var profileImage = chatAppCubit.profileImage;
          var coverImage = chatAppCubit.coverImage;
          nameTextFieldController.text = userModel!.name;
          bioTextFieldController.text = userModel.bio;
          phoneTextFieldController.text = userModel.phone;
          return Scaffold(
            appBar: defaultAppBar(
                context: context,
                title: 'Edit Profile',
                actions: [
                  defaultTextButton(
                    onPressed: () {
                    },
                    text: 'Update',
                  ),
                  const SizedBox(
                    width: 15.0,
                  )
                ]
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: [
                    Container(
                      height: 190.0,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 140.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0)
                                    ),
                                    image: DecorationImage(
                                      image: coverImage==null?NetworkImage(userModel.coverPic):FileImage(coverImage) as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: (){
                                    chatAppCubit.getCoverImage();
                                  },
                                  icon: const CircleAvatar(
                                    radius: 20.0,
                                    child: Icon(
                                      IconBroken.Camera,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              CircleAvatar(
                                radius: 64.0,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: CircleAvatar(
                                  radius: 60.0,
                                  backgroundImage: profileImage==null?NetworkImage(userModel.profilePic):FileImage(profileImage) as ImageProvider,
                                ),
                              ),
                              IconButton(
                                onPressed: (){
                                  chatAppCubit.getProfileImage();
                                },
                                splashRadius: 20.0,
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    if(chatAppCubit.profileImage!=null||chatAppCubit.coverImage!=null)
                      Row(
                      children: [
                        if(chatAppCubit.profileImage != null)
                          Expanded(
                          child: Column(
                            children: [
                              defaultButton(
                                function: (){},
                                text: 'upload profile',
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              const LinearProgressIndicator(),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        if(chatAppCubit.profileImage != null)
                          Expanded(
                          child: Column(
                            children: [
                              defaultButton(
                                function: (){},
                                text: 'upload cover',
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              const LinearProgressIndicator(),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if(chatAppCubit.profileImage!=null||chatAppCubit.coverImage!=null)
                      const SizedBox(
                      height: 20.0,
                    ),
                    defaultFormField(
                      controller: nameTextFieldController,
                      inputType: TextInputType.name,
                      validate: (value){
                        if(isFormFieldEmpty(value)){
                          return 'Name must not be empty';
                        }
                        return null;
                      },
                      label:'Name',
                      prefixIcon: IconBroken.User,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                      controller: bioTextFieldController,
                      inputType: TextInputType.name,
                      validate: (value){
                        if(isFormFieldEmpty(value)){
                          return 'Bio must not be empty';
                        }
                        return null;
                      },
                      label:'Bio',
                      prefixIcon: IconBroken.Info_Circle,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    defaultFormField(
                      controller: phoneTextFieldController,
                      inputType: TextInputType.phone,
                      validate: (value){
                        if(isFormFieldEmpty(value)){
                          return 'Phone must not be empty';
                        }
                        return null;
                      },
                      label:'Phone',
                      prefixIcon: IconBroken.Call,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
  bool isFormFieldEmpty(String? value){
    if(value != null && value.isEmpty){
      return true;
    }
    return false;
  }
}
