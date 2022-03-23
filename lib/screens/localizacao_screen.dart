import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_finey/config/application.dart';
import 'package:flutter_finey/config/routes.dart';
import 'package:flutter_finey/helper/map_helper.dart';
import 'package:flutter_finey/helper/ui_helper.dart';
import 'package:flutter_finey/main.dart';
import 'package:flutter_finey/model/localizacao_pet.dart';
import 'package:flutter_finey/model/user.dart';
import 'package:flutter_finey/service/BackgroundNotification.dart';
import 'package:flutter_finey/service/auth.dart';
import 'package:flutter_finey/service/google_maps_requests.dart';
import 'package:flutter_finey/util/file_manager.dart';
import 'package:flutter_finey/util/location_callback_handler.dart';
import 'package:flutter_finey/util/location_service_repository.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:workmanager/workmanager.dart';
//import 'package:location/location.dart';
import 'localizacao_widgets/explore_content_widget.dart';
import 'localizacao_widgets/explore_widget.dart';
import 'localizacao_widgets/localizacao_state.dart';
import 'localizacao_widgets/map_button.dart';
import 'localizacao_widgets/menu_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:ui' as ui show Image;
import 'dart:ui' as uia;
import 'dart:ui';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart' as locateSettings;
import 'package:background_locator/settings/android_settings.dart';
import 'package:location_permissions/location_permissions.dart' as permissionSettings;
import 'package:image/image.dart' as im;

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

  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyAa_8v6xQL2wdkxZ8zk5iQu6N963ep5byw";

  List<Position> locations = List<Position>();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Geolocator geolocator = Geolocator();

  Position userLocation2;

  Position _position;
  static Position _currentPositionDb;
  GoogleMapController _controller2;
  LocalizacaoPet _localizacaoPet;
  static var httpClient = new HttpClient();
  final oCcy = new NumberFormat("#,##0.00", "pt_BR");

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-16.0258844, -48.0721724),
    zoom: 11.0,
  );

  ReceivePort port = ReceivePort();

  String logStr = '';
  bool isRunning;
  LocationDto lastLocation;

  bool isPlay = false;
  Stopwatch _stopwatch;
  User usuario;

  double valorRecompensa;
  int distanciaRecompensa;

  @override
  void initState() {
    super.initState();
    _dadosUsuario();
    retornaValorRecompensa();

    _stopwatch = Stopwatch();

    if (IsolateNameServer.lookupPortByName(
        LocationServiceRepository.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(
          LocationServiceRepository.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, LocationServiceRepository.isolateName);

    port.listen(
          (dynamic data) async {
        await updateUI(data);
      },
    );
    initPlatformState();

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

  void _onMapCreated(GoogleMapController controller) {
    _controller2 = controller;
    mapController = controller;
  }

  void handleStartStop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }
    setState(() {});    // re-render the page
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> updateUI(LocationDto data) async {
    final log = await FileManager.readLogFile();

    await _updateNotificationText(data);

    setState(() {
      if (data != null) {
        lastLocation = data;
      }
      logStr = log;
    });
  }

  Future<void> _updateNotificationText(LocationDto data) async {
    if (data == null) {
      return;
    }

    await BackgroundLocator.updateNotificationText(
        title: "Sua localização",
        msg: "${DateTime.now()}",
        bigMsg: "${data.latitude}, ${data.longitude}");
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
    await BackgroundLocator.initialize();
    logStr = await FileManager.readLogFile();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
    });
    print('Running ${isRunning.toString()}');
  }

  void onStop() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    final _isRunning = await BackgroundLocator.isServiceRunning();
    setState(() {
      isRunning = _isRunning;
      isPlay = false;
      _stopwatch.stop();
      _locationSubscription?.pause();
    });
  }

  void _onStart() async {
    if (await _checkLocationPermission()) {
      await _startLocator();
      final _isRunning = await BackgroundLocator.isServiceRunning();

      setState(() {
        isRunning = _isRunning;
        lastLocation = null;
        isPlay = true;
        _stopwatch.start();
        _locationSubscription?.resume();
        updateLocalizacaoInicial(_currentPosition);

      });
    } else {
      // show error
    }
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case permissionSettings.PermissionStatus.unknown:
      case permissionSettings.PermissionStatus.denied:
      case permissionSettings.PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == permissionSettings.PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
        break;
      case permissionSettings.PermissionStatus.granted:
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  Future<void> _startLocator() async{
    Map<String, dynamic> data = {'countInit': 1};
    return await BackgroundLocator.registerLocationUpdate(LocationCallbackHandler.callback,
        initCallback: LocationCallbackHandler.initCallback,
        initDataCallback: data,
        disposeCallback: LocationCallbackHandler.disposeCallback,
        iosSettings: IOSSettings(
            accuracy: locateSettings.LocationAccuracy.NAVIGATION, distanceFilter: 0),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: locateSettings.LocationAccuracy.NAVIGATION,
            interval: 5,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                LocationCallbackHandler.notificationCallback)));
  }

  void _dadosUsuario() async{
    User user = await Auth.getDadosUser(Auth.user.email);
    setState(() {
      usuario = user;
    });
  }

  static void updateLocalizacaoInicial(Position _currentPosition) async {
    _currentPositionDb = _currentPosition;
    Firestore.instance.collection('localizacao_pet').document(Auth.user.email).updateData({'localizacao_inicial': new GeoPoint(_currentPositionDb.latitude, _currentPositionDb.longitude)});
  }

  void retornaValorRecompensa() async{
    Stream<QuerySnapshot> valor =  Firestore.instance.collection('recompensa').snapshots();
    valor.listen((onData){
      onData.documents.forEach((doc) {

        List<DocumentSnapshot> listaRecompensa = onData.documents;
        for (var lista in listaRecompensa) {
           valorRecompensa = lista.data["valor"];
           distanciaRecompensa = lista.data["distancia"];
        }

      });
    });

  }

  void addReward(Position _currentPosition, double distancia_percorrida) async {
    if(valorRecompensa != null && distanciaRecompensa != null){
      if(distancia_percorrida >= distanciaRecompensa && isPlay){
        double recompensa = distancia_percorrida * valorRecompensa / 100;
        final currencyFormatter = NumberFormat('#,##0.000');

        LocalizacaoPet localizacaoPet = new LocalizacaoPet(distancia_percorrida: distancia_percorrida, recompensa: currencyFormatter.format(recompensa) , localizacao_inicial:  new GeoPoint(_currentPositionDb.latitude, _currentPositionDb.longitude));
        Firestore.instance.document("localizacao_pet/${Auth.user.email}")
            .setData(localizacaoPet.toJson());
      }
    }
  }

  Future<LocalizacaoPet> getLocalizacaoPet(String email) async{
    DocumentSnapshot snapshot = await Firestore.instance.collection('localizacao_pet').document(email).get();

    if (snapshot.data != null) {
      var distanciaPercorrida = snapshot['distancia_percorrida'];
      var recompensa = snapshot['recompensa'];
      var localizacao_inicial = snapshot['distancia_inicial'];

      LocalizacaoPet localizacao_pet = new LocalizacaoPet(
          distancia_percorrida: distanciaPercorrida,
          recompensa: recompensa, localizacao_inicial: localizacao_inicial
      );

      _localizacaoPet = localizacao_pet;

      return localizacao_pet;
    } else {
      return null;
    }
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
      icon: await getMarkerIcon(usuario.imagemUrl, Size(150.0, 150.0)),
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

     _locationSubscription = Geolocator.getPositionStream(desiredAccuracy: LocationAccuracy.best).listen((Position position) {
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
        getDirections(_previousPosition, _currentPosition);
        addReward(_currentPosition, totalDistancia);
      }
    });

  }

  getDirections(Position previousPosition, Position currentPossition) async {
    List<LatLng> polylineCoordinates = [];

    if(isPlay){
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(_currentPositionDb.latitude, _currentPositionDb.longitude),
        PointLatLng(currentPossition.latitude, currentPossition.longitude),
        travelMode: TravelMode.walking,
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }
      addPolyLine(polylineCoordinates);
    }

  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 6,
    );
    polylines[id] = polyline;
    setState(() {});
  }

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
                        zoomControlsEnabled: false,
                        initialCameraPosition: _kInitialPosition,
                        //myLocationEnabled: true,
                        markers: Set<Marker>.from(markers.values),
                        polylines: Set<Polyline>.of(polylines.values),

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
                    width: 150,
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

            MapButton(
              currentSearchPercent: currentSearchPercent,
              currentExplorePercent: currentExplorePercent,
              bottom: 148,
              offsetX: -68,
              width: 110,
              height: 71,
              icon: isPlay == false ? Icons.play_circle_fill : Icons.pause_circle_filled,
              iconColor: Colors.pinkAccent,
              onPanDown: isPlay == false ? _onStart : onStop,
              text: Text(formatTime(_stopwatch.elapsedMilliseconds), style: TextStyle(fontSize: 18.0)),
            ),
            MenuWidget(
                currentMenuPercent: currentMenuPercent,
                animateMenu: animateMenu),


          ],
        ),
      ),
    );
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    final double tagWidth = 40.0;

    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
    final double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    final double borderWidth = 3.0;

    final double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              0.0,
              0.0,
              size.width,
              size.height
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              shadowWidth,
              shadowWidth,
              size.width - (shadowWidth * 2),
              size.height - (shadowWidth * 2)
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(
              size.width - tagWidth,
              0.0,
              tagWidth,
              tagWidth
          ),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        tagPaint);

    // Add tag text
   /* TextSpan span = new TextSpan(style: new TextStyle(color: Colors.blue[800]), text: 'Teste');
    TextPainter textPainter = TextPainter(text: span, textAlign: TextAlign.left);
    textPainter.text = TextSpan(
      text: '1',
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );

    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
            size.width - tagWidth / 2 - textPainter.width / 2,
            tagWidth / 2 - textPainter.height / 2
        )
    );*/

    // Oval for the image
    Rect oval = Rect.fromLTWH(
        imageOffset,
        imageOffset,
        size.width - (imageOffset * 2),
        size.height - (imageOffset * 2)
    );

    // Add path for oval image
    canvas.clipPath(Path()
      ..addOval(oval));

    // Add image
    ui.Image image = await getImageFromPath(imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
        size.width.toInt(),
        size.height.toInt()
    );

    // Convert image to bytes
    final ByteData byteData = await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<ui.Image> getImageFromPath(String imagePath) async {
    File imageFile = await _downloadFile(imagePath, "border");
    Uint8List imageBytes = imageFile.readAsBytesSync();
    final Completer<ui.Image> completer = new Completer();

    ui.decodeImageFromList(imageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

}

