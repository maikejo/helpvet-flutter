import 'package:flutter/material.dart';

// import '../config/application.dart';
// import '../config/routes.dart';
import '../styles/common_variables.dart';

class ProfileGuestScreen extends StatefulWidget {
  ProfileGuestScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfileGuestScreenState createState() => new _ProfileGuestScreenState();
}

class _ProfileGuestScreenState extends State<ProfileGuestScreen> {
  Widget _buildWithConstraints(
      BuildContext context, BoxConstraints constraints) {
    var column = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(padding: const EdgeInsets.only(top: 12.0), child: Container())
        ]);

    var constrainedBox = new ConstrainedBox(
        constraints:
            constraints.copyWith(maxHeight: MediaQuery.of(context).size.height),
        child: new Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                bottom:
                    CommonVariables(context: context).getScreenPaddingBottom()),
            child: column));

    var scrollView = new SingleChildScrollView(child: constrainedBox);

    return scrollView;
  }

  @override
  Widget build(BuildContext context) {
    var layoutBuilder = new LayoutBuilder(builder: _buildWithConstraints);

    var scaffold = new Scaffold(body: layoutBuilder);

    return scaffold;
  }
}
