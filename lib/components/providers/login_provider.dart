import 'package:surtr_tw/repositories/local_login_model_reposity.dart';

class LoginProvider {
  bool isLogin() {
    return LocalLoginModelRepository.getCurrentLoginModel() != null;
  }
}