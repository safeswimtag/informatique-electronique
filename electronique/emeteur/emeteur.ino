#include <SPI.h>
#include <LoRa.h>

// Pins pour ESP32-C3 SuperMini
#define SCK   8
#define MISO  9
#define MOSI  10
#define SS    5
#define RST   -1 // Non connecté
#define DIO0  -1 // Non utilisé car on ne reçoit rien

void setup() {
  Serial.begin(115200);
  while (!Serial);

  LoRa.setPins(SS, RST, DIO0); // Même si RST et DIO0 ne sont pas connectés

  if (!LoRa.begin(868E6)) {
    Serial.println("Erreur LoRa !");
    while (true);
  }

  Serial.println("Émetteur LoRa prêt !");
}

void loop() {
  Serial.println("Envoi...");
  LoRa.beginPacket();
  LoRa.print("Message de l'ESP32-C3 !");
  LoRa.endPacket();

  delay(2000);
}
