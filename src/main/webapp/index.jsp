<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Laboratoire LIAS</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar h1 { font-size: 22px; }
        .navbar a { color: white; text-decoration: none; background: #e74c3c; padding: 8px 16px; border-radius: 5px; }
        .hero { background: linear-gradient(135deg, #2c3e50, #3498db); color: white; padding: 80px 30px; text-align: center; }
        .hero h2 { font-size: 36px; margin-bottom: 15px; }
        .hero p { font-size: 18px; opacity: 0.9; margin-bottom: 30px; }
        .hero a { background: white; color: #2c3e50; padding: 12px 30px; border-radius: 25px; text-decoration: none; font-weight: bold; }
        .section { padding: 50px 30px; max-width: 1100px; margin: 0 auto; }
        .section h2 { color: #2c3e50; margin-bottom: 30px; font-size: 28px; border-left: 4px solid #3498db; padding-left: 15px; }
        .cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .card { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); text-align: center; }
        .card h3 { color: #2c3e50; margin-bottom: 10px; }
        .card p { color: #777; font-size: 14px; }
        .card .icon { font-size: 40px; margin-bottom: 15px; }
        .footer { background: #2c3e50; color: white; text-align: center; padding: 20px; margin-top: 50px; }
        .about { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .about p { color: #555; line-height: 1.8; font-size: 15px; }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div class="navbar">
        <h1>🔬 Laboratoire LIAS</h1>
        <a href="adhesion.jsp">Rejoindre le laboratoire</a>
        <a href="login.jsp">Connexion membres</a>
    </div>

    <!-- Hero -->
    <div class="hero">
        <h2>Bienvenue au Laboratoire LIAS</h2>
        <p>Laboratoire d'Informatique et Applications Scientifiques<br>Faculté des Sciences Ben M'Sik — Casablanca</p>
        <a href="#presentation">Découvrir le laboratoire</a>
    </div>

    <!-- Présentation -->
    <div class="section" id="presentation">
        <h2>🏛️ Présentation</h2>
        <div class="about">
            <p>Le laboratoire LIAS est un laboratoire de recherche de la Faculté des Sciences Ben M'Sik de Casablanca. Il regroupe des chercheurs permanents, des doctorants et des membres associés travaillant sur des projets scientifiques de pointe dans le domaine de l'informatique et des applications scientifiques.</p>
        </div>
    </div>

    <!-- Activités -->
    <div class="section">
        <h2>🔭 Nos activités</h2>
        <div class="cards">
            <div class="card">
                <div class="icon">📚</div>
                <h3>Publications</h3>
                <p>Articles scientifiques, thèses et rapports de recherche publiés par nos membres.</p>
            </div>
            <div class="card">
                <div class="icon">📅</div>
                <h3>Événements</h3>
                <p>Conférences, séminaires et workshops organisés par le laboratoire.</p>
            </div>
            <div class="card">
                <div class="icon">👥</div>
                <h3>Équipes</h3>
                <p>Équipes de recherche multidisciplinaires travaillant sur des projets innovants.</p>
            </div>
        </div>
    </div>

    <!-- Équipes -->
    <div class="section">
        <h2>👨‍🔬 Nos équipes</h2>
        <div class="cards">
            <div class="card">
                <div class="icon">🤖</div>
                <h3>Intelligence Artificielle</h3>
                <p>Machine Learning, Deep Learning et traitement des données.</p>
            </div>
            <div class="card">
                <div class="icon">🔒</div>
                <h3>Sécurité Informatique</h3>
                <p>Cybersécurité, cryptographie et protection des systèmes.</p>
            </div>
            <div class="card">
                <div class="icon">📊</div>
                <h3>Big Data</h3>
                <p>Analyse de données massives et systèmes distribués.</p>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>© 2026 Laboratoire LIAS — Faculté des Sciences Ben M'Sik, Casablanca</p>
        <p style="margin-top:8px; opacity:0.7">Contact: lias@fsbm.ac.ma</p>
    </div>
</body>
</html>