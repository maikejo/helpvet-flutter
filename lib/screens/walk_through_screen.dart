import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_finey/screens/walk_through_widgets/rectangle_button.dart';
import '../config/application.dart';
import '../config/routes.dart';
import './common_widgets/finey_header.dart';
import './common_widgets/responsive_padding.dart';
import './common_widgets/responsive_container.dart';
import './walk_through_widgets/page_indicator.dart';
import '../styles/common_variables.dart';
import '../styles/common_colors.dart';

class WalkThroughScreen extends StatefulWidget {
  WalkThroughScreen({Key key, this.title, this.text}) : super(key: key);

  final String title;
  final String text;

  @override
  _WalkThroughScreenState createState() => new _WalkThroughScreenState();
}

class PageModel {
  final String title;
  final String text;
  final String assetImagePath;

  PageModel({this.title, this.assetImagePath, this.text});
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController _pageController;
  CrossFadeState _bottomState = CrossFadeState.showFirst;

  String title = "Help Vet";
  String text = "Todas informações de seu pet de forma simples e bonita";

  List<PageModel> pages = [
    PageModel(
      title: 'Localização de seu pet',
      assetImagePath: 'images/icons/ic_location_pet.png',
      text: 'Informe a localização do seu pet, veja as clínicas próximas de seu animal.',
    ),
    PageModel(
      title: 'Chat com seu veterinario',
      assetImagePath: 'images/icons/ic_chat_pet.png',
      text:
          'Converse com seu veterinário online.',
    ),
    PageModel(
        title: 'Laudo Médico de seu animal',
        assetImagePath: 'images/ic_vet.png',
        text: 'Tenha o historico de consultas de seu pet.'),
  ];

  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
  }

  void _pageListener() {
    if (_pageController.hasClients) {
      double page = _pageController.page ?? _pageController.initialPage;
      int index = page.toInt();
      setState(() {
        title = pages[index].title;
        text = pages[index].text;
        // _bottomState = CrossFadeState.showFirst;
      });
    }
  }

  Widget _buildIndicators(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            itemBuilder: (BuildContext context, int index) {
              return ResponsivePadding(
                  padding: const EdgeInsets.only(top: 150.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(pages[index].assetImagePath, width: 178.0),
                      ]));
            }),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 50.0,
            alignment: Alignment.center,
            child: AnimatedCrossFade(
              crossFadeState: _bottomState,
              duration: Duration(milliseconds: 300),
              firstChild: PageIndicators(
                pageController: _pageController,
              ),
              secondChild: PageIndicators(
                pageController: _pageController,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWithConstraints(
      BuildContext context, BoxConstraints constraints) {
    var column = new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          FineyHeader(
              noShadow: true,
              rightTextButton: "Pular",
              onPressRightButton: () {
                Application.router.navigateTo(
                    context, RouteConstants.ROUTE_LOGIN,
                    clearStack: true,
                    replace: true,
                    transition: TransitionType.fadeIn);
              }),
          Expanded(child: _buildIndicators(context)),
          ResponsiveContainer(
              width: MediaQuery.of(context).size.width,
              height: 220.0,
              decoration: const BoxDecoration(
                  color: Colors.pinkAccent,
                  boxShadow: [
                    const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12.0,
                        offset: Offset(0.0, 5.0))
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0))),
              child: ResponsivePadding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 32.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(this.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.0,
                                fontFamily: CommonVariables.defaultFont,
                                fontWeight: FontWeight.normal)),
                        ResponsivePadding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(this.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: CommonColors.lightWhite,
                                    fontSize: CommonVariables(context: context)
                                        .getNormalFontSize(),
                                    fontFamily: CommonVariables.defaultFont,
                                    fontWeight: FontWeight.normal))),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            RectangleButtonWalkWidget(
                                isFullWidth: true,
                                bgColor: Colors.white,
                                textColor: CommonColors.black,
                                text: "COMECE AGORA!",
                                btnWidth: CommonVariables.defaultBtnWidth,
                                btnHeight: CommonVariables.defaultBtnHeight,
                                onPressed: () {
                                  Application.router.navigateTo(
                                      context, RouteConstants.ROUTE_LOGIN,
                                      clearStack: true,
                                      replace: true,
                                      transition: TransitionType.fadeIn);
                                })
                          ],
                        ))
                      ])))
        ]);

    var constrainedBox = new ConstrainedBox(
      constraints: constraints.copyWith(maxHeight: MediaQuery.of(context).size.height),
      child: new Container(color: Colors.white, child: column),
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
