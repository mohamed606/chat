import 'package:chat/module/new_post/new_post_screen.dart';
import 'package:chat/shared/components/components.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:chat/shared/styles/ico_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatAppCubit, ChatAppStates>(
      listener: (context, state) {
        if(state is ChatAppNewPostState){
          navigateTo(context: context, widget: NewPostScreen());
        }
      },
      builder: (context, state) {
        var appCubit = ChatAppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              appCubit.titles[appCubit.getCorrectBottomNavIndex()],
            ),
            actions: [
              IconButton(
                onPressed: (){},
                icon: const Icon(IconBroken.Notification),
              ),
              IconButton(
                onPressed: (){},
                icon: const Icon(IconBroken.Search),
              ),
            ],
          ),
          body: appCubit.screens[appCubit.getCorrectBottomNavIndex()],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: appCubit.currentBottomNavIndex,
            onTap: (index) => appCubit.changeBottomNavIndex(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(IconBroken.Plus),
                label: "Post"
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Location,
                ),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.User,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }

}
