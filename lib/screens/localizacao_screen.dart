import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/helper/map_helper.dart';
import 'package:flutter_finey/helper/ui_helper.dart';
import 'package:flutter_finey/main.dart';
import 'package:flutter_finey/model/localizacao_pet.dart';
import 'package:flutter_finey/service/BackgroundNotification.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/service/google_maps_requests.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
//import 'package:location/location.dart';
import 'localizacao_widgets/explore_content_widget.dart';
import 'localizacao_widgets/explore_widget.dart';
import 'localizacao_widgets/localizacao_state.dart';
import 'localizacao_widgets/map_button.dart';
import 'localizacao_widgets/menu_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:ui' as ui show Image;
import 'dart:ui' as uia;
import 'dart:typed_data';
import 'dart:ui';




class LocalizacaoScreen extends StatefulWidget {

  @override
  _LocalizacaoScreenState createState() => new _LocalizacaoScreenState();
}

class _LocalizacaoScreenState extends State<LocalizacaoScreen> with TickerProviderStateMixin {
  AnimationController animationControllerExplore;
  AnimationController animationControllerSearch;
  AnimationController animationControllerMenu;
  CurvedAnimation curve;
  Animation<double> animation;
  Animation<double> animationW;
  Animation<double> animationR;

  /// get currentOffset percent
  get currentExplorePercent => max(0.0, min(1.0, offsetExplore / (760.0 - 122.0)));
  get currentSearchPercent => max(0.0, min(1.0, offsetSearch / (347 - 68.0)));
  get currentMenuPercent => max(0.0, min(1.0, offsetMenu / 358));

  var offsetExplore = 0.0;
  var offsetSearch = 0.0;
  var offsetMenu = 0.0;

  bool isExploreOpen = false;
  bool isSearchOpen = false;
  bool isMenuOpen = false;

  Completer<GoogleMapController> _controller = Completer();
  Map<String, double> userLocation;
  bool mapToggle = false;
  Position location = Position();
  Position _currentPosition;
  Marker marker;
  GoogleMapController mapController;
  LatLng centerPosition;
  Stream<List<DocumentSnapshot>> stream;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;

  CameraPosition cameraPosition;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  GoogleMapsServices get googleMapsServices => _googleMapsServices;
  final Set<Polyline> _polyLines = {};
  Set<Polyline> get polyLines => _polyLines;
  final Set<Marker> _markers2 = {};
  Set<Marker> get markers2 => _markers2;

  List<Marker> allMarker = [];
  Geoflutterfire geo;
  var radius = BehaviorSubject<double>.seeded(1.0);
  Firestore _firestore = Firestore.instance;
  StreamSubscription _locationSubscription;
  TextEditingController destinationController = TextEditingController();

  bool _permission = false;
  String error;

  Position _previousPosition;
  StreamSubscription<Position> _positionStream;
  double _totalDistance = 0;
  double _distancia_percorrida = null;

  List<Position> locations = List<Position>();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Geolocator geolocator = Geolocator();

  Position userLocation2;

  Position _position;
  GoogleMapController _controller2;
  LocalizacaoPet _localizacaoPet;

  final oCcy = new NumberFormat("#,##0.00", "pt_BR");

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-16.0258844, -48.0721724),
    zoom: 11.0,
  );

  static const fetchBackground = "fetchBackground";

  static const String TAG = "BackGround_Work";
  int _counterValue = 0;

  @override
  void initState() {
    super.initState();


    WidgetsFlutterBinding.ensureInitialized();
    Workmanager.initialize(
        callbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode: false // This should be false
    );

    Workmanager.registerPeriodicTask(
      TAG,
      "simplePeriodicTask",
      initialDelay: Duration(seconds: 10),
    );
    loalData();

    _getCurrentLocation();
    _clinicasMarkers();
    geo = Geoflutterfire();
    GeoFirePoint center = geo.point(latitude: 12.960632, longitude: 77.641603);
    stream = radius.switchMap((rad) {
      var collectionReference = _firestore.collection('clinicas');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    });
  }

  void loalData() async {
    _counterValue =
    await BackGroundWork.instance._getBackGroundCounterValue();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addReward(Position _currentPosition, double distancia_percorrida) async {
   if(distancia_percorrida >= 100){
     double recompensa = distancia_percorrida * 0.001 / 100;
     final currencyFormatter = NumberFormat('#,##0.000');

     LocalizacaoPet localizacaoPet = new LocalizacaoPet(distancia_percorrida: distancia_percorrida, recompensa: currencyFormatter.format(recompensa), localizacao_inicial: new GeoPoint(_currentPosition.latitude, _currentPosition.longitude));
     Firestore.instance.document("localizacao_pet/${Auth.user.email}")
         .setData(localizacaoPet.toJson());
   }
  }

   Future<LocalizacaoPet> getLocalizacaoPet(String email) async{
    DocumentSnapshot snapshot = await Firestore.instance.collection('localizacao_pet').document(email).get();

    if (snapshot.data != null) {
      var distanciaPercorrida = snapshot['distancia_percorrida'];
      var recompensa = snapshot['recompensa'];

      LocalizacaoPet localizacao_pet = new LocalizacaoPet(
          distancia_percorrida: distanciaPercorrida,
          recompensa: recompensa
      );

      _localizacaoPet = localizacao_pet;

      return localizacao_pet;
    } else {
      return null;
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    //setState(() {
      _controller2 = controller;
      mapController = controller;
    // });
  }


  void _redirectLocalizacaoPetScreen() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_LOCALIZACAO_PET, transition: TransitionType.inFromBottom);
  }

  void _addMarker(double lat, double lng,String nomeClinica,String endereco,String imagem) async {
    BitmapDescriptor markerImage = await MapHelper.getMarkerImageFromUrl(imagem,targetWidth: 150,targetHeight: 150);

    MarkerId id = MarkerId(lat.toString() + lng.toString());
    marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: markerImage,
      //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: nomeClinica, snippet: endereco),
    );
    setState(() {
      markers[id] = marker;
    });
  }

  void _addMarkerPet(double lat, double lng,String nomeClinica,String endereco) async {
    Uint8List imageData = await getMarkerPet();

    MarkerId id = MarkerId('pet');
    marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: BitmapDescriptor.fromBytes(imageData),
      infoWindow: InfoWindow(title: nomeClinica, snippet: endereco),
    );
    setState(() {
      markers[id] = marker;
    });
  }

  void _clinicasMarkers() {
    Firestore.instance.collection('clinicas').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          for (int i = 0; i < docs.documents.length; ++i) {
            GeoPoint point = docs.documents[i].data['position']['geopoint'];
            _addMarker(point.latitude, point.longitude,docs.documents[i].data['nome'],docs.documents[i].data['endereco'],docs.documents[i].data['imagemUrl']);
          }
        });
      }
    });
  }

  Future<Uint8List> getMarkerPet() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("images/icons/ic_track_pet.png");
    return byteData.buffer.asUint8List();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    await Permission.location.request();

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getCurrentLocation() async {
    _currentPosition = await _determinePosition();

   Geolocator.getPositionStream().listen((Position position) {
     _currentPosition = position;
     locations.add(_currentPosition);

      if (_currentPosition != null) {
        if (mapController != null) {
          mapController.animateCamera(
              CameraUpdate.newCameraPosition(new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(
                      _currentPosition.latitude, _currentPosition.longitude),
                  tilt: 0,
                  zoom: 18.00)));

          _addMarkerPet(
              _currentPosition.latitude, _currentPosition.longitude, 'Meu Pet',
              'Localização coleira gps');
        }
      }

      if (locations.length > 1) {
        _previousPosition = locations.elementAt(locations.length - 2);

        var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
          _previousPosition.latitude,
          _previousPosition.longitude,
          _currentPosition.latitude,
          _currentPosition.longitude,
        );
        _totalDistance += _distanceBetweenLastTwoLocations;
        print('Total Distance: $_totalDistance');
        getLocalizacaoPet(Auth.user.email);

        double totalDistancia =  _localizacaoPet.distancia_percorrida + _totalDistance;

        addReward(_currentPosition, totalDistancia);
      }
    });


  }

  /// explore drag callback
  void onExploreVerticalUpdate(details) {
    offsetExplore -= details.delta.dy;
    if (offsetExplore > 644) {
      offsetExplore = 644;
    } else if (offsetExplore < 0) {
      offsetExplore = 0;
    }
    setState(() {});
  }

  void animateExplore(bool open) {
    animationControllerExplore = AnimationController(
        duration: Duration(
            milliseconds: 1 +
                (800 *
                    (isExploreOpen
                        ? currentExplorePercent
                        : (1 - currentExplorePercent)))
                    .toInt()),
        vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerExplore, curve: Curves.ease);
    animation = Tween(begin: offsetExplore, end: open ? 760.0 - 122 : 0.0)
        .animate(curve)
      ..addListener(() {
        setState(() {
          offsetExplore = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isExploreOpen = open;
        }
      });
    animationControllerExplore.forward();
  }

  void animateMenu(bool open) {
    animationControllerMenu =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    curve =
        CurvedAnimation(parent: animationControllerMenu, curve: Curves.ease);
    animation =
    Tween(begin: open ? 0.0 : 358.0, end: open ? 358.0 : 0.0).animate(curve)
      ..addListener(() {
        setState(() {
          offsetMenu = animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isMenuOpen = open;
        }
      });
    animationControllerMenu.forward();
  }

  LocalizacaoState _localizacaoState = new LocalizacaoState();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          title: Text("Localização"),
          backgroundColor: Colors.pinkAccent
      ),

      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: _kInitialPosition,
                        //myLocationEnabled: true,
                        markers: Set<Marker>.from(markers.values),
                        //polylines: _localizacaoState.polyLines,

                      ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 60),
              child: Row(
                children: <Widget>[
                  SizedBox(width: 16),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                          "images/icons/ic_location_pet.png", fit: BoxFit.contain,
                          width: 40),
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    alignment: Alignment.center,
                    width: 160,
                    height: 22,
                    decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.all(
                            Radius.circular(18))
                    ),
                    child: FutureBuilder(
                          future: getLocalizacaoPet(Auth.user.email),
                          builder: (BuildContext context, AsyncSnapshot<LocalizacaoPet> snapshot) {
                          if (snapshot.data != null) {
                           double totalDistance =  snapshot.data.distancia_percorrida + _totalDistance;

                           return  Text('Distancia: ${totalDistance != null ? totalDistance > 1000 ? (totalDistance / 1000).toStringAsFixed(2)
                                : totalDistance.toStringAsFixed(2) : 0} '
                                '${totalDistance != null ? totalDistance > 1000 ? 'KM' : 'M' : 0}', style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white));
                          }else{
                              return Text('Distancia: 0.00 HVT', style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white));
                              }
                          })
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 120),
              child: Row(
                children: <Widget>[
              
                  SizedBox(width: 16),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                          "images/ic_pet.png", fit: BoxFit.contain,
                          width: 40),
                    ),
                  ),
                  SizedBox(width: 4),
                  Container(
                    alignment: Alignment.center,
                    width: 135,
                    height: 22,
                    decoration: BoxDecoration(
                        color: Colors.pinkAccent,
                        borderRadius: BorderRadius.all(
                            Radius.circular(18))
                    ),
                    //margin: EdgeInsets.symmetric(horizontal: 72),
                    child: FutureBuilder(
                        future: getLocalizacaoPet(Auth.user.email),
                        builder: (BuildContext context, AsyncSnapshot<LocalizacaoPet> snapshot) {
                          if (snapshot.data != null) {
                                return Text('Ganhos: ${snapshot.data.recompensa} HVT ', style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.white)
                                );

                          } else {
                            return Text('Ganhos: 0.00 HVT', style: TextStyle(
                            fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.white));
                          }
                        }),
                  ),

                ],
              ),
            ),

            ExploreWidget(
              currentExplorePercent: currentExplorePercent,
              currentSearchPercent: currentSearchPercent,
              animateExplore: animateExplore,
              isExploreOpen: isExploreOpen,
              onVerticalDragUpdate: onExploreVerticalUpdate,
              onPanDown: () => animationControllerExplore?.stop(),
            ),

            ExploreContentWidget(
              currentExplorePercent: currentExplorePercent,
            ),

            //directions button
            /* MapButton(
              currentSearchPercent: currentSearchPercent,
              currentExplorePercent: currentExplorePercent,
              bottom: 243,
              offsetX: -68,
              width: 68,
              height: 71,
              icon: Icons.directions,
              iconColor: Colors.white,
              gradient: const LinearGradient(colors: [
                Color(0xFF59C2FF),
                Color(0xFF1270E3),
              ]),
              onPanDown: _redirectLocalizacaoPetScreen,
            ),*/


            MapButton(
              currentSearchPercent: currentSearchPercent,
              currentExplorePercent: currentExplorePercent,
              bottom: 148,
              offsetX: -68,
              width: 68,
              height: 71,
              icon: Icons.play_circle_fill,
              iconColor: Colors.pinkAccent,
              onPanDown: null,
            ),
            MenuWidget(
                currentMenuPercent: currentMenuPercent,
                animateMenu: animateMenu),


          ],
        ),
      ),
    );
  }



}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    //print(TAG + "callbackDispatcher");
    int value =
    await BackGroundWork.instance._getBackGroundCounterValue();
    BackGroundWork.instance._loadCounterValue(value + 1);
    return Future.value(true);
  });
}

class BackGroundWork {
  BackGroundWork._privateConstructor();

  static final BackGroundWork _instance =
  BackGroundWork._privateConstructor();

  static BackGroundWork get instance => _instance;

  _loadCounterValue(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('BackGroundCounterValue', value);
  }

  Future<int> _getBackGroundCounterValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    int counterValue = prefs.getInt('BackGroundCounterValue') ?? 0;
    return counterValue;
  }
}
