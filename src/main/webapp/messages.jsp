<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Utilisateur, java.util.List, java.util.Map" %>
<%
    Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
    if(u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, String>> messages = (List<Map<String, String>>) request.getAttribute("messages");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Messages</title>
    <style>
    body { font-family: Arial; margin: 0; background: #f0f0f0; }
    .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
    .navbar h2 { margin: 0; }
    .navbar a { color: white; text-decoration: none; margin-left: 15px; }
    .content { max-width: 800px; margin: 30px auto; padding: 0 20px; }
    h2 { color: #2c3e50; margin-bottom: 20px; }
    .form-message { background: white; padding: 20px; border-radius: 10px; margin-bottom: 25px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    .form-message textarea { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; height: 80px; resize: none; box-sizing: border-box; }
    .form-message button { margin-top: 10px; padding: 10px 25px; background: #2c3e50; color: white; border: none; border-radius: 5px; cursor: pointer; float: right; }
    .message { background: white; padding: 20px; border-radius: 10px; margin-bottom: 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); border-left: 4px solid #3498db; }
    .message-header { display: flex; justify-content: space-between; margin-bottom: 10px; }
    .message-auteur { color: #2c3e50; font-weight: bold; }
    .message-date { color: #999; font-size: 12px; }
    .message-contenu { color: #555; line-height: 1.6; }
    .statut-badge { font-size: 11px; padding: 2px 8px; border-radius: 10px; margin-left: 8px; }
    .permanent { background: #d5f5e3; color: #1e8449; }
    .doctorant { background: #d6eaf8; color: #1a5276; }
    .associe { background: #fdebd0; color: #784212; }
    .aucun { text-align: center; color: #999; padding: 40px; background: white; border-radius: 10px; }
    .clearfix::after { content: ""; display: table; clear: both; }
</style>
</head>
<body>
    <div class="navbar">
        <h2>🔬 Laboratoire LIAS</h2>
        <div>
            <a href="index.jsp">🏠 Accueil</a>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="login.jsp">🚪 Déconnexion</a>
        </div>
    </div>
    <div class="content">
        <h2>💬 Discussion interne</h2>

        <!-- Formulaire -->
        <div class="form-message clearfix">
            <form action="messages" method="post">
                <textarea name="contenu" placeholder="Écrire un message à tous les membres..." required></textarea>
                <button type="submit">📤 Envoyer</button>
            </form>
        </div>

        <!-- Liste des messages -->
        <% if(messages != null && !messages.isEmpty()) {
            for(Map<String, String> msg : messages) {
                boolean estMoi = String.valueOf(u.getId()).equals(msg.get("id"));
        %>
        <div class="message <%= u.getNom().equals(msg.get("nom")) ? "moi" : "" %>">
            <div class="message-header">
                <span class="message-auteur">
                    👤 <%= msg.get("prenom") %> <%= msg.get("nom") %>
                    <span class="statut-badge <%= msg.get("statut") %>"><%= msg.get("statut") %></span>
                </span>
                <span class="message-date">
                    📅 <%= msg.get("date") != null ? msg.get("date").substring(0,16) : "-" %>
                </span>
            </div>
            <div class="message-contenu"><%= msg.get("contenu") %></div>
        </div>
        <% } } else { %>
            <div class="aucun">
                <p style="font-size:40px;">💬</p>
                <p>Aucun message pour le moment. Soyez le premier à écrire!</p>
            </div>
        <% } %>
    </div>
</body>
</html>