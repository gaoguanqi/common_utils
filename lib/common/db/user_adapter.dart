import 'package:hive/hive.dart';

import 'db.dart';

class UserAdapter extends TypeAdapter<User>{

  @override
  User read(BinaryReader reader) {
    return User(
      userId: reader.read(),
      token: reader.read(),
      username: reader.read(),
      nickname: reader.read(),
      phone: reader.read(),
      avatarImg: reader.read(),
    );
  }

  @override
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.userId);
    writer.write(obj.token);
    writer.write(obj.username);
    writer.write(obj.nickname);
    writer.write(obj.phone);
    writer.write(obj.avatarImg);
  }

  UserAdapter();
}