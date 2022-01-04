import 'package:chat/layout/home.dart';
import 'package:chat/module/login/login_screen.dart';
import 'package:chat/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/register_cubit.dart';
import 'cubit/register_states.dart';

class RegisterScreen extends StatelessWidget {

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var nameController = TextEditingController();

  var phoneController= TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state){
          if(state is RegisterCreateSuccessState){
            navigateAndFinish(context: context, widget: HomeScreen());
          }
        },
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(),
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
                          "REGISTER",
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Register now to communicat with friends",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                            controller:nameController,
                            inputType: TextInputType.name,
                            label: "Name",
                            prefixIcon: Icons.person,
                            validate: (value){
                              if(value != null && value.isEmpty){
                                return "name must not be empty";
                              }
                              return null;
                            }
                        ),
                        const SizedBox(
                          height: 15.0,
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
                            controller: phoneController,
                            inputType: TextInputType.phone,
                            label: "Phone",
                            prefixIcon: Icons.phone,
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
                          obscureText: RegisterCubit.get(context).obscure,
                          validate: (value){
                            if(value != null && value.isEmpty){
                              return "password must not be empty";
                            }
                            return null;
                          },
                          suffixIcon: RegisterCubit.get(context).passwordIcon,
                          suffixFunction: (){
                            RegisterCubit.get(context).changePasswordVisibility();
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        state is! RegisterLoadingState ? defaultButton(
                          function: (){
                            if(formKey.currentState != null && formKey.currentState!.validate()){
                              RegisterCubit.get(context).register(
                                email: emailController.text.toString(),
                                password: passwordController.text.toString(),
                                name: nameController.text.toString(),
                                phone: phoneController.text.toString(),
                              );
                            }
                          },
                          text: "register",
                        ): circularProgressIndicator(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                "Have an account?"
                            ),
                            defaultTextButton(
                              onPressed: (){
                                navigateAndFinish(context: context, widget: LoginScreen());
                              },
                              text: "login",
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
