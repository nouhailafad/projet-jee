<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Publication, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Publication> publications = (List<Publication>) request.getAttribute("publications");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Publications</title>
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
        .modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; }
        .modal.active { display:flex; }
        .modal-box { background:white; padding:30px; border-radius:10px; width:450px; }
        .modal-box input, .modal-box select { width:100%; padding:8px; margin:6px 0 12px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box; }
        .modal-box button { width:100%; padding:10px; background:#2c3e50; color:white; border:none; border-radius:5px; cursor:pointer; }
        .lien a { color: #2980b9; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2 style="margin:0">🔬 Laboratoire LIAS</h2>
        <div>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="membres">Membres</a>
            <a href="evenements">Événements</a>
            <a href="login.jsp">Déconnexion</a>
        </div>
    </div>
    <div class="content">
        <h2>📚 Gestion des publications</h2>
        <button class="btn-add" onclick="document.getElementById('modal').classList.add('active')">+ Ajouter une publication</button>
        <table>
            <tr>
                <th>Titre</th>
                <th>Auteurs</th>
                <th>Année</th>
                <th>Type</th>
                <th>Lien</th>
            </tr>
            <% if(publications != null) { for(Publication p : publications) { %>
            <tr>
                <td><%= p.getTitre() %></td>
                <td><%= p.getAuteurs() %></td>
                <td><%= p.getAnnee() %></td>
                <td><%= p.getType() != null ? p.getType() : "-" %></td>
                <td class="lien">
                    <% if(p.getLien() != null && !p.getLien().isEmpty()) { %>
                        <a href="<%= p.getLien() %>" target="_blank">Voir</a>
                    <% } else { %>
                        -
                    <% } %>
                </td>
            </tr>
            <% }} %>
        </table>
    </div>
    <div class="modal" id="modal">
        <div class="modal-box">
            <h3>Ajouter une publication</h3>
            <form action="publications" method="post">
                <input type="hidden" name="action" value="ajouter"/>
                <input type="text" name="titre" placeholder="Titre" required/>
                <input type="text" name="auteurs" placeholder="Auteurs (ex: Ali, Sara...)" required/>
                <input type="number" name="annee" placeholder="Année (ex: 2025)" required/>
                <select name="type">
                    <option value="article">Article</option>
                    <option value="conference">Conférence</option>
                    <option value="these">Thèse</option>
                    <option value="rapport">Rapport</option>
                </select>
                <input type="text" name="lien" placeholder="Lien (optionnel)"/>
                <button type="submit">Ajouter</button>
            </form>
            <br>
            <button onclick="document.getElementById('modal').classList.remove('active')" style="background:#e74c3c;color:white;width:100%;padding:10px;border-radius:5px;border:none;cursor:pointer;">Annuler</button>
        </div>
    </div>
</body>
</html>