import 'package:flutter/material.dart';

class PremiumAccountScreen extends StatefulWidget {
  PremiumAccountScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PremiumAccountScreenState createState() => new _PremiumAccountScreenState();
}

class _PremiumAccountScreenState extends State<PremiumAccountScreen> {
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
        child: column,
      ),
    );

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
