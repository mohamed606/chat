import 'dart:io';
import 'package:chat/model/user_model.dart';
import 'package:chat/module/chats/chats_screen.dart';
import 'package:chat/module/feeds/feeds_screen.dart';
import 'package:chat/module/settings/settings_screens.dart';
import 'package:chat/module/users/users_screen.dart';
import 'package:chat/shared/components/components.dart';
import 'package:chat/shared/components/constants.dart';
import 'package:chat/shared/cubit/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ChatAppCubit extends Cubit<ChatAppStates> {
  ChatAppCubit() : super(ChatAppInitialState());

  static ChatAppCubit get(context) => BlocProvider.of(context);
  UserModel? user;
  int currentBottomNavIndex = 0;
  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'Users',
    'Settings',
  ];
  File? profileImage;
  File? coverImage;
  final picker = ImagePicker();

  Future<void> getUserData() async {
    emit(ChatAppGetUserLoadingState());
    if (USER_ID != null) {
      FirebaseFirestore.instance
          .collection(USERS_COLLECTION)
          .doc(USER_ID)
          .get()
          .then((value) {
        user = UserModel.fromJson(value.data());
        print(user!.profilePic);
        emit(ChatAppGetUserSuccessState());
      }).catchError((error) {
        emit(ChatAppGetUserErrorState());
      });
    }
  }

  void changeBottomNavIndex(int index) {
    if (index == 2) {
      emit(ChatAppNewPostState());
    } else {
      currentBottomNavIndex = index;
      emit(ChatAppChangeBottomNavState());
    }
  }

  int getCorrectBottomNavIndex() {
    return currentBottomNavIndex > 2
        ? currentBottomNavIndex - 1
        : currentBottomNavIndex;
  }

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ChatAppProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(ChatAppProfileImagePickedErrorState());
    }
  }

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(ChatAppCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(ChatAppCoverImagePickedErrorState());
    }
  }

  Future<firebase_storage.TaskSnapshot> uploadProfilePic() async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${getLastPathSegment(profileImage!.path)}')
        .putFile(profileImage!);
  }

  Future<String> getImageDownloadLink(
      firebase_storage.TaskSnapshot value) async {
    return await value.ref.getDownloadURL();
  }

  Future<void> updateUserProfilePicInFirestore(String profilePicUrl) async {
    return await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user!.userId)
        .update({'profilePic': profilePicUrl});
  }

  Future<void> updateUserProfilePic() async {
    emit(ChatAppUpdateUserProfilePicLoadingState());
    return await uploadProfilePic().then((imageSnapshot) {
      getImageDownloadLink(imageSnapshot).then((imageDownloadLink) {
        updateUserProfilePicInFirestore(imageDownloadLink).then((value) {
          user!.profilePic = imageDownloadLink;
          emit(ChatAppUpdateUserProfilePicSuccessState());
        }).catchError((error) {
          emit(ChatAppUpdateUserProfilePicErrorState());
        });
      }).catchError((error) {
        emit(ChatAppUpdateUserProfilePicErrorState());
      });
    }).catchError((error) {
      emit(ChatAppUpdateUserProfilePicErrorState());
    });
  }

  Future<firebase_storage.TaskSnapshot> uploadCoverPic() async {
    return await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${getLastPathSegment(coverImage!.path)}')
        .putFile(coverImage!);
  }

  Future<void> updateUserCoverPicInFirestore(String coverPicUrl) async {
    return await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user!.userId)
        .update({'coverPic': coverPicUrl});
  }

  Future<void> updateUserCoverPic() async {
    emit(ChatAppUpdateUserCoverPicLoadingState());
    return await uploadCoverPic().then((imageSnapshot) {
      getImageDownloadLink(imageSnapshot).then((imageDownloadLink) {
        updateUserCoverPicInFirestore(imageDownloadLink).then((value) {
          user!.coverPic = imageDownloadLink;
          emit(ChatAppUpdateUserCoverPicSuccessState());
        }).catchError((error) {
          emit(ChatAppUpdateUserCoverPicErrorState());
        });
      }).catchError((error) {
        emit(ChatAppUpdateUserCoverPicErrorState());
      });
    }).catchError((error) {
      emit(ChatAppUpdateUserCoverPicErrorState());
    });
  }

  Future<void> updateUserBio(String bio) async{
    emit(ChatAppUpdateUserBioLoadingState());
    return await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user!.userId)
        .update({'bio': bio})
        .then((value){
          user!.bio = bio;
          emit(ChatAppUpdateUserBioSuccessState());
    });
  }
  Future<void> updateUserDetails({required String name, required String phone}) async{
    emit(ChatAppUpdateUserDetailsLoadingState());
    return await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user!.userId)
        .update({'name': name, 'phone':phone})
        .then((value){
      user!.name = name;
      user!.phone = phone;
      emit(ChatAppUpdateUserDetailsSuccessState());
    });
  }

  String getLastPathSegment(String path) {
    return Uri
        .file(path)
        .pathSegments
        .last;
  }
}
