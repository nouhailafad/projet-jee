<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Partenaire, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Partenaire> partenaires = (List<Partenaire>) request.getAttribute("partenaires");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Partenaires</title>
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
        .modal-box { background:white; padding:30px; border-radius:10px; width:420px; }
        .modal-box input { width:100%; padding:8px; margin:6px 0 12px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box; }
        .modal-box button { width:100%; padding:10px; background:#2c3e50; color:white; border:none; border-radius:5px; cursor:pointer; }
        .type-badge { background:#d6eaf8; color:#1a5276; padding:4px 10px; border-radius:10px; font-size:12px; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2 style="margin:0">🔬 Laboratoire LIAS</h2>
        <div>
            <a href="index.jsp">🏠 Accueil</a>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="conventions">🤝 Conventions</a>
            <a href="login.jsp">🚪 Déconnexion</a>
        </div>
    </div>
    <div class="content">
        <h2>🏢 Partenaires</h2>
        <button class="btn-add" onclick="document.getElementById('modal').classList.add('active')">+ Ajouter un partenaire</button>
        <table>
            <tr>
                <th>Nom</th>
                <th>Type</th>
                <th>Contact</th>
            </tr>
            <% if(partenaires != null) { for(Partenaire p : partenaires) { %>
            <tr>
                <td><%= p.getNom() %></td>
                <td><span class="type-badge"><%= p.getType() != null ? p.getType() : "-" %></span></td>
                <td><%= p.getContact() != null ? p.getContact() : "-" %></td>
            </tr>
            <% }} %>
        </table>
    </div>
    <div class="modal" id="modal">
        <div class="modal-box">
            <h3>Ajouter un partenaire</h3>
            <form action="partenaires" method="post">
                <input type="hidden" name="action" value="ajouter"/>
                <input type="text" name="nom" placeholder="Nom du partenaire" required/>
                <input type="text" name="type" placeholder="Type (Université, Entreprise...)"/>
                <input type="text" name="contact" placeholder="Contact (email ou téléphone)"/>
                <button type="submit">Ajouter</button>
            </form>
            <br>
            <button onclick="document.getElementById('modal').classList.remove('active')" style="background:#e74c3c;color:white;width:100%;padding:10px;border-radius:5px;border:none;cursor:pointer;">Annuler</button>
        </div>
    </div>
</body>
</html>