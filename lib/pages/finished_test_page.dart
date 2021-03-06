import 'package:dietari/components/MainButton.dart';
import 'package:dietari/data/domain/User.dart';
import 'package:dietari/data/usecases/GetUserIdUseCase.dart';
import 'package:dietari/data/usecases/GetUserUseCase.dart';
import 'package:dietari/utils/arguments.dart';
import 'package:dietari/utils/colors.dart';
import 'package:dietari/utils/icons.dart';
import 'package:dietari/utils/routes.dart';
import 'package:dietari/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class FinishedTestPage extends StatefulWidget {
  FinishedTestPage({Key? key}) : super(key: key);

  @override
  _FinishedTestPageState createState() => _FinishedTestPageState();
}

class _FinishedTestPageState extends State<FinishedTestPage> {
  final _getUserUseCase = Injector.appInstance.get<GetUserUseCase>();
  final _getUserIdUseCase = Injector.appInstance.get<GetUserIdUseCase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorFinishedTestPage,
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              left: 100,
              top: MediaQuery.of(context).size.height / 3,
              right: 100,
              bottom: 100,
            ),
            child: Transform.scale(
              scale: 7,
              alignment: Alignment.center,
              child: getIcon(
                AppIcons.clock,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            child: Text(
              text_congratulations,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: colorTextMainButton,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              text_finished_test,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: colorTextMainButton,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, top: 120, right: 20, bottom: 30),
            child: MainButton(
              onPressed: _nextScreen,
              text: button_accept,
            ),
          ),
        ],
      ),
    );
  }

  void _nextScreen() {
    var args;
    String? userId = _getUserIdUseCase.invoke();
    if (userId != null) {
      _getUser(userId).then(
        (user) => {
          if (user != null)
            {
              args = {user_args: user},
              Navigator.pushNamed(context, home_route, arguments: args),
            }
        },
      );
    }
  }

  Future<User?> _getUser(String id) async {
    User? user = await _getUserUseCase.invoke(id);
    return user;
  }
}
