<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Mandat, com.lias.model.Utilisateur, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Mandat> mandats = (List<Mandat>) request.getAttribute("mandats");
    List<Utilisateur> membres = (List<Utilisateur>) request.getAttribute("membres");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Mandats</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { padding: 30px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; }
        th { background: #2c3e50; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        tr:hover { background: #f9f9f9; }
        .btn-add { background: #27ae60; color: white; padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; margin-bottom: 20px; font-size: 14px; }
        .role { padding: 4px 10px; border-radius: 10px; font-size: 12px; font-weight: bold; }
        .directeur { background: #fadbd8; color: #922b21; }
        .vice_directeur { background: #fdebd0; color: #784212; }
        .chef_equipe { background: #d5f5e3; color: #1e8449; }
        .membre { background: #d6eaf8; color: #1a5276; }
        .modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; }
        .modal.active { display:flex; }
        .modal-box { background:white; padding:30px; border-radius:10px; width:450px; }
        .modal-box input, .modal-box select { width:100%; padding:8px; margin:6px 0 12px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box; }
        .modal-box button { width:100%; padding:10px; background:#2c3e50; color:white; border:none; border-radius:5px; cursor:pointer; }
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
        <h2>🏛️ Gestion des mandats</h2>
        <button class="btn-add" onclick="document.getElementById('modal').classList.add('active')">+ Ajouter un mandat</button>
        <table>
            <tr>
                <th>Membre</th>
                <th>Rôle</th>
                <th>Date début</th>
                <th>Date fin</th>
            </tr>
            <% if(mandats != null) { for(Mandat m : mandats) { %>
            <tr>
                <td><%= m.getPrenomMembre() %> <%= m.getNomMembre() %></td>
                <td><span class="role <%= m.getRole() %>"><%= m.getRole() %></span></td>
                <td><%= m.getDateDebut() %></td>
                <td><%= m.getDateFin() != null ? m.getDateFin() : "En cours" %></td>
            </tr>
            <% }} %>
        </table>
    </div>
    <div class="modal" id="modal">
        <div class="modal-box">
            <h3>Ajouter un mandat</h3>
            <form action="mandats" method="post">
                <input type="hidden" name="action" value="ajouter"/>
                <select name="utilisateurId">
                    <% if(membres != null) { for(Utilisateur u : membres) { %>
                    <option value="<%= u.getId() %>"><%= u.getPrenom() %> <%= u.getNom() %></option>
                    <% }} %>
                </select>
                <select name="role">
                    <option value="directeur">Directeur</option>
                    <option value="vice_directeur">Vice-directeur</option>
                    <option value="chef_equipe">Chef d'équipe</option>
                    <option value="membre">Membre</option>
                </select>
                <label>Date début:</label>
                <input type="date" name="dateDebut" required/>
                <label>Date fin (optionnel):</label>
                <input type="date" name="dateFin"/>
                <button type="submit">Ajouter</button>
            </form>
            <br>
            <button onclick="document.getElementById('modal').classList.remove('active')" style="background:#e74c3c;color:white;width:100%;padding:10px;border-radius:5px;border:none;cursor:pointer;">Annuler</button>
        </div>
    </div>
</body>
</html>