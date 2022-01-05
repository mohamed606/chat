import 'package:bloc/bloc.dart';
import 'package:chat/layout/home.dart';
import 'package:chat/module/edit_profile/edit_profile_screen.dart';
import 'package:chat/module/login/login_screen.dart';
import 'package:chat/network/local/cache_helper.dart';
import 'package:chat/shared/components/components.dart';
import 'package:chat/shared/components/constants.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:chat/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_obs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
        () {
      // Use cubits...
    },
    blocObserver: MyBlocObserver(),
  );
  await Firebase.initializeApp();
  await CacheHelper.init();

  Widget startScreen;
  if(CacheHelper.hasKey(key: USERID)){
    startScreen = HomeScreen();
    USER_ID = (CacheHelper.getString(key: USERID)) as String;
  }else{
    startScreen = LoginScreen();
  }

  runApp(MyApp(startScreen));
}

class MyApp extends StatelessWidget {
  Widget startScreen;

  MyApp(this.startScreen);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatAppCubit()..getUserData()..getPosts(),
      child: BlocConsumer<ChatAppCubit, ChatAppStates>(
        listener: (context, state){},
        builder: (context, state){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: ThemeMode.light,
            home: startScreen,
          );
        },
      ),
    );
  }
}
