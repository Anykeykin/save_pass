abstract class UserRepository {
  Future<dynamic> login(
    String email,
    String password,
  );
  Future<dynamic> register(
    String email,
    String password,
  );
  Future<void> logout();
}
