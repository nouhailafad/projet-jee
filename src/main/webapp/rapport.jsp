<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.dao.*, com.lias.model.*, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    // Récupérer les données
    List membres = new UtilisateurDAO().getAllMembres();
    List evenements = new EvenementDAO().getAllEvenements();
    List publications = new PublicationDAO().getAllPublications();
    List materiels = new MaterielDAO().getAllMateriel();
    int annee = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Rapport Annuel <%= annee %></title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { padding: 30px; max-width: 1000px; margin: 0 auto; }
        .rapport-header { background: #2c3e50; color: white; padding: 40px; border-radius: 10px; text-align: center; margin-bottom: 30px; }
        .rapport-header h1 { font-size: 28px; margin-bottom: 10px; }
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat { background: white; padding: 20px; border-radius: 10px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .stat h2 { font-size: 40px; color: #3498db; margin-bottom: 5px; }
        .stat p { color: #777; font-size: 14px; }
        .section { background: white; padding: 25px; border-radius: 10px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .section h3 { color: #2c3e50; border-bottom: 2px solid #3498db; padding-bottom: 10px; margin-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; padding: 10px; text-align: left; color: #2c3e50; }
        td { padding: 10px; border-bottom: 1px solid #eee; }
        .btn-print { background: #27ae60; color: white; padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; font-size: 14px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2 style="margin:0">🔬 Laboratoire LIAS</h2>
        <div>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="login.jsp">Déconnexion</a>
        </div>
    </div>
    <div class="content">
        <button class="btn-print" onclick="window.print()">🖨️ Imprimer le rapport</button>

        <!-- En-tête rapport -->
        <div class="rapport-header">
            <h1>📊 Rapport d'Activité Annuel</h1>
            <h2>Laboratoire LIAS — Année <%= annee %></h2>
            <p>Faculté des Sciences Ben M'Sik — Casablanca</p>
        </div>

        <!-- Statistiques -->
        <div class="stats">
            <div class="stat">
                <h2><%= membres != null ? membres.size() : 0 %></h2>
                <p>👥 Membres</p>
            </div>
            <div class="stat">
                <h2><%= evenements != null ? evenements.size() : 0 %></h2>
                <p>📅 Événements</p>
            </div>
            <div class="stat">
                <h2><%= publications != null ? publications.size() : 0 %></h2>
                <p>📚 Publications</p>
            </div>
            <div class="stat">
                <h2><%= materiels != null ? materiels.size() : 0 %></h2>
                <p>🖥️ Matériels</p>
            </div>
        </div>

        <!-- Membres -->
        <div class="section">
            <h3>👥 Membres du laboratoire</h3>
            <table>
                <tr><th>Nom</th><th>Prénom</th><th>Email</th><th>Statut</th></tr>
                <% for(Object obj : membres) {
                    Utilisateur u = (Utilisateur) obj; %>
                <tr>
                    <td><%= u.getNom() %></td>
                    <td><%= u.getPrenom() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><%= u.getStatut() %></td>
                </tr>
                <% } %>
            </table>
        </div>

        <!-- Événements -->
        <div class="section">
            <h3>📅 Événements organisés</h3>
            <table>
                <tr><th>Titre</th><th>Type</th><th>Date</th><th>Lieu</th></tr>
                <% for(Object obj : evenements) {
                    Evenement e = (Evenement) obj; %>
                <tr>
                    <td><%= e.getTitre() %></td>
                    <td><%= e.getType() %></td>
                    <td><%= e.getDateDebut() %></td>
                    <td><%= e.getLieu() != null ? e.getLieu() : "-" %></td>
                </tr>
                <% } %>
            </table>
        </div>

        <!-- Publications -->
        <div class="section">
            <h3>📚 Publications scientifiques</h3>
            <table>
                <tr><th>Titre</th><th>Auteurs</th><th>Année</th><th>Type</th></tr>
                <% for(Object obj : publications) {
                    Publication p = (Publication) obj; %>
                <tr>
                    <td><%= p.getTitre() %></td>
                    <td><%= p.getAuteurs() %></td>
                    <td><%= p.getAnnee() %></td>
                    <td><%= p.getType() != null ? p.getType() : "-" %></td>
                </tr>
                <% } %>
            </table>
        </div>
    </div>
</body>
</html>