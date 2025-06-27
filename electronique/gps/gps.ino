#include <Wire.h>
#include <TinyGPS++.h>

// Déclaration du GPS sur UART1
#define RXD2 16
#define TXD2 17
HardwareSerial neogps(1);

TinyGPSPlus gps;

void setup() {
  Serial.begin(115200);           // Console IDE
  neogps.begin(9600, SERIAL_8N1, RXD2, TXD2);  // GPS sur UART1

  Serial.println("🛰️ Initialisation du module GPS...");
}

void loop() {
  bool newData = false;

  // Lecture pendant 1 seconde
  for (unsigned long start = millis(); millis() - start < 1000;) {
    while (neogps.available()) {
      char c = neogps.read();
      if (gps.encode(c)) {
        newData = true;
      }
    }
  }

  // Si on a reçu des données GPS valides
  if (newData) {
    newData = false;

    if (gps.location.isValid()) {
      Serial.println("📡 Données GPS reçues !");
      Serial.print("📍 Latitude : ");
      Serial.println(gps.location.lat(), 6);
      Serial.print("📍 Longitude : ");
      Serial.println(gps.location.lng(), 6);
      Serial.print("🚗 Vitesse (km/h) : ");
      Serial.println(gps.speed.kmph());
      Serial.print("📶 Satellites : ");
      Serial.println(gps.satellites.value());
      Serial.print("⬆️ Altitude (m) : ");
      Serial.println(gps.altitude.meters(), 1);
      Serial.println("----------------------------");
    } else {
      Serial.println("⚠️ Données GPS non valides (pas de fix)");
    }

  } else {
    Serial.println("❌ Aucun caractère reçu du GPS durant 1 seconde...");
  }

  delay(1000);
}
