<?php
include 'config.php';
$result = $conn->query("SELECT * FROM reponses ORDER BY date_soumission DESC");

if (!$result) {
    die("Erreur dans la requête SQL : " . $conn->error);
}

?>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Dashboard - Safe Swim Tag</title>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      margin: 0;
      background: #f2f4f7;
      padding: 20px;
    }

    h2 {
      text-align: center;
      color: #006699;
    }

    .container {
      max-width: 98%;
      margin: auto;
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 3px 8px rgba(0,0,0,0.1);
    }

    table {
      border-collapse: collapse;
      width: 100%;
      margin-top: 20px;
    }

    th, td {
      border: 1px solid #ddd;
      padding: 8px;
      max-width: 200px;
      overflow-wrap: break-word;
      text-align: left;
      vertical-align: top;
      font-size: 14px;
    }

    th {
      background-color: #006699;
      color: white;
    }

    td:hover {
      background-color: #eef8ff;
    }

    .view-button {
      cursor: pointer;
      color: #006699;
      text-decoration: underline;
      font-size: 14px;
      margin-left: 4px;
    }

    .modal {
      display: none;
      position: fixed;
      z-index: 10;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      overflow: auto;
      background-color: rgba(0,0,0,0.5);
    }

    .modal-content {
      background-color: white;
      margin: 10% auto;
      padding: 20px;
      width: 80%;
      max-width: 600px;
      border-radius: 8px;
      box-shadow: 0 4px 10px rgba(0,0,0,0.25);
    }

    .modal-close {
      float: right;
      font-size: 22px;
      font-weight: bold;
      cursor: pointer;
      color: #aaa;
    }

    .modal-close:hover {
      color: black;
    }

    input[type="text"] {
      margin-bottom: 15px;
      padding: 8px;
      width: 100%;
      max-width: 400px;
      border: 1px solid #ccc;
      border-radius: 5px;
    }

    button {
      padding: 8px 16px;
      margin-bottom: 10px;
      background: #006699;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    button:hover {
      background-color: #004d66;
    }

    a {
      text-decoration: none;
    }
  </style>
</head>
<body>

<div class="container">
  <h2>Dashboard - Safe Swim Tag</h2>

  <input type="text" id="searchInput" placeholder="🔍 Rechercher...">
  <button onclick="exportToCSV()">📤 Exporter CSV</button>

  <table>
    <thead>
      <tr>
        <th>Rôle</th>
        <th>Fréquence</th>
        <th>Causes</th>
        <th>Comportement noyé</th>
        <th>Détection</th>
        <th>Faiblesses</th>
        <th>Zones à risques</th>
        <th>Drapeaux</th>
        <th>Signaux</th>
        <th>Avis</th>
        <th>Publics</th>
        <th>Intéressé</th>
        <th>Nom</th>
        <th>Prénom</th>
        <th>Email</th>
        <th>Téléphone</th>
        <th>Date</th>
        <th>✏️</th>
        <th>🗑️</th>
      </tr>
    </thead>
    <tbody>
      <?php while($row = $result->fetch_assoc()): ?>
        <tr>
          <?php
            function shorten($text) {
              $short = mb_strimwidth($text, 0, 30, "...");
              return $short . " <span class='view-button' onclick='showFullText(`" . addslashes($text) . "`)'>👁</span>";
            }
          ?>
          <td><?= $row['role'] ?></td>
          <td><?= $row['frequence'] ?></td>
          <td><?= shorten($row['causes']) ?></td>
          <td><?= shorten($row['comportement']) ?></td>
          <td><?= shorten($row['detection']) ?></td>
          <td><?= shorten($row['faiblesses']) ?></td>
          <td><?= shorten($row['zones']) ?></td>
          <td><?= shorten($row['drapeaux']) ?></td>
          <td><?= shorten($row['signal_comprehension']) ?></td>
          <td><?= shorten($row['avis']) ?></td>
          <td><?= shorten($row['publics']) ?></td>
          <td><?= $row['interet'] ?></td>
          <td><?= $row['nom'] ?></td>
          <td><?= $row['prenom'] ?></td>
          <td><?= $row['email'] ?></td>
          <td><?= $row['telephone'] ?></td>
          <td><?= $row['date_soumission'] ?></td>
          <td><a href="edit.php?id=<?= $row['id'] ?>">✏️</a></td>
          <td><a href="delete.php?id=<?= $row['id'] ?>" onclick="return confirm('Supprimer cette réponse ?')">🗑️</a></td>
        </tr>
      <?php endwhile; ?>
    </tbody>
  </table>
</div>

<!-- Modal -->
<div id="modal" class="modal">
  <div class="modal-content">
    <span class="modal-close" onclick="closeModal()">&times;</span>
    <p id="modal-text"></p>
  </div>
</div>

<script>
function showFullText(text) {
  document.getElementById("modal-text").innerText = text;
  document.getElementById("modal").style.display = "block";
}

function closeModal() {
  document.getElementById("modal").style.display = "none";
}

window.onclick = function(event) {
  if (event.target == document.getElementById("modal")) {
    closeModal();
  }
}

document.getElementById('searchInput').addEventListener('keyup', function () {
  const search = this.value.toLowerCase();
  document.querySelectorAll('tbody tr').forEach(row => {
    row.style.display = Array.from(row.cells).some(cell =>
      cell.textContent.toLowerCase().includes(search)
    ) ? '' : 'none';
  });
});

function exportToCSV() {
  const table = document.querySelector("table");
  const rows = Array.from(table.rows);
  const csvContent = rows.map(row =>
    Array.from(row.cells).map(cell => `"${cell.innerText.replace(/"/g, '""')}"`).join(",")
  ).join("\n");

  const blob = new Blob([csvContent], { type: "text/csv;charset=utf-8;" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.setAttribute("href", url);
  link.setAttribute("download", "safe_swim_responses.csv");
  link.click();
}
</script>

</body>
</html>
