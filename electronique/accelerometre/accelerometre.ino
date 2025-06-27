#include <Wire.h>
#include <MPU6050_light.h>

MPU6050 mpu(Wire);  // utilise le bus I2C principal

void setup() {
  Serial.begin(115200);
  
  // Initialisation du bus I2C (adapter les pins si besoin)
  Wire.begin(6,7); // SDA = GPIO4, SCL = GPIO5
  delay(100);       // délai recommandé pour stabilité

  // Tentative d'initialisation du capteur
  byte status = mpu.begin();
  while (status != 0) {
    Serial.print("MPU6050 init failed with status: ");
    Serial.println(status);
    delay(1000); // attendre avant de réessayer
    status = mpu.begin();
  }

  Serial.println("MPU6050 initialized successfully ✅");

  // Calibrage initial
  Serial.println("Calibrating...");
  mpu.calcOffsets();  // optionnel mais recommandé
  Serial.println("Calibration done ✅");
}

void loop() {
  // Mise à jour des données
  mpu.update();

  // Affichage des données
  Serial.print("aX: "); Serial.print(mpu.getAccX(), 2);
  Serial.print(" | aY: "); Serial.print(mpu.getAccY(), 2);
  Serial.print(" | aZ: "); Serial.print(mpu.getAccZ(), 2);

  Serial.print(" | gX: "); Serial.print(mpu.getGyroX(), 2);
  Serial.print(" | gY: "); Serial.print(mpu.getGyroY(), 2);
  Serial.print(" | gZ: "); Serial.print(mpu.getGyroZ(), 2);

  Serial.print(" | Temp: "); Serial.print(mpu.getTemp(), 2);
  Serial.println(" °C");

  delay(500); // lis toutes les 0,5 seconde
}
