<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Evenement, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Evenement> evenements = (List<Evenement>) request.getAttribute("evenements");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Événements</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { padding: 30px; }
        .cards { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
        .card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        .card h3 { color: #2c3e50; margin-top: 0; }
        .type { padding: 4px 10px; border-radius: 10px; font-size: 12px; display: inline-block; margin-bottom: 10px; }
        .conference { background: #d5f5e3; color: #1e8449; }
        .seminaire { background: #d6eaf8; color: #1a5276; }
        .workshop { background: #fdebd0; color: #784212; }
        .btn-add { background: #27ae60; color: white; padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; margin-bottom: 20px; font-size: 14px; }
        .modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; }
        .modal.active { display:flex; }
        .modal-box { background:white; padding:30px; border-radius:10px; width:450px; }
        .modal-box input, .modal-box select, .modal-box textarea { width:100%; padding:8px; margin:6px 0 12px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box; }
        .modal-box button { width:100%; padding:10px; background:#2c3e50; color:white; border:none; border-radius:5px; cursor:pointer; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2 style="margin:0">🔬 Laboratoire LIAS</h2>
        <div>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="membres">Membres</a>
            <a href="login.jsp">Déconnexion</a>
        </div>
    </div>
    <div class="content">
        <h2>📅 Gestion des événements</h2>
        <button class="btn-add" onclick="document.getElementById('modal').classList.add('active')">+ Ajouter un événement</button>
        <div class="cards">
            <% if(evenements != null) { for(Evenement e : evenements) { %>
            <div class="card">
                <span class="type <%= e.getType() %>"><%= e.getType() %></span>
                <h3><%= e.getTitre() %></h3>
                <p>📍 <%= e.getLieu() != null ? e.getLieu() : "Non défini" %></p>
                <p>📆 <%= e.getDateDebut() %></p>
                <p><%= e.getDescription() != null ? e.getDescription() : "" %></p>
            </div>
            <% }} %>
        </div>
    </div>
    <div class="modal" id="modal">
        <div class="modal-box">
            <h3>Ajouter un événement</h3>
            <form action="evenements" method="post">
                <input type="hidden" name="action" value="ajouter"/>
                <input type="text" name="titre" placeholder="Titre" required/>
                <select name="type">
                    <option value="conference">Conférence</option>
                    <option value="seminaire">Séminaire</option>
                    <option value="workshop">Workshop</option>
                </select>
                <textarea name="description" placeholder="Description" rows="3"></textarea>
                <label>Date début:</label>
                <input type="date" name="dateDebut" required/>
                <label>Date fin:</label>
                <input type="date" name="dateFin"/>
                <input type="text" name="lieu" placeholder="Lieu"/>
                <button type="submit">Ajouter</button>
            </form>
            <br>
            <button onclick="document.getElementById('modal').classList.remove('active')" style="background:#e74c3c;color:white;width:100%;padding:10px;border-radius:5px;border:none;cursor:pointer;">Annuler</button>
        </div>
    </div>
</body>
</html>