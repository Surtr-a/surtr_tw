import 'package:surtr_tw/repositories/local_login_model_repository.dart';

class LoginProvider {
  bool isLogin() {
    return LocalLoginModelRepository.getCurrentLoginModel() != null;
  }
}