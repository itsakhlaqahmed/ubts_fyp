import 'package:shared_preferences/shared_preferences.dart';
import 'package:ubts_fyp/models/user.dart';

class PersistantStorage {
  final Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  Future<void> persistUserData(Map<UserData, String> data) async {
    final SharedPreferences localStorage = await _sharedPreferences;

    await localStorage.setStringList('user', [
      data[UserData.userId]!,
      data[UserData.fullName]!,
      data[UserData.email]!,
      data[UserData.studentId]!,
      data[UserData.isApproved]!,
      data[UserData.busRoute]!,
      data[UserData.busStop]!,
    ]);

  }

  Future<void> deleteLocalUser() async {
    final SharedPreferences localStorage = await _sharedPreferences;
    localStorage.clear();
  }

  Future<Map<UserData, dynamic>> fetchLocalUser() async {
    final SharedPreferences localStorage = await _sharedPreferences;

    List<String>? localData = localStorage.getStringList('user');
    if (localData != null) {
      Map<UserData, String> userData = {
        UserData.userId: localData[0],
        UserData.fullName: localData[1],
        UserData.email: localData[2],
        UserData.studentId: localData[3],
        UserData.isApproved: localData[4],
        UserData.busRoute: localData[5],
        UserData.busStop: localData[6],
      };

      return userData;
    }

    return {UserData.userId: null};
  }
}
