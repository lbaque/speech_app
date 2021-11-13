import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const UID = "uid";
  static const TYPEUSER = "typeuser";
  static const USERNAME = "username";
  static const EMAIL = "email";
  static const ENTRY = "entry";

  static final UserPreferences instance = UserPreferences._internal();

  UserPreferences._internal();

  SharedPreferences _sharedPreferences;
  String uid;
  String typeuser;
  String username;
  String email;
  bool entry = false;

  factory UserPreferences() => instance;

  Future<SharedPreferences> get preference async {
    if (_sharedPreferences != null) {
      return _sharedPreferences;
    } else {
      _sharedPreferences = await SharedPreferences.getInstance();

      uid = _sharedPreferences.getString(UID);
      typeuser = _sharedPreferences.getString(TYPEUSER);
      username = _sharedPreferences.getString(USERNAME);
      email = _sharedPreferences.getString(EMAIL);
      entry = _sharedPreferences.getBool(ENTRY);

      if (entry == null) {
        entry = false;
      }
    }

    return _sharedPreferences;
  }

  Future<bool> commit() async {
    await _sharedPreferences.setString(UID, uid);
    await _sharedPreferences.setString(TYPEUSER, typeuser);
    await _sharedPreferences.setString(USERNAME, username);
    await _sharedPreferences.setString(EMAIL, email);
    await _sharedPreferences.setBool(ENTRY, entry);

    return true;
  }

  Future<bool> signOut() async {
    await _sharedPreferences.setString(UID, "");
    await _sharedPreferences.setString(TYPEUSER, "");
    await _sharedPreferences.setString(USERNAME, "");
    await _sharedPreferences.setString(EMAIL, "");
    await _sharedPreferences.setBool(ENTRY, false);

    return true;
  }

  Future<UserPreferences> init() async {
    _sharedPreferences = await preference;
    return this;
  }
}
