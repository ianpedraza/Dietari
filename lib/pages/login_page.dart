import 'package:dietari/components/MainButton.dart';
import 'package:dietari/components/MainTextField.dart';
import 'package:dietari/components/ShowAlertDialog.dart';
import 'package:dietari/components/SingButton.dart';
import 'package:dietari/data/domain/ExternalUser.dart';
import 'package:dietari/data/domain/User.dart';
import 'package:dietari/data/usecases/GetUserIdUseCase.dart';
import 'package:dietari/data/usecases/GetUserUseCase.dart';
import 'package:dietari/data/usecases/SendPasswordResetEmailUseCase.dart';
import 'package:dietari/data/usecases/SignInWithGoogleUseCase.dart';
import 'package:dietari/data/usecases/SignInWithEmailUseCase.dart';
import 'package:dietari/utils/arguments.dart';
import 'package:dietari/utils/colors.dart';
import 'package:dietari/utils/resources.dart';
import 'package:dietari/utils/routes.dart';
import 'package:dietari/utils/strings.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:injector/injector.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _signInWithGoogleUseCase = Injector.appInstance.get<SignInWithGoogleUseCase>();
  final _signInWithEmailUseCase = Injector.appInstance.get<SignInWithEmailUseCase>();
  final _sendPasswordResetEmailUseCase = Injector.appInstance.get<SendPasswordResetEmailUseCase>();
  final _getUserIdUseCase = Injector.appInstance.get<GetUserIdUseCase>();
  final _getUserUseCase = Injector.appInstance.get<GetUserUseCase>();
  
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  User newUser = User(
    id: "",
    firstName: "",
    lastName: "",
    email: "",
    dateOfBirth: "",
    weight: 0.0,
    height: 0.0,
    imc: 0.0,
    status: "",
    tips: [],
  );

  bool active = true;
  String? _userId;
  
  @override
  void initState() {
    super.initState();
    _userId = _getUserIdUseCase.invoke();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _isLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => exit(0),
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 70, top: 20, right: 70, bottom: 10),
              child: Image.asset(image_logo),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 30, top: 20, right: 30, bottom: 10),
              child: MainTextField(
                onTap: _showPassword,
                text: textfield_email,
                isPassword: false,
                isPasswordTextStatus: false,
                textEditingControl: _emailController,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 30, top: 10, right: 30, bottom: 10),
              child: MainTextField(
                onTap: _showPassword,
                text: textfield_password,
                isPassword: true,
                isPasswordTextStatus: active,
                textEditingControl: _passwordController,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 30, top: 10, right: 30, bottom: 10),
              child: MainButton(
                onPressed: () {
                  _loginWithEmail();
                },
                text: button_login,
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 0),
              child: TextButton(
                onPressed: () {
                  _showDialogResetPassword(context);
                },
                child: Text(
                  text_forget_password,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 30, top: 0, right: 30, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    text_havent_account,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _nextScreen(base_register_1_route, newUser);
                    },
                    child: Text(
                      text_registry,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15,
                      ),
                    ),
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 30, top: 5, right: 30, bottom: 10),
              child: SingButton(
                onPressed: () {
                  _loginWithGoogle();
                },
                text: button_login_google,
                rute: image_login_google,
                textColor: Colors.blueAccent,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: 30, top: 20, right: 30, bottom: 40),
              child: RichText(
                text: TextSpan(
                  text: text_message,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: text_tems_conditions,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: text_message_continuation,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: text_privacy_policies,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _isLogin() {
    _userRegistered(_userId!).then(
      (user) => user != null ? _nextScreen(home_route, user) : () {},
    );
  }

  void _showPassword() {
    setState(() {
      active = !active;
    });
  }

  User _saveGoogleUser(ExternalUser googleUser) {
    String text = googleUser.displayName.toString();
    List<String> fullName = text.split(' ');
    if (fullName.length == 1) {
      newUser.firstName = fullName.single;
    } else {
      if (fullName.length == 2) {
        newUser.firstName = fullName.first;
        newUser.lastName = fullName.last;
      }
      if (fullName.length == 3) {
        newUser.firstName = fullName.first;
        newUser.lastName = fullName.sublist(1, fullName.length).join(' ');
      }
      if (fullName.length >= 4) {
        newUser.firstName = fullName.sublist(0, 1).join(' ');
        newUser.lastName = fullName.sublist(2, fullName.length).join(' ');
      }
    }
    newUser.id = googleUser.uid;
    newUser.email = googleUser.email.toString();
    return newUser;
  }

  void _nextScreen(String route, User user) {
    final args = {user_args: user};
    Navigator.pushNamed(context, route, arguments: args);
  }

  void _loginWithEmail() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      if (EmailValidator.validate(_emailController.text)) {
        _signInWithEmail(_emailController.text.toString(),
                _passwordController.text.toString())
            .then(
          (userId) => userId != null
              ? _userRegistered(userId).then(
                  (usered) => usered != null
                      ? _nextScreen(home_route, usered)
                      : _showAlertDialog(context, alert_title_error,
                          alert_content_not_registered),
                )
              : _showAlertDialog(
                  context, alert_title_error, alert_content_incorrect),
        );
      } else {
        _showAlertDialog(
            context, alert_title_error, alert_content_not_valid_email);
      }
    } else {
      _showAlertDialog(
          context, alert_title_error, alert_content_email_password);
    }
  }

  void _loginWithGoogle() {
    _signInWithGoogle().then((googleUser) => googleUser != null
        ? _userRegistered(googleUser.uid).then(
            (usered) => usered != null
                ? _nextScreen(home_route, usered)
                : _nextScreen(
                    base_register_2_route, _saveGoogleUser(googleUser)),
          )
        : _showAlertDialog(
            context, alert_title_error, alert_content_error_login_google));
  }

  void _sendEmailResetPassword(TextEditingController emailController) {
    if (emailController.text.isNotEmpty) {
      if (EmailValidator.validate(emailController.text)) {
        _sendPasswordResetEmail(emailController.text).then((value) => value
            ? _showToast(alert_title_send_email)
            : _showToast(alert_title_error_not_registered));
      } else {
        _showAlertDialog(
            context, alert_title_error, alert_content_not_valid_email);
      }
    } else {
      _showAlertDialog(context, alert_title_error, alert_content_email);
    }
  }

  void _showToast(String content) {
    final snackBar = SnackBar(
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showAlertDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowAlertDialog(
          title: title,
          content: content,
        );
      },
    );
  }

  void _showDialogResetPassword(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            alert_title_reset,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          content: MainTextField(
            text: textfield_email,
            isPassword: false,
            textEditingControl: emailController,
            isPasswordTextStatus: false,
            onTap: _showPassword,
          ),
          actions: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      button_cancel,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _sendEmailResetPassword(emailController);
                    },
                    child: Text(
                      button_reset,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<ExternalUser?> _signInWithGoogle() async {
    ExternalUser? googleUser = await _signInWithGoogleUseCase.invoke();
    return googleUser;
  }

  Future<User?> _userRegistered(String id) async {
    User? user = await _getUserUseCase.invoke(id);
    return user;
  }

  Future<String?> _signInWithEmail(String email, String password) async {
    String? user = await _signInWithEmailUseCase.invoke(email, password);
    return user;
  }

  Future<bool> _sendPasswordResetEmail(String email) async {
    bool reset = await _sendPasswordResetEmailUseCase.invoke(email);
    return reset;
  }
}
