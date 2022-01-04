import 'package:chat/model/user_model.dart';
import 'package:chat/shared/components/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates>{

  RegisterCubit(): super(RegisterInitialState());


  static RegisterCubit get(context) => BlocProvider.of(context);

  bool obscure = true;

  IconData passwordIcon = Icons.visibility_outlined;


  void register({required String email, required String password, required String name, required String phone}){
    emit(RegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
    .then((value){
      userCreate(email: email, name: name, phone: phone, userId: value.user!.uid);
    }).catchError((error){
      emit(RegisterErrorState(error.toString()));
    });
  }

  void userCreate({required String email, required String name, required String phone, required String userId}){
    FirebaseFirestore.instance.collection('users').doc(userId)
        .set(UserModel(name, email, phone, userId, DEFAULT_IMAGE_URL, DEFAULT_COVER_PIC, "write your bio...", false).toMap())
        .then((value){
          emit(RegisterCreateSuccessState());
    }).catchError((error){
      emit(RegisterCreateErrorState(error.toString()));
    });
  }

  void changePasswordVisibility(){
    obscure = !obscure;
    passwordIcon = obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterPasswordVisibilityChanged());
  }
}