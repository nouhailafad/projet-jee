<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Utilisateur" %>
<%
    Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
    if(u == null) { response.sendRedirect("login.jsp"); return; }
    String statut = u.getStatut();
    boolean isAdmin = "permanent".equals(statut);
    boolean isAssocie = "associe".equals(statut);

    // Statistiques
    int nbMembres = 0, nbEvenements = 0, nbPublications = 0, nbDemandes = 0;
    try {
        java.sql.Connection conn = com.lias.util.DBConnection.getConnection();
        nbMembres = ((java.sql.ResultSet)conn.prepareStatement("SELECT COUNT(*) FROM utilisateur WHERE actif=1").executeQuery()).next() ?
            conn.prepareStatement("SELECT COUNT(*) FROM utilisateur WHERE actif=1").executeQuery().getInt(1) : 0;

        java.sql.ResultSet rs1 = conn.prepareStatement("SELECT COUNT(*) FROM utilisateur WHERE actif=1").executeQuery();
        if(rs1.next()) nbMembres = rs1.getInt(1);

        java.sql.ResultSet rs2 = conn.prepareStatement("SELECT COUNT(*) FROM evenement").executeQuery();
        if(rs2.next()) nbEvenements = rs2.getInt(1);

        java.sql.ResultSet rs3 = conn.prepareStatement("SELECT COUNT(*) FROM publication").executeQuery();
        if(rs3.next()) nbPublications = rs3.getInt(1);

        java.sql.ResultSet rs4 = conn.prepareStatement("SELECT COUNT(*) FROM demande_adhesion WHERE statut='en_attente'").executeQuery();
        if(rs4.next()) nbDemandes = rs4.getInt(1);
    } catch(Exception ex) { System.out.println(ex.getMessage()); }
%>

<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; display: flex; background: #f0f2f5; }

        /* Sidebar */
        .sidebar {
             width: 220px;
             min-height: 100vh;
             height: 100vh;          
             overflow-y: auto;       
             background: #1a1a2e;
             color: white;
             position: fixed;
             left: 0; top: 0;
             display: flex;
             flex-direction: column;
             z-index: 100;
}
        .sidebar-logo {
            padding: 25px 20px;
            border-bottom: 1px solid #16213e;
        }
        .sidebar-logo h2 { color: #4fc3f7; font-size: 20px; }
        .sidebar-logo p { color: #90caf9; font-size: 11px; margin-top: 3px; }
        .sidebar-user {
            padding: 15px 20px;
            border-bottom: 1px solid #16213e;
            background: #16213e;
        }
        .sidebar-user .name { color: white; font-weight: bold; font-size: 14px; }
        .sidebar-user .role {
            color: #4fc3f7;
            font-size: 11px;
            background: rgba(79,195,247,0.2);
            padding: 2px 8px;
            border-radius: 10px;
            display: inline-block;
            margin-top: 4px;
        }
        .sidebar nav { flex: 1; padding: 15px 0; }
        .nav-item {
            display: block;
            padding: 12px 20px;
            color: #90caf9;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        .nav-item:hover, .nav-item.active {
            background: #16213e;
            color: white;
            border-left-color: #4fc3f7;
        }
        .nav-item span { margin-right: 10px; }
        .sidebar-bottom {
            padding: 15px 20px;
            border-top: 1px solid #16213e;
        }
        .sidebar-bottom a {
            color: #ef5350;
            text-decoration: none;
            font-size: 14px;
        }

        /* Main content */
        .main {
            margin-left: 220px;
            flex: 1;
            min-height: 100vh;
        }

        /* Topbar */
        .topbar {
            background: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
        .topbar form input {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 20px;
            width: 280px;
            font-size: 13px;
        }
        .topbar form button {
            padding: 8px 15px;
            background: #1a1a2e;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            margin-left: 5px;
        }
        .topbar-right a {
            color: #546e7a;
            text-decoration: none;
            margin-left: 15px;
            font-size: 14px;
        }

        /* Content */
        .content { padding: 25px 30px; }

        /* Stats */
        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
        }
        .stat-info h3 { font-size: 24px; color: #1a1a2e; }
        .stat-info p { font-size: 12px; color: #90a4ae; margin-top: 2px; }

        /* Welcome */
        .welcome-card {
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            color: white;
            padding: 25px 30px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .welcome-card h2 { font-size: 20px; margin-bottom: 5px; }
        .welcome-card p { color: #90caf9; font-size: 14px; }
        .welcome-badge {
            background: rgba(79,195,247,0.2);
            color: #4fc3f7;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 13px;
        }

        /* Cards grille */
        .cards {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }
        .card {
            background: white;
            padding: 20px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            cursor: pointer;
            transition: all 0.25s;
            border: 2px solid transparent;
        }
        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
            border-color: #4fc3f7;
        }
        .card-icon { font-size: 35px; margin-bottom: 10px; }
        .card h3 { color: #1a1a2e; font-size: 15px; margin-bottom: 12px; }
        .btn-card {
            background: #1a1a2e;
            color: white;
            padding: 7px 18px;
            border-radius: 20px;
            font-size: 12px;
            display: inline-block;
        }
        .badge-rouge {
            background: #ef5350;
            color: white;
            padding: 2px 10px;
            border-radius: 10px;
            font-size: 11px;
            display: block;
            margin-bottom: 8px;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar">
        <div class="sidebar-logo">
            <h2>🔬 LIAS Lab</h2>
            <p>Faculté des Sciences Ben M'Sik</p>
        </div>
        <div class="sidebar-user">
            <div class="name"><%= u.getPrenom() %> <%= u.getNom() %></div>
            <span class="role"><%= u.getStatut().toUpperCase() %></span>
        </div>
        <nav>
            <a class="nav-item active" href="dashboard.jsp"><span>📊</span>Dashboard</a>
            <a class="nav-item" href="profil"><span>👤</span>Mon Profil</a>
            <a class="nav-item" href="publications"><span>📚</span>Publications</a>
            <a class="nav-item" href="calendrier.jsp"><span>📅</span>Calendrier</a>
            <a class="nav-item" href="messages"><span>💬</span>Messages</a>
            <a class="nav-item" href="notifications"><span>🔔</span>Notifications</a>
            <% if(isAdmin) { %>
            <a class="nav-item" href="membres"><span>👥</span>Membres</a>
            <a class="nav-item" href="evenements"><span>🎯</span>Événements</a>
            <a class="nav-item" href="documents"><span>📁</span>Documents</a>
            <a class="nav-item" href="pv"><span>📋</span>PV Réunions</a>
            <a class="nav-item" href="materiel"><span>🖥️</span>Matériel</a>
            <a class="nav-item" href="mandats"><span>🏛️</span>Mandats</a>
            <a class="nav-item" href="adhesion"><span>📝</span>Adhésions</a>
            <a class="nav-item" href="rapport.jsp"><span>📊</span>Rapport</a>
            <a class="nav-item" href="recherche"><span>🔍</span>Recherche</a>
            <% } %>
            <% if(isAssocie) { %>
            <a class="nav-item" href="evenements"><span>🎯</span>Événements</a>
            <% } %>
        </nav>
        <div class="sidebar-bottom">
            <a href="index.jsp">🏠 Accueil public</a><br><br>
            <a href="login.jsp">🚪 Déconnexion</a>
        </div>
    </div>

    <!-- Main -->
    <div class="main">
        <!-- Topbar -->
        <div class="topbar">
            <form action="recherche" method="get">
                <input type="text" name="mot" placeholder="🔍 Chercher un membre, publication..."/>
                <button type="submit">Chercher</button>
            </form>
            <div class="topbar-right">
                <a href="notifications">🔔 Notifications</a>
                <a href="profil">👤 <%= u.getPrenom() %></a>
            </div>
        </div>

        <!-- Content -->
        <div class="content">

            <!-- Welcome -->
            <div class="welcome-card">
                <div>
                    <h2>Bienvenue, <%= u.getPrenom() %> <%= u.getNom() %>! 👋</h2>
                    <p>Tableau de bord — Laboratoire LIAS</p>
                </div>
                <span class="welcome-badge"><%= u.getStatut().toUpperCase() %></span>
            </div>

            <!-- Stats (seulement pour permanent) -->
            <% if(isAdmin) { %>
            <div class="stats">
                <div class="stat-card">
                    <div class="stat-icon" style="background:#e3f2fd;">👥</div>
                    <div class="stat-info">
                        <h3><%= nbMembres %></h3>
                        <p>Membres actifs</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background:#e8f5e9;">📅</div>
                    <div class="stat-info">
                        <h3><%= nbEvenements %></h3>
                        <p>Événements</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background:#fff3e0;">📚</div>
                    <div class="stat-info">
                        <h3><%= nbPublications %></h3>
                        <p>Publications</p>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon" style="background:#fce4ec;">📝</div>
                    <div class="stat-info">
                        <h3><%= nbDemandes %></h3>
                        <p>Demandes en attente</p>
                    </div>
                </div>
            </div>
            <% } %>

            <!-- Cards -->
            <div class="cards">
                <div class="card" onclick="window.location='publications'">
                    <div class="card-icon">📚</div>
                    <h3>Publications</h3>
                    <span class="btn-card">Gérer</span>
                </div>
                <div class="card" onclick="window.location='profil'">
                    <div class="card-icon">👤</div>
                    <h3>Mon Profil</h3>
                    <span class="btn-card">Modifier</span>
                </div>
                <div class="card" onclick="window.location='calendrier.jsp'">
                    <div class="card-icon">📅</div>
                    <h3>Calendrier</h3>
                    <span class="btn-card">Voir</span>
                </div>
                <div class="card" onclick="window.location='messages'">
                    <div class="card-icon">💬</div>
                    <h3>Messages</h3>
                    <span class="btn-card">Discuter</span>
                </div>
                <% if(isAdmin) { %>
                <div class="card" onclick="window.location='membres'">
                    <div class="card-icon">👥</div>
                    <h3>Membres</h3>
                    <span class="btn-card">Gérer</span>
                </div>
                <div class="card" onclick="window.location='evenements'">
                    <div class="card-icon">🎯</div>
                    <h3>Événements</h3>
                    <span class="btn-card">Gérer</span>
                </div>
                <div class="card" onclick="window.location='documents'">
                    <div class="card-icon">📁</div>
                    <h3>Documents</h3>
                    <span class="btn-card">Gérer</span>
                </div>
                <div class="card" onclick="window.location='pv'">
                    <div class="card-icon">📋</div>
                    <h3>PV Réunions</h3>
                    <span class="btn-card">Gérer</span>
                </div>
                <div class="card" onclick="window.location='materiel'">
                    <div class="card-icon">🖥️</div>
                    <h3>Matériel</h3>
                    <span class="btn-card">Gérer</span>
                </div>
                <div class="card" onclick="window.location='rapport.jsp'">
                    <div class="card-icon">📊</div>
                    <h3>Rapport annuel</h3>
                    <span class="btn-card">Générer</span>
                </div>
                <div class="card" onclick="window.location='adhesion'">
                    <div class="card-icon">📝</div>
                    <h3>Demandes adhésion</h3>
                    <% if(nbDemandes > 0) { %>
                        <span class="badge-rouge"><%= nbDemandes %> en attente</span>
                    <% } %>
                    <span class="btn-card">Gérer</span>
                </div>
                <div class="card" onclick="window.location='mandats'">
                    <div class="card-icon">🏛️</div>
                    <h3>Mandats</h3>
                    <span class="btn-card">Gérer</span>
                </div>
                <div class="card" onclick="window.location='recherche'">
                    <div class="card-icon">🔍</div>
                    <h3>Recherche</h3>
                    <span class="btn-card">Chercher</span>
                </div>
                <div class="card" onclick="window.location='notifications'">
                    <div class="card-icon">🔔</div>
                    <h3>Notifications</h3>
                    <span class="btn-card">Voir</span>
                </div>
                <% } %>
                <% if(isAssocie) { %>
                <div class="card" onclick="window.location='evenements'">
                    <div class="card-icon">🎯</div>
                    <h3>Événements</h3>
                    <span class="btn-card">Consulter</span>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>