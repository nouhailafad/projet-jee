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

    // Données pour les graphiques (construites en JSON simple)
    StringBuilder pubAnneesJson = new StringBuilder("[]");
    StringBuilder pubCountsJson = new StringBuilder("[]");
    StringBuilder statutLabelsJson = new StringBuilder("[]");
    StringBuilder statutCountsJson = new StringBuilder("[]");

    try {
        java.sql.Connection conn = com.lias.util.DBConnection.getConnection();

        java.sql.PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM utilisateur WHERE actif=1");
        java.sql.ResultSet rs1 = ps1.executeQuery();
        if(rs1.next()) nbMembres = rs1.getInt(1);

        java.sql.PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM evenement");
        java.sql.ResultSet rs2 = ps2.executeQuery();
        if(rs2.next()) nbEvenements = rs2.getInt(1);

        java.sql.PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM publication");
        java.sql.ResultSet rs3 = ps3.executeQuery();
        if(rs3.next()) nbPublications = rs3.getInt(1);

        java.sql.PreparedStatement ps4 = conn.prepareStatement("SELECT COUNT(*) FROM demande_adhesion WHERE statut='en_attente'");
        java.sql.ResultSet rs4 = ps4.executeQuery();
        if(rs4.next()) nbDemandes = rs4.getInt(1);

        // Graphique 1 : nombre de publications groupées par année
        java.sql.PreparedStatement psPub = conn.prepareStatement(
            "SELECT annee, COUNT(*) AS total FROM publication GROUP BY annee ORDER BY annee"
        );
        java.sql.ResultSet rsPub = psPub.executeQuery();
        java.util.List<String> annees = new java.util.ArrayList<>();
        java.util.List<String> counts = new java.util.ArrayList<>();
        while(rsPub.next()) {
            annees.add("\"" + rsPub.getString("annee") + "\"");
            counts.add(String.valueOf(rsPub.getInt("total")));
        }
        pubAnneesJson = new StringBuilder("[" + String.join(",", annees) + "]");
        pubCountsJson = new StringBuilder("[" + String.join(",", counts) + "]");

        // Graphique 2 : répartition des membres par statut
        java.sql.PreparedStatement psStatut = conn.prepareStatement(
            "SELECT statut, COUNT(*) AS total FROM utilisateur GROUP BY statut"
        );
        java.sql.ResultSet rsStatut = psStatut.executeQuery();
        java.util.List<String> labels = new java.util.ArrayList<>();
        java.util.List<String> sCounts = new java.util.ArrayList<>();
        while(rsStatut.next()) {
            labels.add("\"" + rsStatut.getString("statut") + "\"");
            sCounts.add(String.valueOf(rsStatut.getInt("total")));
        }
        statutLabelsJson = new StringBuilder("[" + String.join(",", labels) + "]");
        statutCountsJson = new StringBuilder("[" + String.join(",", sCounts) + "]");

        System.out.println("DASHBOARD STATS -> membres:" + nbMembres + " evenements:" + nbEvenements + " publications:" + nbPublications + " demandes:" + nbDemandes);

    } catch(Exception ex) {
        System.out.println("ERREUR DASHBOARD STATS: " + ex.getMessage());
        ex.printStackTrace();
    }

       // OPTION B : événements du mois en cours, pour un mini-calendrier visuel
    java.util.Set<Integer> joursAvecEvenement = new java.util.HashSet<>();
    java.util.Map<Integer, String> titresParJour = new java.util.HashMap<>();
    int moisActuel = java.time.LocalDate.now().getMonthValue();
    int anneeActuelle = java.time.LocalDate.now().getYear();
    String nomMois = java.time.LocalDate.now().getMonth().getDisplayName(java.time.format.TextStyle.FULL, new java.util.Locale("fr"));
    try {
        java.sql.Connection conn3 = com.lias.util.DBConnection.getConnection();
        java.sql.PreparedStatement psCal = conn3.prepareStatement(
            "SELECT titre, date_debut FROM evenement WHERE MONTH(date_debut)=? AND YEAR(date_debut)=?"
        );
        psCal.setInt(1, moisActuel);
        psCal.setInt(2, anneeActuelle);
        java.sql.ResultSet rsCal = psCal.executeQuery();
        while(rsCal.next()) {
            java.sql.Date d = rsCal.getDate("date_debut");
            int jour = d.toLocalDate().getDayOfMonth();
            joursAvecEvenement.add(jour);
            titresParJour.put(jour, rsCal.getString("titre"));
        }
    } catch(Exception ex) {
        System.out.println("ERREUR MINI CALENDRIER: " + ex.getMessage());
    }
    int joursDansLeMois = java.time.YearMonth.of(anneeActuelle, moisActuel).lengthOfMonth();
    int premierJourSemaine = java.time.LocalDate.of(anneeActuelle, moisActuel, 1).getDayOfWeek().getValue();
    int aujourdHui = java.time.LocalDate.now().getDayOfMonth();
%>

<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Dashboard</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; display: flex; background: #f0f2f5; }
        .sidebar {
             width: 220px; min-height: 100vh; height: 100vh; overflow-y: auto;
             background: #1a1a2e; color: white; position: fixed; left: 0; top: 0;
             display: flex; flex-direction: column; z-index: 100;
        }
        .sidebar-logo { padding: 25px 20px; border-bottom: 1px solid #16213e; }
        .sidebar-logo h2 { color: #4fc3f7; font-size: 20px; }
        .sidebar-logo p { color: #90caf9; font-size: 11px; margin-top: 3px; }
        .sidebar-user { padding: 15px 20px; border-bottom: 1px solid #16213e; background: #16213e; }
        .sidebar-user .name { color: white; font-weight: bold; font-size: 14px; }
        .sidebar-user .role { color: #4fc3f7; font-size: 11px; background: rgba(79,195,247,0.2); padding: 2px 8px; border-radius: 10px; display: inline-block; margin-top: 4px; }
        .sidebar nav { flex: 1; padding: 15px 0; }
        .nav-item { display: block; padding: 12px 20px; color: #90caf9; text-decoration: none; font-size: 14px; cursor: pointer; transition: all 0.2s; border-left: 3px solid transparent; }
        .nav-item:hover, .nav-item.active { background: #16213e; color: white; border-left-color: #4fc3f7; }
        .nav-item span { margin-right: 10px; }
        .sidebar-bottom { padding: 15px 20px; border-top: 1px solid #16213e; }
        .sidebar-bottom a { color: #ef5350; text-decoration: none; font-size: 14px; }
        .main { margin-left: 220px; flex: 1; min-height: 100vh; }
        .topbar { background: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .topbar form input { padding: 8px 15px; border: 1px solid #ddd; border-radius: 20px; width: 280px; font-size: 13px; }
        .topbar form button { padding: 8px 15px; background: #1a1a2e; color: white; border: none; border-radius: 20px; cursor: pointer; margin-left: 5px; }
        .topbar-right a { color: #546e7a; text-decoration: none; margin-left: 15px; font-size: 14px; }
        .content { padding: 25px 30px; }
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 25px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); display: flex; align-items: center; gap: 15px; }
        .stat-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 22px; }
        .stat-info h3 { font-size: 24px; color: #1a1a2e; }
        .stat-info p { font-size: 12px; color: #90a4ae; margin-top: 2px; }
        .welcome-card { background: linear-gradient(135deg, #1a1a2e, #16213e); color: white; padding: 25px 30px; border-radius: 12px; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
        .welcome-card h2 { font-size: 20px; margin-bottom: 5px; }
        .welcome-card p { color: #90caf9; font-size: 14px; }
        .welcome-badge { background: rgba(79,195,247,0.2); color: #4fc3f7; padding: 5px 15px; border-radius: 20px; font-size: 13px; }
        .charts { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 25px; }
        .chart-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
        .chart-card h3 { font-size: 14px; color: #1a1a2e; margin-bottom: 15px; }
        .chart-wrapper { position: relative; height: 280px; }
        .badge-rouge { background: #ef5350; color: white; padding: 2px 10px; border-radius: 10px; font-size: 11px; display: inline-block; margin-left: 8px; }
        .mini-cal { width: 100%; border-collapse: collapse; }
        .mini-cal th { font-size: 11px; color: #90a4ae; padding: 6px 0; text-align: center; font-weight: normal; }
        .mini-cal td { text-align: center; padding: 8px 0; font-size: 13px; color: #1a1a2e; border-radius: 8px; position: relative; }
        .mini-cal td.jour-event { background: #e3f2fd; color: #1565c0; font-weight: bold; cursor: pointer; }
        .mini-cal td.jour-aujourdhui { background: #1a1a2e; color: white; font-weight: bold; }
        .point-event { display: block; width: 4px; height: 4px; background: #1565c0; border-radius: 50%; margin: 2px auto 0; }
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
            <a class="nav-item" href="demandes-materiel"><span>🖥️</span>Besoins matériel</a>
            <% if(isAdmin) { %>
            <a class="nav-item" href="membres"><span>👥</span>Membres</a>
            <a class="nav-item" href="affiliations"><span>🏷️</span>Affiliations</a>
            <a class="nav-item" href="equipes"><span>🧩</span>Équipes</a>
            <a class="nav-item" href="evenements"><span>🎯</span>Événements</a>
            <a class="nav-item" href="documents"><span>📁</span>Documents</a>
            <a class="nav-item" href="pv"><span>📋</span>PV Réunions</a>
            <a class="nav-item" href="materiel"><span>🖥️</span>Matériel</a>
            <a class="nav-item" href="mandats"><span>🏛️</span>Mandats</a>
            <a class="nav-item" href="adhesion"><span>📝</span>Adhésions<% if(nbDemandes > 0) { %><span class="badge-rouge"><%= nbDemandes %></span><% } %></a>
            <a class="nav-item" href="rapport.jsp"><span>📊</span>Rapport</a>
            <a class="nav-item" href="recherche"><span>🔍</span>Recherche</a>
            <a class="nav-item" href="partenaires"><span>🏢</span>Partenaires</a>
            <a class="nav-item" href="conventions"><span>🤝</span>Conventions</a>
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

        <div class="content">

            <div class="welcome-card">
                <div>
                    <h2>Bienvenue, <%= u.getPrenom() %> <%= u.getNom() %>! 👋</h2>
                    <p>Tableau de bord — Laboratoire LIAS</p>
                </div>
                <span class="welcome-badge"><%= u.getStatut().toUpperCase() %></span>
            </div>

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

            <div class="charts">
                <div class="chart-card">
                    <h3>📅 Calendrier — <%= nomMois %> <%= anneeActuelle %></h3>
                    <table class="mini-cal">
                        <tr>
                            <th>L</th><th>M</th><th>M</th><th>J</th><th>V</th><th>S</th><th>D</th>
                        </tr>
                        <tr>
                        <%
                            int cellule = 1;
                            // cases vides avant le 1er jour du mois
                            for(int i = 1; i < premierJourSemaine; i++) {
                                out.print("<td></td>");
                                cellule++;
                            }
                            for(int jour = 1; jour <= joursDansLeMois; jour++) {
                                boolean aEvenement = joursAvecEvenement.contains(jour);
                                boolean estAujourdhui = (jour == aujourdHui);
                                String classe = estAujourdhui ? "jour-aujourdhui" : (aEvenement ? "jour-event" : "");
                                String titreInfo = aEvenement ? titresParJour.get(jour) : "";
                        %>
                            <td class="<%= classe %>" title="<%= titreInfo %>"><%= jour %><% if(aEvenement) { %><span class="point-event"></span><% } %></td>
                        <%
                                cellule++;
                                if(cellule > 7) {
                                    out.print("</tr><tr>");
                                    cellule = 1;
                                }
                            }
                        %>
                        </tr>
                    </table>
                    <p style="font-size:11px;color:#999;margin-top:10px;">🔵 Jour avec un événement — survolez pour voir le titre</p>
                </div>
                <div class="chart-card">
                    <h3>👥 Répartition des membres par statut</h3>
                    <div class="chart-wrapper">
                        <canvas id="chartStatuts"></canvas>
                    </div>
                </div>
            </div>
            <% } %>

        </div>
    </div>

    <% if(isAdmin) { %>
    <script>
        new Chart(document.getElementById('chartStatuts'), {
            type: 'doughnut',
            data: {
                labels: <%= statutLabelsJson.toString() %>,
                datasets: [{
                    data: <%= statutCountsJson.toString() %>,
                    backgroundColor: ['#1a1a2e', '#4fc3f7', '#90caf9', '#7f8c8d', '#e74c3c']
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false
            }
        });
    </script>
    <% } %>
</body>
</html>
