import 'package:dietari/data/domain/UserTest.dart';
import 'package:dietari/data/repositories/UserRepository.dart';

class GetUserTestUseCase {
  final UserRepository userRepository;

  GetUserTestUseCase({required this.userRepository});

  Future<UserTest?> invoke(String userId, String testId) {
    return userRepository.getUserTest(userId, testId);
  }
}
