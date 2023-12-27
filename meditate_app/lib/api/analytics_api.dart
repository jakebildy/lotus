import 'package:http/http.dart' as http;
import "index.dart" as api;

class AnalyticsApi {
  static AnalyticsApi? _singleton;
  String get url => api.url;
  AnalyticsApi._internal();

  factory AnalyticsApi() {
    _singleton ??= AnalyticsApi._internal();
    return _singleton!;
  }

  //Endpoints
  Future<void> logUserEvent(String name) async {
    await http.post(api.https(url, "/api/stats/log/$name"),
        headers: api.headers);
  }
}
