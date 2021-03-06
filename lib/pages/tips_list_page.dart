import 'package:dietari/components/AppBarComponent.dart';
import 'package:dietari/components/TipComponent.dart';
import 'package:dietari/data/domain/Tip.dart';
import 'package:dietari/data/usecases/GetUserIdUseCase.dart';
import 'package:dietari/data/usecases/GetUserTipsUseCase.dart';
import 'package:dietari/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class TipsListPage extends StatefulWidget {
  TipsListPage({Key? key}) : super(key: key);

  @override
  _TipsListPageState createState() => _TipsListPageState();
}

class _TipsListPageState extends State<TipsListPage> {
  final _getUserTipsUseCase = Injector.appInstance.get<GetUserTipsUseCase>();
  final _getUserIdUseCase = Injector.appInstance.get<GetUserIdUseCase>();

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _fetchTips();
    });

    super.initState();
  }

  Stream<List<Tip>>? _fetchTips() {
    final userId = _getUserIdUseCase.invoke();

    if (userId == null) {
      return null;
    }

    return _getUserTipsUseCase.invoke(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBarComponent(
          textAppBar: tips_list,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        body: StreamBuilder<List<Tip>>(
          stream: _fetchTips(),
          builder: (context, data) {
            if (data.hasData) {
              return _component(data.data!);
            }

            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ));
  }

  Widget _component(List<Tip> tips) {
    return ListView.builder(
      itemCount: tips.length,
      itemBuilder: (contex, index) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: TipComponent(
            tip: tips[index],
          ),
        );
      },
    );
  }
}
