// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/models.dart'; // Assurez-vous que le chemin est correct

class ApiService {
  final String _baseUrl =
      'http://localhost:3000/api'; // Remplacez par l'IP de votre machine si vous testez sur un appareil physique ou un émulateur, par ex. 10.0.2.2 pour Android Emulator, 192.168.x.x pour votre IP locale.

  // --- Plage Endpoints ---

  Future<List<Plage>> getPlages() async {
    final response = await http.get(Uri.parse('$_baseUrl/plages'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((plage) => Plage.fromJson(plage)).toList();
    } else {
      throw Exception('Failed to load plages: ${response.statusCode}');
    }
  }

  Future<Plage> getPlageById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/plages/$id'));

    if (response.statusCode == 200) {
      return Plage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load plage: ${response.statusCode}');
    }
  }

  Stream<Plage> getPlageStream() {
    return Stream.periodic(
      const Duration(seconds: 1),
    ).asyncMap((_) => getPlageById(1));
  }

  Future<Plage> createPlage(Plage plage) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/plages'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(plage.toJson()),
    );

    if (response.statusCode == 201) {
      return Plage.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create plage: ${response.statusCode}');
    }
  }

  Future<Plage> updatePlage(int id, Plage plage) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/plages/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(plage.toJson()),
    );

    if (response.statusCode == 200) {
      return Plage.fromJson(
        json.decode(response.body),
      ); // Le PUT peut retourner l'objet mis à jour
    } else {
      throw Exception('Failed to update plage: ${response.statusCode}');
    }
  }

  Future<void> deletePlage(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/plages/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete plage: ${response.statusCode}');
    }
  }

  Future<List<Sauveteur>> getSauveteurs() async {
    final response = await http.get(Uri.parse('$_baseUrl/sauveteurs'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((s) => Sauveteur.fromJson(s)).toList();
    } else {
      throw Exception('Failed to load sauveteurs: ${response.statusCode}');
    }
  }

  Future<Sauveteur> createSauveteur(Sauveteur sauveteur) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/sauveteurs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(sauveteur.toJson()),
    );

    if (response.statusCode == 201) {
      return Sauveteur.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create sauveteur: ${response.statusCode}');
    }
  }

  // --- Plage_Sauveteur Association Endpoints ---

  Future<void> addSauveteurToPlage(int plageId, int sauveteurId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/plages/$plageId/sauveteurs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'sauveteurId': sauveteurId}),
    );

    if (response.statusCode != 201) {
      // Le statut 201 (Created) est attendu pour une association réussie
      throw Exception(
        'Failed to add sauveteur to plage: ${response.statusCode}',
      );
    }
  }

  Future<void> removeSauveteurFromPlage(int plageId, int sauveteurId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/plages/$plageId/sauveteurs/$sauveteurId'),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to remove sauveteur from plage: ${response.statusCode}',
      );
    }
  }

  // --- Nageur Endpoints ---

  Future<List<Nageur>> getNageurs() async {
    final response = await http.get(Uri.parse('$_baseUrl/nageurs'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((n) => Nageur.fromJson(n)).toList();
    } else {
      throw Exception('Failed to load nageurs: ${response.statusCode}');
    }
  }

  Stream<List<Nageur>> getNageursStream() {
    return Stream.periodic(
      const Duration(seconds: 1),
    ).asyncMap((_) => getNageurs());
  }

  Future<Nageur> createNageur(Nageur nageur) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/nageur'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(nageur.toJson()),
    );
    if (response.statusCode == 201) {
      return Nageur.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create nageur: ${response.statusCode}');
    }
  }

  // --- NageurAxeData Endpoints ---

  // Future<List<NageurAxeData>> getNageurAxeData(int nageurId) async {
  //   final response = await http.get(Uri.parse('$_baseUrl/nageurs/$nageurId/axe-data'));

  //   if (response.statusCode == 200) {
  //     List jsonResponse = json.decode(response.body);
  //     return jsonResponse.map((data) => NageurAxeData.fromJson(data)).toList();
  //   } else {
  //     throw Exception('Failed to load nageur axe data: ${response.statusCode}');
  //   }
  // }

  // Future<NageurAxeData> createNageurAxeData(int nageurId, NageurAxeData axeData) async {
  //   final response = await http.post(
  //     Uri.parse('$_baseUrl/nageurs/$nageurId/axe-data'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(axeData.toJson()),
  //   );

  //   if (response.statusCode == 201) {
  //     return NageurAxeData.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to create nageur axe data: ${response.statusCode}');
  //   }
  // }
}
