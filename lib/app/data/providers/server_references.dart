import 'package:shared_preferences/shared_preferences.dart';

class ServerPreferences {
  static const URL = "url";
  static const IP = "ip";
  static const PORT = "port";

  static final ServerPreferences instance = ServerPreferences._internal();

  ServerPreferences._internal();

  SharedPreferences _sharedPreferences;
  String url;
  String ip;
  String port;

  factory ServerPreferences() => instance;

  Future<SharedPreferences> get preference async {
    if (_sharedPreferences != null) {
      return _sharedPreferences;
    } else {
      _sharedPreferences = await SharedPreferences.getInstance();

      url = _sharedPreferences.getString(URL);
      ip = _sharedPreferences.getString(IP);
      port = _sharedPreferences.getString(PORT);
    }

    return _sharedPreferences;
  }

  Future<bool> commit() async {
    await _sharedPreferences.setString(URL, url);
    await _sharedPreferences.setString(IP, ip);
    await _sharedPreferences.setString(PORT, port);

    return true;
  }

  Future<ServerPreferences> init() async {
    _sharedPreferences = await preference;
    return this;
  }
}
