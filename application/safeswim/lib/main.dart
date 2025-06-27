import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safeswim/admin/login.dart';
import 'package:safeswim/admin/updatescean.dart';
import 'package:safeswim/model/models.dart';
import 'package:safeswim/services/api_service.dart';
import 'package:audioplayers/audioplayers.dart';

ApiService apiService = ApiService();
final AudioPlayer _player = AudioPlayer();

void main() {
  runApp(const SafeSwimApp());
}

class SafeSwimApp extends StatelessWidget {
  const SafeSwimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<Nageur>>(
          create: (_) {
            return apiService.getNageursStream();
          },
          initialData: [
            Nageur(
              id: 0,
              nomC: 'Amanatou Beye',
              lat: 14.674649,
              long: -17.468564,
              lastMess: DateTime.now(),
            ),
          ],
        ),
        StreamProvider<Plage>(
          create: (_) {
            return apiService.getPlageStream();
          },
          initialData: Plage(
            id: 0,
            nom: 'Plage de Ngor',
            lat: 14.674896,
            long: -17.468946,
            drapeau: 'Jaune',
            qualite: 'Bonne',
            zoneRique: [],
            sauveteurs: [],
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Safe Swim PRO',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF2196F3),
            foregroundColor: Colors.white,
            elevation: 4,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: const MapScreen(),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  LatLng? userLocation;
  List<LatLng> stations = [LatLng(14.674896, -17.468946)];
  List<Nageur> nag1 = [
    Nageur(
      id: 2,
      nomC: 'Ibrahima Sarr',
      lat: 14.674489,
      long: -17.468475,
      lastMess: DateTime.now(),
    ),
    Nageur(
      id: 3,
      nomC: 'Fatou Ndiaye',
      lat: 14.674487,
      long: -17.468358,
      lastMess: DateTime.now(),
    ),
    Nageur(
      id: 4,
      nomC: 'Cheikh Diop',
      lat: 14.674165,
      long: -17.468256,
      lastMess: DateTime.now(),
    ),
    Nageur(
      id: 5,
      nomC: 'Seynabou Gaye',
      lat: 14.674157,
      long: -17.467979,
      lastMess: DateTime.now(),
    ),
    Nageur(
      id: 6,
      nomC: 'Mamadou Bah',
      lat: 14.673895,
      long: -17.468673,
      lastMess: DateTime.now(),
    ),
    Nageur(
      id: 7,
      nomC: 'Oumou Kane',
      lat: 14.673351,
      long: -17.468757,
      lastMess: DateTime.now(),
    ),
  ];

  late AnimationController _controller;
  late Animation<double> _animation;
  late final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 2,
      end: 4,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  void _centerToUser() {
    if (userLocation != null) {
      mapController.move(userLocation!, 18);
    }
  }

  void _addNewStation() {
    // Ajoute une station fictive proche (pour démo)
    setState(() {
      stations.add(
        LatLng(
          14.674896 + stations.length * 0.0001,
          -17.468946 + stations.length * 0.0001,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final plage = Provider.of<Plage>(context);
    final nageurs = nag1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Safe Swim - Surveillance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Add',
            onPressed: () {
              for (var nageur in nag1) {
                apiService.createNageur(nageur);
              }
              ;
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Modifier la plage',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen(plage: plage)),
              );
              print(plage.toJson());
              print(nageurs.map((n) => n.toJson()).toList());
            }, // _centerToUser,
          ),
        ],
      ),
      body: Stack(
        children: [
          userLocation == null
              ? const Center(child: CircularProgressIndicator())
              : FlutterMap(
                mapController: mapController,

                options: MapOptions(
                  initialCenter: stations.first,
                  initialZoom: 18,
                  initialRotation: -180,
                  onTap: (tapPosition, point) {
                    print('$point');
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'com.example.app',
                  ),
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: [
                          LatLng(14.673605, -17.466962),
                          LatLng(14.673798, -17.469942),
                          LatLng(14.669396, -17.471231),
                          LatLng(14.671728, -17.465964),
                        ],
                        color: Colors.red.withOpacity(0.4),
                        borderColor: Colors.red,
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),

                  MarkerLayer(
                    markers: [
                      if (userLocation != null)
                        ...nageurs.map((nageur) => _marker(nageur)),
                      ...stations.map(
                        (station) => Marker(
                          point: station,
                          width: 80,
                          height: 80,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ScaleTransition(
                                scale: _animation,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Center(
                                child: Icon(
                                  FontAwesomeIcons.towerBroadcast,
                                  size: 24,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10.0),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Station : ${plage.nom}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    infoRow(
                      Icons.people,
                      'Nageurs actuellement',
                      '${nageurs.length}',
                    ),
                    infoRow(Icons.shield, 'Sauveteurs en poste', '5'),
                    alertRow(Icons.warning, 1, 'Noyades signalées', 1),
                    alertRow(Icons.warning, 0, 'Risques de Noyades', 1),
                    waterQualityRow(
                      Icons.water_drop,
                      'Qualité de l’eau',
                      '${plage.qualite}',
                    ),
                    flagRow(Icons.flag, 'Drapeau actuel', '${plage.drapeau}'),
                    // infoRow(
                    //   Icons.update,
                    //   'Dernière mise à jour',
                    //   '${plage.?.toLocal().toIso8601String() ?? 'N/A'}',
                    // ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () async {
                        //await _player.play(AssetSource('alerte.mp3'));

                        showDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog(
                                title: const Text("🚨 Incident signalé !"),
                                content: const Text(
                                  "Une alerte a été déclenchée et enregistrée.",
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: const Icon(Icons.report),
                      label: const Text('Déclarer un incident urgent'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Marker _marker(Nageur nageur) {
    return Marker(
      point: LatLng(nageur.lat ?? 14.674649, nageur.long ?? -17.468564),
      width: 80,
      height: 80,
      child: GestureDetector(
        onTap: () => _showNageurInfo(nageur, context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color:
                      nageur.id == 7
                          ? Colors.red
                          : nageur.id == 6
                          ? Colors.deepOrangeAccent
                          : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Icon(
              FontAwesomeIcons.personSwimming,
              size: 18,
              color: Colors.greenAccent[400],
            ),
          ],
        ),
      ),
    );
  }
}

void _showNageurInfo(Nageur nageur, BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (context) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(nageur.nomC),
                subtitle: Text("nom : ${nageur.nomC}"),
              ),
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text("Dernière activité"),
                subtitle: Text(
                  nageur.lastMess!.toString(),
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
  );
}

// Les widgets réutilisables :

Widget infoRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 26, color: Colors.blueAccent),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

Widget alertRow(IconData icon, int stade, String label, int incidents) {
  Color color =
      (incidents > 0)
          ? stade == 1
              ? Colors.red
              : Colors.orange
          : Colors.green;
  String text = (incidents > 0) ? '$incidents en cours' : 'Aucun';

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 26, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );
}

Widget waterQualityRow(IconData icon, String label, String quality) {
  Color color;
  switch (quality) {
    case 'Bonne':
      color = Colors.green;
      break;
    case 'Moyenne':
      color = Colors.orange;
      break;
    case 'Mauvaise':
      color = Colors.red;
      break;
    default:
      color = Colors.grey;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 26, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        Text(
          quality,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );
}

Widget flagRow(IconData icon, String label, String flagColor) {
  Color color;
  switch (flagColor) {
    case 'Vert':
      color = Colors.green;
      break;
    case 'Jaune':
      color = Colors.orange;
      break;
    case 'Rouge':
      color = Colors.red;
      break;
    default:
      color = Colors.grey;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Icon(icon, size: 26, color: color),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
        Text(
          flagColor,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    ),
  );
}
