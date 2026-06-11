<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Utilisateur" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    Utilisateur profil = (Utilisateur) request.getAttribute("profil");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Mon Profil</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { max-width: 700px; margin: 30px auto; }
        .card { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; }
        label { color: #777; font-size: 13px; display: block; margin-top: 15px; }
        input, textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; margin-top: 5px; }
        textarea { height: 100px; }
        button { background: #2c3e50; color: white; padding: 12px 30px; border: none; border-radius: 5px; cursor: pointer; margin-top: 20px; font-size: 15px; }
        .success { background: #d5f5e3; color: #1e8449; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .statut { background: #d6eaf8; color: #1a5276; padding: 5px 12px; border-radius: 10px; font-size: 13px; }
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
        <% if("ok".equals(request.getParameter("msg"))) { %>
            <div class="success">✅ Profil mis à jour avec succès!</div>
        <% } %>
        <div class="card">
            <% if(profil != null) { %>
            <span class="statut"><%= profil.getStatut() %></span>
            <h2>👤 Mon Profil</h2>
            <form action="profil" method="post">
                <label>Nom</label>
                <input type="text" name="nom" value="<%= profil.getNom() %>" required/>
                <label>Prénom</label>
                <input type="text" name="prenom" value="<%= profil.getPrenom() %>" required/>
                <label>Email</label>
                <input type="email" name="email" value="<%= profil.getEmail() %>" required/>
                <label>Établissement</label>
                <input type="text" name="etablissement" value="<%= profil.getEtablissement() != null ? profil.getEtablissement() : "" %>"/>
                <label>Laboratoire d'origine</label>
                <input type="text" name="laboratoireOrigine" value="<%= profil.getLaboratoireOrigine() != null ? profil.getLaboratoireOrigine() : "" %>"/>
                <label>Biographie</label>
                <textarea name="biographie"><%= profil.getBiographie() != null ? profil.getBiographie() : "" %></textarea>
                <label>Centres d'intérêt</label>
                <textarea name="centresInteret"><%= profil.getCentresInteret() != null ? profil.getCentresInteret() : "" %></textarea>
                <button type="submit">💾 Sauvegarder</button>
            </form>
            <% } else { %>
                <p>Erreur: profil non trouvé!</p>
            <% } %>
        </div>
    </div>
</body>
</html>