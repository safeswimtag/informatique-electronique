#include <SPI.h>
#include <LoRa.h>

#define SS    5    // Chip Select
#define RST   -1   // Pas utilisé
#define DIO0  26   // DIO0 pour la réception

void setup() {
  Serial.begin(9600);
  while (!Serial);

  LoRa.setPins(SS, RST, DIO0);

  if (!LoRa.begin(868E6)) {
    Serial.println("Erreur d'initialisation LoRa !");
    while (true);
  }

  Serial.println("Récepteur LoRa prêt !");
}

void loop() {
  int packetSize = LoRa.parsePacket();
  if (packetSize) {
    String message = "";

    while (LoRa.available()) {
      message += (char)LoRa.read();
    }

    Serial.print("Message reçu : ");
    Serial.println(message);
  }
}
