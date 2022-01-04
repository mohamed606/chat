import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates>{

  LoginCubit(): super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool obscure = true;

  IconData passwordIcon = Icons.visibility_outlined;


  void login({required String email, required String password}){
    emit(LoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)
    .then((value){
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
  }

  void changePasswordVisibility(){
    obscure = !obscure;
    passwordIcon = obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginPasswordVisibilityChanged());
  }
}