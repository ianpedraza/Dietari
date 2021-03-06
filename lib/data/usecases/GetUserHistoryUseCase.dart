import 'package:dietari/data/domain/HistoryItem.dart';
import 'package:dietari/data/repositories/UserRepository.dart';

class GetUserHistoryUseCase {
  UserRepository userRepository;

  GetUserHistoryUseCase({required this.userRepository});

  Stream<List<HistoryItem>> invoke(String userId) {
    return userRepository.getHistory(userId);
  }
}
