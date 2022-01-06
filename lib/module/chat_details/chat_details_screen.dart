import 'package:chat/model/message_model.dart';
import 'package:chat/model/user_model.dart';
import 'package:chat/shared/components/components.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:chat/shared/styles/colors.dart';
import 'package:chat/shared/styles/ico_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel user;
  var messageFormFieldController = TextEditingController();

  ChatDetailsScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        ChatAppCubit.get(context).getMessages(receiverId: user.userId);
        return BlocConsumer<ChatAppCubit, ChatAppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var chatAppCubit = ChatAppCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(user.profilePic),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      user.name,
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: chatAppCubit.messages.isEmpty
                    ? circularProgressIndicator()
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                var message = chatAppCubit.messages[index];
                                if (chatAppCubit.user!.userId ==
                                    message.senderId)
                                  return buildSentMessage(message);
                                else
                                  return buildReceivedMessage(message);
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 15.0,
                              ),
                              itemCount: chatAppCubit.messages.length,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300] as Color,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                    ),
                                    child: TextFormField(
                                      controller: messageFormFieldController,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'type your message here...',
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 55.0,
                                  color: defaultColor,
                                  child: MaterialButton(
                                    minWidth: 1.0,
                                    onPressed: () {
                                      if (messageFormFieldController
                                          .text.isNotEmpty) {
                                        chatAppCubit.sendMessage(
                                          receiverId: user.userId,
                                          dateTime: DateTime.now().toString(),
                                          text: messageFormFieldController.text,
                                        );
                                        messageFormFieldController.clear();
                                      }
                                    },
                                    child: const Icon(
                                      IconBroken.Send,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildReceivedMessage(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: const BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            message.text,
          ),
        ),
      );

  Widget buildSentMessage(MessageModel message) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: defaultColor.withOpacity(0.2),
            borderRadius: const BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            message.text,
          ),
        ),
      );
}
