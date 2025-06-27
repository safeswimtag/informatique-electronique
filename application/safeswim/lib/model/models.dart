// Modèle pour Position (utilisé dans ZoneRique)
class Position_def {
  final double lat;
  final double long;

  Position_def({required this.lat, required this.long});

  factory Position_def.fromJson(Map<String, dynamic> json) {
    return Position_def(
      lat: json['lat']?.toDouble() ?? 0.0,
      long:
          json['longi']?.toDouble() ??
          0.0, // Assurez-vous que c'est 'longi' si c'est ce que votre backend renvoie
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'longi': long, // Assurez-vous que c'est 'longi' pour l'envoi
    };
  }
}

// Modèle pour Sauveteur
class Sauveteur {
  final int?
  id; // Peut être null si non encore persisté ou dans le cas de JSON_ARRAYAGG [null]
  final String nom;

  Sauveteur({this.id, required this.nom});

  factory Sauveteur.fromJson(Map<String, dynamic> json) {
    return Sauveteur(id: json['id'], nom: json['nom'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nom': nom};
  }
}

// Modèle pour Plage
class Plage {
  final int? id;
  final String nom;
  final double? lat;
  final double?
  long; // Utilisez 'long' car c'est le nom de la colonne après le parsing backtick
  final String? drapeau;
  final String? qualite;
  final List<List<Position_def>>? zoneRique;
  final List<Sauveteur>? sauveteurs;

  Plage({
    this.id,
    required this.nom,
    this.lat,
    this.long,
    this.drapeau,
    this.qualite,
    this.zoneRique,
    this.sauveteurs,
  });

  factory Plage.fromJson(Map<String, dynamic> json) {
    List<List<Position_def>>? parsedZoneRique;
    if (json['zone_rique'] != null) {
      parsedZoneRique =
          (json['zone_rique'] as List)
              .map(
                (outerList) =>
                    (outerList as List)
                        .map(
                          (innerMap) => Position_def.fromJson(
                            innerMap as Map<String, dynamic>,
                          ),
                        )
                        .toList(),
              )
              .toList();
    }

    List<Sauveteur>? parsedSauveteurs;
    if (json['sauveteurs'] != null) {
      // Le backend envoie "[null]" si pas de sauveteurs, donc gérons cela
      if (json['sauveteurs'] is List &&
          json['sauveteurs'].length == 1 &&
          json['sauveteurs'][0] == null) {
        parsedSauveteurs = [];
      } else {
        parsedSauveteurs =
            (json['sauveteurs'] as List)
                .map((s) => Sauveteur.fromJson(s as Map<String, dynamic>))
                .toList();
      }
    }

    return Plage(
      id: json['id'],
      nom: json['nom'] ?? '',
      lat: json['lat']?.toDouble(),
      long:
          json['long']
              ?.toDouble(), // Assurez-vous que votre backend renvoie 'long' après le parsing ou ajustez
      drapeau: json['drapeau'],
      qualite: json['qualite'],
      zoneRique: parsedZoneRique,
      sauveteurs: parsedSauveteurs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'lat': lat,
      'long': long, // Utilisez 'long' ici pour envoyer
      'drapeau': drapeau,
      'qualite': qualite,
      'zone_rique':
          zoneRique
              ?.map(
                (outerList) => outerList.map((pos) => pos.toJson()).toList(),
              )
              .toList(),
      'sauveteurs':
          sauveteurs
              ?.map((s) => s.toJson())
              .toList(), // Ne doit normalement pas être envoyé pour POST/PUT
    };
  }
}

// Modèle pour Nageur
class Nageur {
  final int? id;
  final String nomC;
  final double? lat;
  final double? long; // Utilisez 'long'
  final DateTime? lastMess;

  Nageur({this.id, required this.nomC, this.lat, this.long, this.lastMess});

  factory Nageur.fromJson(Map<String, dynamic> json) {
    return Nageur(
      id: json['id'],
      nomC: json['nom_c'] ?? '',
      lat: json['lat']?.toDouble(),
      long: json['long']?.toDouble(),
      lastMess:
          json['last_mess'] != null ? DateTime.parse(json['last_mess']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom_c': nomC,
      'lat': lat,
      'long': long,
      'last_mess': lastMess?.toIso8601String(),
    };
  }
}

// Modèle pour NageurAxeData
class NageurAxeData {
  final int? id;
  final int nageurId;
  final double accelX;
  final double accelY;
  final double accelZ;
  final DateTime? timestamp;

  NageurAxeData({
    this.id,
    required this.nageurId,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    this.timestamp,
  });

  factory NageurAxeData.fromJson(Map<String, dynamic> json) {
    return NageurAxeData(
      id: json['id'],
      nageurId: json['nageur_id'],
      accelX: json['accel_x']?.toDouble() ?? 0.0,
      accelY: json['accel_y']?.toDouble() ?? 0.0,
      accelZ: json['accel_z']?.toDouble() ?? 0.0,
      timestamp:
          json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nageur_id': nageurId,
      'accel_x': accelX,
      'accel_y': accelY,
      'accel_z': accelZ,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
