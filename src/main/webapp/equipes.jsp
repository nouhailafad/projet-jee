<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Equipe, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Equipe> equipes = (List<Equipe>) request.getAttribute("equipes");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Équipes</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { padding: 30px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; }
        th { background: #2c3e50; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        tr:hover { background: #f9f9f9; }
        .btn-add { background: #27ae60; color: white; font-size: 14px; padding: 10px 20px; margin-bottom: 20px; display: inline-block; border-radius: 5px; text-decoration: none; cursor: pointer; border: none; }
        .modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; }
        .modal.active { display:flex; }
        .modal-box { background:white; padding:30px; border-radius:10px; width:400px; }
        .modal-box input, .modal-box textarea { width:100%; padding:8px; margin:6px 0 12px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box; }
        .modal-box button { width:100%; padding:10px; background:#2c3e50; color:white; border:none; border-radius:5px; cursor:pointer; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2 style="margin:0">🔬 Laboratoire LIAS</h2>
        <div>
            <a href="index.jsp">🏠 Accueil</a>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="affiliations">🏷️ Affiliations</a>
            <a href="login.jsp">Déconnexion</a>
        </div>
    </div>
    <div class="content">
        <h2>🧩 Gestion des équipes de recherche</h2>
        <button class="btn-add" onclick="document.getElementById('modal').classList.add('active')">+ Ajouter une équipe</button>
        <br/><br/>
        <table>
            <tr>
                <th>Nom de l'équipe</th>
                <th>Description</th>
                <th>Date de création</th>
                <th>Actions</th>
            </tr>
            <% if(equipes != null) { for(Equipe e : equipes) { %>
            <tr>
                <td><%= e.getNom() %></td>
                <td><%= e.getDescription() != null ? e.getDescription() : "-" %></td>
                <td><%= e.getDateCreation() != null ? e.getDateCreation().toString() : "-" %></td>
                <td>
                    <a href="affiliations?equipeId=<%= e.getId() %>" style="background:#2980b9;color:white;padding:5px 10px;border-radius:5px;text-decoration:none;font-size:12px;">👥 Voir les membres</a>
                </td>
            </tr>
            <% }} %>
        </table>
    </div>

    <!-- Modal Ajouter -->
    <div class="modal" id="modal">
        <div class="modal-box">
            <h3>Ajouter une équipe</h3>
            <form action="equipes" method="post">
                <input type="hidden" name="action" value="ajouter"/>
                <input type="text" name="nom" placeholder="Nom de l'équipe" required/>
                <textarea name="description" placeholder="Description (optionnel)" rows="3"></textarea>
                <button type="submit">Ajouter</button>
            </form>
            <br>
            <button onclick="document.getElementById('modal').classList.remove('active')" style="background:#e74c3c;color:white;width:100%;padding:10px;border-radius:5px;border:none;cursor:pointer;">Annuler</button>
        </div>
    </div>
</body>
</html>