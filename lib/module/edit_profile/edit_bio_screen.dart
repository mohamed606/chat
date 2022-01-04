import 'package:chat/shared/components/components.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:chat/shared/styles/ico_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditBioScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatAppCubit, ChatAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var chatAppCubit = ChatAppCubit.get(context);
        var user = chatAppCubit.user;
        var bioTextFormFieldController = TextEditingController();
        var formKey = GlobalKey<FormState>();
        bioTextFormFieldController.text = user!.bio;
        return Scaffold(
          appBar: defaultAppBar(
              context: context,
              title: "Edit bio",
              actions: [
                Center(
                  child: defaultTextButton(
                      onPressed: () {
                        if(formKey.currentState!.validate()){
                          ChatAppCubit.get(context)
                              .updateUserBio(bioTextFormFieldController.text.toString())
                              .then((value) {
                            Navigator.pop(context);
                          });
                        }
                      },
                      text: 'save'),
                )
              ]),
          body: Column(
            children: [
              if(state is ChatAppUpdateUserProfilePicLoadingState)
                const LinearProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 25.0,
                          backgroundImage: NetworkImage(user!.profilePic),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Text(
                          user.name,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        maxLines: 5,
                        minLines: 3,
                        controller: bioTextFormFieldController,
                        keyboardType: TextInputType.name,
                        validator: (text){
                          if(text != null && text.isEmpty){
                            return "Bio must not be empty";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Bio',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
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
