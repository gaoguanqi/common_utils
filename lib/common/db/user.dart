import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class User extends HiveObject{
  String? userId = '';
  String? phone = '';
  String? username = '';
  String? nickname = '';
  String? token = '';
  String? avatarImg = '';

  User({
    this.userId,
    this.phone,
    this.username,
    this.nickname,
    this.token,
    this.avatarImg,
  });

  @override
  String toString() {
    return 'User{userId: $userId, phone: $phone, username: $username,nickname: $nickname,token: $token, avatarImg: $avatarImg}';
  }
}