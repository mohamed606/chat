abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates{}

class RegisterSuccessState extends RegisterStates{}

class RegisterLoadingState extends RegisterStates{}

class RegisterErrorState extends RegisterStates{
  RegisterErrorState(String error){
    print(error);
  }
}

class RegisterPasswordVisibilityChanged extends RegisterStates{}

class RegisterCreateSuccessState extends RegisterStates{}

class RegisterCreateLoadingState extends RegisterStates{}

class RegisterCreateErrorState extends RegisterStates{
  RegisterCreateErrorState(String error){
    print(error);
  }
}