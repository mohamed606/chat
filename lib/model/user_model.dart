class UserModel{
  late String name;
  late String email;
  late String phone;
  late String userId;
  late String profilePic;
  late String coverPic;
  late String bio;
  bool isEmailVerified = false;

  UserModel(this.name,this.email,this.phone,this.userId, this.profilePic, this.coverPic, this.bio, this.isEmailVerified);

  UserModel.fromJson(Map<String, dynamic>? json){
    if(json == null) {return;}
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    userId = json['userId'];
    profilePic = json['profilePic'];
    coverPic = json['coverPic'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toMap() => {
    'name':name,
    'email':email,
    'phone':phone,
    'userId':userId,
    'profilePic':profilePic,
    'coverPic':coverPic,
    'bio':bio,
    'isEmailVerified':isEmailVerified,
  };

}