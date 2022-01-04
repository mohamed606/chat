import 'package:chat/shared/components/components.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:chat/shared/styles/ico_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditUserDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatAppCubit, ChatAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var chatAppCubit = ChatAppCubit.get(context);
        var user = chatAppCubit.user;
        var nameTextFormFieldController = TextEditingController();
        var phoneTextFormFieldController = TextEditingController();
        var formKey = GlobalKey<FormState>();
        nameTextFormFieldController.text = user!.name;
        phoneTextFormFieldController.text = user.phone;
        return Scaffold(
          appBar:
              defaultAppBar(context: context, title: "Edit Details", actions: [
            Center(
              child: defaultTextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      chatAppCubit.updateUserDetails(
                        name: nameTextFormFieldController.text.toString(),
                        phone: phoneTextFormFieldController.text.toString(),
                      ).then((value){
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
                child: Form(
                  key: formKey,
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
                      defaultFormField(
                        controller: nameTextFormFieldController,
                        inputType: TextInputType.name,
                        validate: (text) {
                          if (text != null && text.isEmpty) {
                            return "Name must not be empty";
                          }
                          return null;
                        },
                        label: 'Name',
                        prefixIcon: IconBroken.User,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      defaultFormField(
                        controller: phoneTextFormFieldController,
                        inputType: TextInputType.phone,
                        validate: (text) {
                          if (text != null && text.isEmpty) {
                            return "Phone must not be empty";
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefixIcon: IconBroken.Call,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
