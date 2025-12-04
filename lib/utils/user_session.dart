class UserSession {
  static int? id;
  static String? name;
  static String? email;

  static void saveSession(int userId, String userName, String userEmail) {
    id = userId;
    name = userName;
    email = userEmail;
  }

  static void clearSession() {
    id = null;
    name = null;
    email = null;
  }
}
