<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.dao.EvenementDAO, com.lias.model.Evenement, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Evenement> evenements = new EvenementDAO().getAllEvenements();
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Calendrier</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { padding: 30px; max-width: 1000px; margin: 0 auto; }
        .calendar-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; background: white; padding: 15px 25px; border-radius: 10px; }
        .calendar-header h2 { margin: 0; color: #2c3e50; }
        .calendar-header button { background: #2c3e50; color: white; border: none; padding: 8px 16px; border-radius: 5px; cursor: pointer; font-size: 16px; }
        .calendar-grid { display: grid; grid-template-columns: repeat(7, 1fr); gap: 5px; }
        .day-header { background: #2c3e50; color: white; text-align: center; padding: 10px; border-radius: 5px; font-weight: bold; font-size: 13px; }
        .day { background: white; min-height: 80px; padding: 8px; border-radius: 5px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .day.today { border: 2px solid #3498db; }
        .day.empty { background: #f8f9fa; }
        .day-num { font-weight: bold; color: #2c3e50; margin-bottom: 5px; font-size: 14px; }
        .event { background: #3498db; color: white; padding: 2px 6px; border-radius: 3px; font-size: 11px; margin-top: 3px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }
        .event.conference { background: #27ae60; }
        .event.seminaire { background: #e67e22; }
        .event.workshop { background: #9b59b6; }
        .legend { display: flex; gap: 15px; margin-top: 20px; background: white; padding: 15px; border-radius: 10px; }
        .legend-item { display: flex; align-items: center; gap: 8px; font-size: 13px; }
        .legend-color { width: 15px; height: 15px; border-radius: 3px; }
        .events-list { margin-top: 20px; background: white; padding: 20px; border-radius: 10px; }
        .events-list h3 { color: #2c3e50; margin-top: 0; }
        .event-item { padding: 12px; border-left: 4px solid #3498db; margin-bottom: 10px; background: #f8f9fa; border-radius: 0 5px 5px 0; }
        .event-item.conference { border-left-color: #27ae60; }
        .event-item.seminaire { border-left-color: #e67e22; }
        .event-item.workshop { border-left-color: #9b59b6; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2 style="margin:0">🔬 Laboratoire LIAS</h2>
        <div>
            <a href="index.jsp">🏠 Accueil</a>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="login.jsp">🚪 Déconnexion</a>
        </div>
    </div>
    <div class="content">
        <h2>📅 Calendrier des événements</h2>

        <!-- Header calendrier -->
        <div class="calendar-header">
            <button onclick="changerMois(-1)">◀ Précédent</button>
            <h2 id="moisAnnee"></h2>
            <button onclick="changerMois(1)">Suivant ▶</button>
        </div>

        <!-- Jours de la semaine -->
        <div class="calendar-grid">
            <div class="day-header">Lun</div>
            <div class="day-header">Mar</div>
            <div class="day-header">Mer</div>
            <div class="day-header">Jeu</div>
            <div class="day-header">Ven</div>
            <div class="day-header">Sam</div>
            <div class="day-header">Dim</div>
        </div>

        <!-- Grille calendrier -->
        <div class="calendar-grid" id="calendrierGrid"></div>

        <!-- Légende -->
        <div class="legend">
            <div class="legend-item">
                <div class="legend-color" style="background:#27ae60"></div>
                <span>Conférence</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background:#e67e22"></div>
                <span>Séminaire</span>
            </div>
            <div class="legend-item">
                <div class="legend-color" style="background:#9b59b6"></div>
                <span>Workshop</span>
            </div>
        </div>

        <!-- Liste des événements du mois -->
        <div class="events-list">
            <h3>📋 Événements à venir</h3>
            <% if(evenements != null) { for(Evenement e : evenements) { %>
            <div class="event-item <%= e.getType() %>">
                <strong><%= e.getTitre() %></strong>
                <span style="float:right; color:#777; font-size:13px;"><%= e.getDateDebut() %></span>
                <br>
                <small style="color:#777;">
                    📍 <%= e.getLieu() != null ? e.getLieu() : "Non défini" %> |
                    🏷️ <%= e.getType() %>
                </small>
            </div>
            <% }} %>
        </div>
      
    </div>

    <script>
        // Données événements depuis Java
        var evenements = [
            <% if(evenements != null) { for(int i = 0; i < evenements.size(); i++) { Evenement e = evenements.get(i); %>
            {
                titre: "<%= e.getTitre().replace("\"", "\\\"") %>",
                date: "<%= e.getDateDebut() %>",
                type: "<%= e.getType() %>"
            }<%= i < evenements.size()-1 ? "," : "" %>
            <% }} %>
        ];

        var moisActuel = new Date().getMonth();
        var anneeActuelle = new Date().getFullYear();

        var moisNoms = ["Janvier","Février","Mars","Avril","Mai","Juin",
                        "Juillet","Août","Septembre","Octobre","Novembre","Décembre"];

        function changerMois(direction) {
            moisActuel += direction;
            if(moisActuel > 11) { moisActuel = 0; anneeActuelle++; }
            if(moisActuel < 0) { moisActuel = 11; anneeActuelle--; }
            genererCalendrier();
        }

        function genererCalendrier() {
            document.getElementById("moisAnnee").textContent = moisNoms[moisActuel] + " " + anneeActuelle;

            var grid = document.getElementById("calendrierGrid");
            grid.innerHTML = "";

            var premierJour = new Date(anneeActuelle, moisActuel, 1).getDay();
            premierJour = premierJour === 0 ? 6 : premierJour - 1;

            var nbJours = new Date(anneeActuelle, moisActuel + 1, 0).getDate();
            var aujourdhui = new Date();

            // Cases vides avant le 1er
            for(var i = 0; i < premierJour; i++) {
                var vide = document.createElement("div");
                vide.className = "day empty";
                grid.appendChild(vide);
            }

            // Jours du mois
            for(var j = 1; j <= nbJours; j++) {
                var day = document.createElement("div");
                var isToday = (j === aujourdhui.getDate() &&
                               moisActuel === aujourdhui.getMonth() &&
                               anneeActuelle === aujourdhui.getFullYear());
                day.className = "day" + (isToday ? " today" : "");

                var numDiv = document.createElement("div");
                numDiv.className = "day-num";
                numDiv.textContent = j;
                day.appendChild(numDiv);

                // Ajouter événements du jour
                var dateStr = anneeActuelle + "-" +
                    String(moisActuel + 1).padStart(2, "0") + "-" +
                    String(j).padStart(2, "0");

                evenements.forEach(function(e) {
                    if(e.date === dateStr) {
                        var evDiv = document.createElement("div");
                        evDiv.className = "event " + e.type;
                        evDiv.textContent = e.titre;
                        evDiv.title = e.titre;
                        day.appendChild(evDiv);
                    }
                });

                grid.appendChild(day);
            }
        }

        genererCalendrier();
    </script>
</body>
</html>