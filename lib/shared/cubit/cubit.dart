import 'dart:io';
import 'package:chat/model/message_model.dart';
import 'package:chat/model/post_model.dart';
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
  File? postImage;
  List<PostModel> posts = [];
  List<UserModel> users = [];
  List<MessageModel> messages = [];
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
    if (index == 1) {
      getUsers();
    }
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

  Future<void> updateUserBio(String bio) async {
    emit(ChatAppUpdateUserBioLoadingState());
    return await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user!.userId)
        .update({'bio': bio}).then((value) {
      user!.bio = bio;
      emit(ChatAppUpdateUserBioSuccessState());
    });
  }

  Future<void> updateUserDetails(
      {required String name, required String phone}) async {
    emit(ChatAppUpdateUserDetailsLoadingState());
    return await FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(user!.userId)
        .update({'name': name, 'phone': phone}).then((value) {
      user!.name = name;
      user!.phone = phone;
      emit(ChatAppUpdateUserDetailsSuccessState());
    });
  }

  String getLastPathSegment(String path) {
    return Uri.file(path).pathSegments.last;
  }

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(ChatAppCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(ChatAppPostImagePickedErrorState());
    }
  }

  void uploadPostImage({required String dateTime, required String text}) {
    emit(ChatAppCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${getLastPathSegment(postImage!.path)}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(dateTime: dateTime, text: text, postImage: value);
      }).catchError((error) {
        emit(ChatAppCreatePostErrorState());
      });
    }).catchError((error) {
      emit(ChatAppCreatePostErrorState());
    });
  }

  void createPost(
      {required String dateTime, required String text, String? postImage}) {
    emit(ChatAppCreatePostLoadingState());
    PostModel post = PostModel(user!.name, user!.userId, user!.profilePic,
        dateTime, text, postImage ?? '');
    FirebaseFirestore.instance
        .collection('posts')
        .add(post.toMap())
        .then((value) {
      emit(ChatAppCreatePostSuccessState());
    }).catchError((error) {
      emit(ChatAppCreatePostErrorState());
    });
  }

  void removePostImage() {
    postImage = null;
    emit(ChatAppRemovePostImage());
  }

  void getPosts() {
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      value.docs.forEach((element) {
        PostModel post = PostModel.fromJson(element.data());
        post.postId = element.id;
        posts.add(post);
        element.reference.collection('likes').get().then((value) {
          post.likes = value.docs.length;
        }).catchError((error) {});
      });
      emit(ChatAppGetPostsSuccessState());
    }).catchError((error) {
      emit(ChatAppGetPostsErrorState());
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(user!.userId)
        .set({
      'like': true,
    }).then((value) {
      emit(ChatAppLikePostSuccessState());
    }).catchError((error) {
      emit(ChatAppLikePostErrorState());
    });
  }

  void getUsers() {
    users.clear();
    emit(ChatAppGetAllUserLoadingState());
    FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['userId'] != user!.userId)
          users.add(UserModel.fromJson(element.data()));
      });
      emit(ChatAppGetAllUserSuccessState());
    }).catchError((error) {
      emit(ChatAppGetAllUserErrorState());
    });
  }

  void sendMessage(
      {required String receiverId,
      required String dateTime,
      required String text}) {
    MessageModel message = MessageModel(
      senderId: user!.userId,
      receiverId: receiverId,
      dateTime: dateTime,
      text: text,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.userId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      emit(ChatAppSendMessageSuccessState());
    }).catchError((error) {
      emit(ChatAppSendMessageErrorState());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(user!.userId)
        .collection('messages')
        .add(message.toMap())
        .then((value) {
      emit(ChatAppSendMessageSuccessState());
    }).catchError((error) {
      emit(ChatAppSendMessageErrorState());
    });
  }

  void getMessages({required String receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.userId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages.clear();
      for (var element in event.docs) {
        messages.add(MessageModel.fromJson(element.data()));
      }
      emit(ChatAppReceiveMessagesSuccessState());
    });
  }
}
