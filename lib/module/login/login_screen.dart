import 'package:chat/layout/home.dart';
import 'package:chat/module/register/register_screen.dart';
import 'package:chat/network/local/cache_helper.dart';
import 'package:chat/shared/components/components.dart';
import 'package:chat/shared/components/constants.dart';
import 'package:chat/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/login_cubit.dart';
import 'cubit/login_states.dart';

class LoginScreen extends StatelessWidget {

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state){
          if(state is LoginErrorState){
            defaultToast(message: state.error);
          } else if(state is LoginSuccessState){
            CacheHelper.putString(key: USERID, value: state.userId)
            .then((value){
              USER_ID = state.userId;
              navigateAndFinish(context: context, widget: HomeScreen());
            });
          }
        },
        builder: (context, state){
          return Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "LOGIN",
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "login now to communicate with friends",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            controller: emailController,
                            inputType: TextInputType.emailAddress,
                            label: "Email Address",
                            prefixIcon: Icons.email_outlined,
                            validate: (value){
                              if(value != null && value.isEmpty){
                                return "email address must not be empty";
                              }
                              return null;

                            }
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          inputType: TextInputType.visiblePassword,
                          label: "Password",
                          prefixIcon: Icons.lock_outline,
                          obscureText: LoginCubit.get(context).obscure,
                          validate: (value){
                            if(value != null && value.isEmpty){
                              return "password must not be empty";
                            }
                            return null;
                          },
                          onSubmit: (value){
                            if(formKey.currentState != null && formKey.currentState!.validate()){
                              LoginCubit.get(context).login(
                                email: emailController.text.toString(),
                                password: value,
                              );
                            }
                          },
                          suffixIcon: LoginCubit.get(context).passwordIcon,
                          suffixFunction: (){
                            LoginCubit.get(context).changePasswordVisibility();
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        state is! LoginLoadingState ? defaultButton(
                          function: (){
                            if(formKey.currentState != null && formKey.currentState!.validate()){
                              LoginCubit.get(context).login(
                                email: emailController.text.toString(),
                                password: passwordController.text.toString(),
                              );
                            }
                          },
                          text: "login",
                        ): circularProgressIndicator(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                "Don't have an account?"
                            ),
                            defaultTextButton(
                              onPressed: (){
                                navigateTo(context: context, widget: RegisterScreen());
                              },
                              text: "register",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
