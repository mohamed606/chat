import 'package:chat/model/user_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates{}

class LoginSuccessState extends LoginStates{
  final String userId;
  LoginSuccessState(this.userId);
}

class LoginLoadingState extends LoginStates{}

class LoginErrorState extends LoginStates{
  final String error;
  LoginErrorState(this.error);
}

class LoginPasswordVisibilityChanged extends LoginStates{}
