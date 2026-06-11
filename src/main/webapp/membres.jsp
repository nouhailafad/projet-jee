<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Utilisateur, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Utilisateur> membres = (List<Utilisateur>) request.getAttribute("membres");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Membres</title>
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
        .statut { padding: 4px 8px; border-radius: 10px; font-size: 12px; }
        .permanent { background: #d5f5e3; color: #1e8449; }
        .doctorant { background: #d6eaf8; color: #1a5276; }
        .associe { background: #fdebd0; color: #784212; }
        .modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; }
        .modal.active { display:flex; }
        .modal-box { background:white; padding:30px; border-radius:10px; width:400px; }
        .modal-box input, .modal-box select { width:100%; padding:8px; margin:6px 0 12px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box; }
        .modal-box button { width:100%; padding:10px; background:#2c3e50; color:white; border:none; border-radius:5px; cursor:pointer; }
        .btn-desactiver { background:#e74c3c; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer; font-size:12px; }
        .btn-reactiver { background:#27ae60; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer; font-size:12px; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2 style="margin:0">🔬 Laboratoire LIAS</h2>
        <div>
            <a href="index.jsp">🏠 Accueil</a>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="login.jsp">Déconnexion</a>
        </div>
    </div>
    <div class="content">
        <h2>👥 Gestion des membres</h2>
        <button class="btn-add" onclick="document.getElementById('modal').classList.add('active')">+ Ajouter un membre</button>
        <br/><br/>
        <table>
            <tr>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Email</th>
                <th>Statut</th>
                <th>Actif</th>
                <th>Actions</th>
            </tr>
            <% if(membres != null) { for(Utilisateur m : membres) { %>
            <tr>
                <td><%= m.getNom() %></td>
                <td><%= m.getPrenom() %></td>
                <td><%= m.getEmail() %></td>
                <td><span class="statut <%= m.getStatut() %>"><%= m.getStatut() %></span></td>
                <td><%= m.isActif() ? "✅" : "❌" %></td>
                <td>
                    <% if(m.isActif()) { %>
                    <form action="membres" method="post" style="display:inline">
                        <input type="hidden" name="action" value="desactiver"/>
                        <input type="hidden" name="id" value="<%= m.getId() %>"/>
                        <button type="submit" class="btn-desactiver">🔒 Désactiver</button>
                    </form>
                    <% } else { %>
                    <form action="membres" method="post" style="display:inline">
                        <input type="hidden" name="action" value="reactiver"/>
                        <input type="hidden" name="id" value="<%= m.getId() %>"/>
                        <button type="submit" class="btn-reactiver">🔓 Réactiver</button>
                    </form>
                    <% } %>
                </td>
            </tr>
            <% }} %>
        </table>
    </div>

    <!-- Modal Ajouter -->
    <div class="modal" id="modal">
        <div class="modal-box">
            <h3>Ajouter un membre</h3>
            <form action="membres" method="post">
                <input type="hidden" name="action" value="ajouter"/>
                <input type="text" name="nom" placeholder="Nom" required/>
                <input type="text" name="prenom" placeholder="Prénom" required/>
                <input type="email" name="email" placeholder="Email" required/>
                <input type="password" name="motDePasse" placeholder="Mot de passe" required/>
                <input type="text" name="etablissement" placeholder="Établissement"/>
                <select name="statut">
                    <option value="permanent">Permanent</option>
                    <option value="associe">Associé</option>
                    <option value="doctorant">Doctorant</option>
                </select>
                <button type="submit">Ajouter</button>
            </form>
            <br>
            <button onclick="document.getElementById('modal').classList.remove('active')" style="background:#e74c3c;color:white;width:100%;padding:10px;border-radius:5px;border:none;cursor:pointer;">Annuler</button>
        </div>
    </div>
</body>
</html>





