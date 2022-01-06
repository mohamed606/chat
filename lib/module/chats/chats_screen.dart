import 'package:chat/model/user_model.dart';
import 'package:chat/module/chat_details/chat_details_screen.dart';
import 'package:chat/shared/components/components.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:chat/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatAppCubit, ChatAppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var chatAppCubit = ChatAppCubit.get(context);
        return chatAppCubit.users.isEmpty
            ? circularProgressIndicator()
            : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => buildChatItem(chatAppCubit.users[index], context),
                separatorBuilder: (context, index) => getMySeparator(),
                itemCount: chatAppCubit.users.length,
              );
      },
    );
  }

  Widget buildChatItem(UserModel user, context) => InkWell(
        onTap: () {
          navigateTo(context: context, widget: ChatDetailsScreen(user: user));
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(user.profilePic),
              ),
              const SizedBox(
                width: 15.0,
              ),
              Text(
                user.name,
                style: const TextStyle(
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      );
}
