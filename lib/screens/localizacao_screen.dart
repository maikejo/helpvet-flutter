import 'dart:async';
import 'dart:io';
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
import 'package:flutter_finey/service/google_maps_requests.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class LocalizacaoScreen extends StatefulWidget {
  LocalizacaoScreen();

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
  Location location = Location();
  LocationData locationData;
  Marker marker;
  GoogleMapController mapController;
  LatLng centerPosition;
  Stream<List<DocumentSnapshot>> stream;

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;

  CameraPosition cameraPosition;
  Map<String, double> _currentLocation;
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

  TextEditingController destinationController = TextEditingController();

  bool _permission = false;
  String error;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    geo = Geoflutterfire();
    GeoFirePoint center = geo.point(latitude: 12.960632, longitude: 77.641603);
    stream = radius.switchMap((rad) {
      var collectionReference = _firestore.collection('clinicas');
      return geo.collection(collectionRef: collectionReference).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    });

    getCurrentLocation();
  }

  List<Marker> getMarker() {
    List<Marker> markers = <Marker>[
      new Marker(markerId: null),
      new Marker(markerId: null),
    ];

    return markers;
  }

  void _redirectLocalizacaoPetScreen() {
    Application.router.navigateTo(context, RouteConstants.ROUTE_LOCALIZACAO_PET, transition: TransitionType.inFromBottom);
  }

  void _onMapCreated(GoogleMapController controller) {

    setState(() {
    _updateMarkers();
      _controller.complete(controller);
    });


   /* if (locationData != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = LatLng(locationData.latitude, locationData.longitude);
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
        icon: BitmapDescriptor.defaultMarker
      );
      setState(() {
        _markers[markerId] = marker;

        stream.listen((List<DocumentSnapshot> documentList) {
          _updateMarkers(documentList);
        });
      });

      Future.delayed(Duration(seconds: 1), () async {
        GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 17.0,
            ),
          ),
        );
      });
    }*/
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void _addMarker(double lat, double lng,String nomeClinica,String endereco,String imagem) async {
    BitmapDescriptor markerImage = await MapHelper.getMarkerImageFromUrl(imagem,targetWidth: 150,targetHeight: 150);

    MarkerId id = MarkerId(lat.toString() + lng.toString());
    Marker _marker = Marker(
      markerId: id,
      position: LatLng(lat, lng),
      icon: markerImage,
      //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: InfoWindow(title: nomeClinica, snippet: endereco),
    );
    setState(() {
      markers[id] = _marker;
    });
  }

  void _updateMarkers() {
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

  Future<LocationData> getCurrentLocation() async{

      try {
         locationData = await location.getLocation();

         location.onLocationChanged().listen((LocationData _currentLocation) {
           print(_currentLocation.latitude);
           print(_currentLocation.longitude);

           if(_markers.length > 0) {
             MarkerId markerId = MarkerId(_markerIdVal());
             marker = _markers[markerId];
             Marker updatedMarker = marker.copyWith(
                 positionParam: LatLng(_currentLocation.latitude, _currentLocation.longitude),
                 iconParam: BitmapDescriptor.defaultMarker,
                 infoWindowParam: InfoWindow(title: "Meu Pet",)
             );

             setState(() {
               _markers[markerId] = updatedMarker;
             });
           }

         });

      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          error = 'Permission denied';
        }
        locationData = null;
      }

      setState(() {
        mapToggle = true;
        _permission = true;
      });

   return locationData;
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      cameraPosition = position;
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
             _permission == true ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: mapToggle ?
                GoogleMap(
                    myLocationEnabled: true,
                    markers: Set<Marker>.from(markers.values),
                    initialCameraPosition: CameraPosition(target: LatLng(locationData.latitude, locationData.longitude),zoom: 16.0),
                    onMapCreated: _onMapCreated,
                    polylines: _localizacaoState.polyLines
                ) :
                Center(
                  child: SizedBox(
                      child: new CircularProgressIndicator(
                          valueColor:
                          new AlwaysStoppedAnimation(
                              Colors.blue),
                          strokeWidth: 5.0),
                      height: 50.0,
                      width: 50.0),
                ),
              ) : SizedBox(),

              /*  TextField(
              cursorColor: Colors.black,
              controller: destinationController,
              textInputAction: TextInputAction.go,
              onSubmitted: (value) {
                _localizacaoState.sendRequest(LatLng(_currentLocation["latitude"], _currentLocation["longitude"]),LatLng(-8.886844130523066, 13.205616626023385));
              },
            ),*/

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
                icon: Icons.my_location,
                iconColor: Colors.pinkAccent,
                onPanDown: _redirectLocalizacaoPetScreen,
              ),
              MenuWidget(
                  currentMenuPercent: currentMenuPercent,
                  animateMenu: animateMenu),
            ],
          ),
        ),
      );
  }

  @override
  void dispose() {
    super.dispose();
    animationControllerExplore?.dispose();
    animationControllerSearch?.dispose();
    animationControllerMenu?.dispose();
    radius.close();
  }






}
