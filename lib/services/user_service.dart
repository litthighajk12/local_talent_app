class UserService {
  static Map<String, dynamic> user = {};

  static void setUser(Map<String, dynamic> data) {
    user = data;
  }

  static Map<String, dynamic> getUser() {
    return user;
  }
}