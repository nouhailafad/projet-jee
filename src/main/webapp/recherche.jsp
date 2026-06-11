<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.*, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Utilisateur> membres = (List<Utilisateur>) request.getAttribute("membres");
    List<Evenement> evenements = (List<Evenement>) request.getAttribute("evenements");
    List<Publication> publications = (List<Publication>) request.getAttribute("publications");
    String mot = (String) request.getAttribute("mot");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Recherche</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { padding: 30px; max-width: 1000px; margin: 0 auto; }
        .search-box { background: white; padding: 25px; border-radius: 10px; margin-bottom: 25px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); display: flex; gap: 10px; }
        .search-box input { flex: 1; padding: 12px; border: 2px solid #ddd; border-radius: 5px; font-size: 16px; }
        .search-box button { padding: 12px 25px; background: #2c3e50; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }
        .section { background: white; padding: 20px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .section h3 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; margin-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; padding: 10px; text-align: left; color: #2c3e50; }
        td { padding: 10px; border-bottom: 1px solid #eee; }
        .aucun { color: #999; font-style: italic; padding: 10px 0; }
        .total { background: #d6eaf8; color: #1a5276; padding: 4px 10px; border-radius: 10px; font-size: 13px; margin-left: 10px; }
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
        <h2>🔍 Recherche globale</h2>

        <!-- Barre de recherche -->
        <div class="search-box">
            <form action="recherche" method="get" style="display:flex; width:100%; gap:10px;">
                <input type="text" name="mot" placeholder="Rechercher membres, événements, publications..."
                       value="<%= mot != null ? mot : "" %>"/>
                <button type="submit">🔍 Rechercher</button>
            </form>
        </div>

        <% if(mot != null) { %>

        <!-- Membres -->
        <div class="section">
            <h3>👥 Membres
                <span class="total"><%= membres != null ? membres.size() : 0 %> résultat(s)</span>
            </h3>
            <% if(membres != null && !membres.isEmpty()) { %>
            <table>
                <tr><th>Nom</th><th>Prénom</th><th>Email</th><th>Statut</th></tr>
                <% for(Utilisateur u : membres) { %>
                <tr>
                    <td><%= u.getNom() %></td>
                    <td><%= u.getPrenom() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getStatut() %></td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
                <p class="aucun">Aucun membre trouvé</p>
            <% } %>
        </div>

        <!-- Événements -->
        <div class="section">
            <h3>📅 Événements
                <span class="total"><%= evenements != null ? evenements.size() : 0 %> résultat(s)</span>
            </h3>
            <% if(evenements != null && !evenements.isEmpty()) { %>
            <table>
                <tr><th>Titre</th><th>Type</th><th>Date</th><th>Lieu</th></tr>
                <% for(Evenement e : evenements) { %>
                <tr>
                    <td><%= e.getTitre() %></td>
                    <td><%= e.getType() %></td>
                    <td><%= e.getDateDebut() %></td>
                    <td><%= e.getLieu() != null ? e.getLieu() : "-" %></td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
                <p class="aucun">Aucun événement trouvé</p>
            <% } %>
        </div>

        <!-- Publications -->
        <div class="section">
            <h3>📚 Publications
                <span class="total"><%= publications != null ? publications.size() : 0 %> résultat(s)</span>
            </h3>
            <% if(publications != null && !publications.isEmpty()) { %>
            <table>
                <tr><th>Titre</th><th>Auteurs</th><th>Année</th><th>Type</th></tr>
                <% for(Publication p : publications) { %>
                <tr>
                    <td><%= p.getTitre() %></td>
                    <td><%= p.getAuteurs() %></td>
                    <td><%= p.getAnnee() %></td>
                    <td><%= p.getType() != null ? p.getType() : "-" %></td>
                </tr>
                <% } %>
            </table>
            <% } else { %>
                <p class="aucun">Aucune publication trouvée</p>
            <% } %>
        </div>

        <% } %>
    </div>
</body>
</html>