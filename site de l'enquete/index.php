<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Enquête Safe Swim Tag</title>
  <link rel="stylesheet" href="style.css"/>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
  <div class="container">
    <header>
      <h1>🛟 Enquête sur la prévention des noyades</h1>
    </header>

    <section class="description">
      <h2>🔍 À propos du Safe Swim Tag</h2>
      <p>
       Le <strong>Safe Swim Tag</strong> est un bracelet intelligent conçu pour être porté par les nageurs afin de détecter les risques de noyade et d’émettre une alerte immédiate. Il repère automatiquement les situations anormales, telles qu’une immersion prolongée, et déclenche instantanément une alerte. Ce dispositif permet une intervention rapide en cas de danger, renforçant ainsi la sécurité sur les plages et dans les piscines.</p>
      <audio controls>
        <source src="audio/safe_swim_presentation.mp3" type="audio/mpeg">
        Votre navigateur ne supporte pas l'audio.
      </audio>
    </section>

    <form id="surveyForm" action="submit.php" method="POST">
   <h3>🧑 Profil du participant</h3>
    <label>Quel est votre rôle en lien avec les activités aquatiques ?</label>
    <select name="role" required>
      <option value="">-- Veuillez sélectionner --</option>
      <option value="maitre-nageur">Maître-nageur ou sauveteur</option>
      <option value="baigneur">Baigneur / Usager</option>
      <option value="responsable">Responsable de plage, piscine ou centre</option>
      <option value="autre">Autre (à préciser plus tard)</option>
    </select>

    <h3>🚨 Expérience face aux noyades</h3>
    <label>1. À quelle fréquence observez-vous des noyades ou quasi-noyades sur votre site ?</label>
    <input type="text" name="frequence" placeholder="Ex : 2 fois par mois, rarement, jamais..." required>

    <label>2. Quelles sont, selon vous, les principales causes de ces incidents ?</label>
    <textarea name="causes" placeholder="Ex : imprudence, absence de surveillance, courants forts..." required></textarea>

    <label>3. Comment se comporte généralement une personne en train de se noyer ?</label>
    <textarea name="comportement" placeholder="Décrivez les signes visibles : agitation, appel au secours, etc." required></textarea>

    <label>4. Quelles méthodes ou outils utilisez-vous actuellement pour détecter les noyades ?</label>
    <textarea name="detection" placeholder="Ex : caméras, surveillance humaine, capteurs..." required></textarea>

    <label>5. Quelles sont les limites ou faiblesses des méthodes actuelles ?</label>
    <textarea name="faiblesses" placeholder="Ex : réaction lente, mauvaise visibilité, alerte manuelle..." required></textarea>

    <h3>⚠️ Identification des zones dangereuses</h3>
    <label>6. Comment identifiez-vous les zones à risques (zones profondes, courants, etc.) ?</label>
    <textarea name="zones" placeholder="Ex : balisage, affiches, signalisation au sol..." required></textarea>

    <label>7. Quels types de signalisation utilisez-vous pour avertir les baigneurs (ex : drapeaux, panneaux...) ?</label>
    <textarea name="drapeaux" placeholder="Décrivez les signaux en place et leur signification." required></textarea>

    <label>8. D’après vous, les baigneurs comprennent-ils bien ces signaux ?</label>
    <textarea name="signal_comprehension" placeholder="Ex : oui, mais certains les ignorent / non, manque de clarté..." required></textarea>

    <h3>📡 À propos du Safe Swim Tag</h3>
    <label>9. Que pensez-vous du dispositif Safe Swim Tag présenté ci-dessus ?</label>
    <textarea name="avis" placeholder="Partagez votre opinion : intérêt, utilité, limites..." required></textarea>

    <label>10. Pour quels types de publics ce dispositif serait-il particulièrement utile ?</label>
    <textarea name="publics" placeholder="Ex : enfants, personnes âgées, nageurs débutants..." required></textarea>

    <label>11. Seriez-vous intéressé(e) pour tester ce dispositif ?</label>
    <select name="interet" required>
      <option value="">-- Veuillez sélectionner --</option>
      <option value="oui">Oui</option>
      <option value="non">Non</option>
      <option value="peut-etre">Peut-être</option>
    </select>

    <h3>📞 Informations de contact (facultatif)</h3>
    <label>Nom (facultatif)</label>
    <input type="text" name="nom" placeholder="Ex : Ndoye">

    <label>Prénom (facultatif)</label>
    <input type="text" name="prenom" placeholder="Ex : Moussa">

    <label>Email (facultatif)</label>
    <input type="email" name="email" placeholder="exemple@mail.com">

    <label>Téléphone (facultatif)</label>
    <input type="text" name="telephone" placeholder="Ex : +221 76 123 45 67">


      <button type="submit">✅ Envoyer mes réponses</button>
    </form>
  </div>
  <script src="script.js"></script>
</body>
</html>
