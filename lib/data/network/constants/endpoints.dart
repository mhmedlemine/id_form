class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://localhost:9000";

  // receiveTimeout
  static const int receiveTimeout = 30000;

  // connectTimeout
  static const int connectionTimeout = 60000;

  // booking endpoints
  static const String postIdForm = baseUrl + "/post_id_form";
}