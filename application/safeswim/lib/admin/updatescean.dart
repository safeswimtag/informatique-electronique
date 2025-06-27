import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:safeswim/main.dart';
import 'package:safeswim/model/models.dart';
import 'package:safeswim/services/api_service.dart';

class UpdateScreen extends StatefulWidget {
  final Plage plage;
  const UpdateScreen({super.key, required this.plage});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late String selectedFlag;
  late String selectedQuality;
  final TextEditingController _safeZoneController = TextEditingController();

  LatLng? selectedPoint;
  double? selectedRadius;
  List<CircleMarker> circles = [];

  LatLng? safeZoneCenter;
  double? safeZoneRadius;
  List<CircleMarker> safeZoneCircle = [];

  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    selectedFlag = widget.plage.drapeau?? "Vert";
    selectedQuality = widget.plage.qualite?? "Bonne";
  }

  void _submitUpdate() async {
    // await apiService.updatePlage(
    //   widget.plage.id,
    //   drapeau: selectedFlag,
    //   qualite: selectedQuality,
    //   zoneRisque: selectedPoint != null
    //       ? {
    //           'lat': selectedPoint!.latitude,
    //           'long': selectedPoint!.longitude,
    //           'rayon': selectedRadius
    //         }
    //       : null,
    //   zoneSafe: safeZoneRadius != null
    //       ? {
    //           'lat': safeZoneCenter!.latitude,
    //           'long': safeZoneCenter!.longitude,
    //           'rayon': safeZoneRadius
    //         }
    //       : null,
    // );
    Navigator.pop(context);
  }

  void _showZoneDialog(LatLng point) {
    final TextEditingController radiusController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Définir une zone à risque"),
        content: TextField(
          controller: radiusController,
          decoration: const InputDecoration(
            labelText: "Rayon (en mètres)",
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            child: const Text("Annuler"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Valider"),
            onPressed: () {
              final rayon = double.tryParse(radiusController.text);
              if (rayon != null) {
                setState(() {
                  selectedPoint = point;
                  selectedRadius = rayon;
                  circles = [
                    CircleMarker(
                      point: point,
                      radius: rayon,
                      useRadiusInMeter: true,
                      color: Colors.red.withOpacity(0.3),
                      borderColor: Colors.red,
                      borderStrokeWidth: 2,
                    ),
                  ];
                });
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final plageLatLng = LatLng(widget.plage.lat??0, widget.plage.long??0);

    return Scaffold(
      appBar: AppBar(title: const Text("Modifier la plage")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedFlag,
              decoration: const InputDecoration(labelText: "Drapeau"),
              items: ["Vert", "Jaune", "Rouge"]
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (val) => setState(() => selectedFlag = val!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedQuality,
              decoration: const InputDecoration(labelText: "Qualité de l’eau"),
              items: ["Bonne", "Moyenne", "Mauvaise"]
                  .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                  .toList(),
              onChanged: (val) => setState(() => selectedQuality = val!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _safeZoneController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Zone sans danger (distace en mètres)",
                hintText: "ex: 100  (pour 100 mètres)",
              ),
              onChanged: (value) {
                final r = double.tryParse(value);
                if (r != null) {
                  setState(() {
                    safeZoneCenter = plageLatLng;
                    safeZoneRadius = r;
                    safeZoneCircle = [
                      CircleMarker(
                        point: safeZoneCenter!,
                        radius: r,
                        useRadiusInMeter: true,
                        color: Colors.green.withOpacity(0.3),
                        borderColor: Colors.green,
                        borderStrokeWidth: 2,
                      )
                    ];
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            const Text("Ajouter une zone à risque (cliquez sur la carte) :"),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: plageLatLng,
                  initialZoom: 17,
                  onTap: (tapPos, latLng) {
                    _showZoneDialog(latLng);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  if (circles.isNotEmpty) CircleLayer(circles: circles),
                  if (safeZoneCircle.isNotEmpty) CircleLayer(circles: safeZoneCircle),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                onPressed: _submitUpdate,
                icon: const Icon(Icons.save),
                label: const Text("Mettre à jour"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
