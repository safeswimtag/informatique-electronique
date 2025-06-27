<?php
$host = "localhost";
$user = "root";
$password = "passer";
$db = "safe_swim_enquete";

$conn = new mysqli($host, $user, $password, $db);
if ($conn->connect_error) {
    die("Erreur de connexion à la base de données : " . $conn->connect_error);
}
?>
