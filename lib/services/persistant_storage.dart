import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubts_fyp/models/user.dart';

class PersistantStorage {
  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  Future<void> persistUserData(Map<User, String> data) async {
    final SharedPreferences localStorage = await _sharedPreferences;
    await localStorage.setStringList('user', [
      data[User.userId]!,
      data[User.fullName]!,
      data[User.email]!,
      data[User.isApproved]!,
    ]);
  }

  Future<Map<User, String>?> fetchLocalData() async {
    final SharedPreferences localStorage = await _sharedPreferences;

    List<String>? localData = localStorage.getStringList('user');
    if (localData != null) {
      Map<User, String> userData = {
        User.userId: localData[0],
        User.fullName: localData[1],
        User.email: localData[2],
        User.isApproved: localData[3]
      };

      return userData;
    }

    return null;
  }
}
