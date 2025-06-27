<?php
$host = "*************";
$user = "safes*****";
$password = "Ue7d*****************";
$db = "**********";

$conn = new mysqli($host, $user, $password, $db);
if ($conn->connect_error) {
    die("Connexion échouée : " . $conn->connect_error);
}

$stmt = $conn->prepare("INSERT INTO reponses (
  role, frequence, causes, comportement, detection, faiblesses, zones, drapeaux,
  signal_comprehension, avis, publics, interet,
  nom, prenom, email, telephone
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

$stmt->bind_param("ssssssssssssssss",
  $_POST['role'],
  $_POST['frequence'],
  $_POST['causes'],
  $_POST['comportement'],
  $_POST['detection'],
  $_POST['faiblesses'],
  $_POST['zones'],
  $_POST['drapeaux'],
  $_POST['signal_comprehension'],
  $_POST['avis'],
  $_POST['publics'],
  $_POST['interet'],
  $_POST['nom'],
  $_POST['prenom'],
  $_POST['email'],
  $_POST['telephone']
);

if ($stmt->execute()) {
    echo "✅ Merci, votre réponse a été enregistrée avec succès.";
} else {
    echo "❌ Erreur : " . $stmt->error;
}

$conn->close();
?>
