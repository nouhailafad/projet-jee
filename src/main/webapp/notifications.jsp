<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Utilisateur, java.util.List, java.util.Map" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, String>> notifications = (List<Map<String, String>>) request.getAttribute("notifications");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Notifications</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { padding: 30px; max-width: 800px; margin: 0 auto; }
        .notif { background: white; padding: 20px; border-radius: 10px; margin-bottom: 15px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); border-left: 4px solid #3498db; }
        .notif.non-lue { border-left: 4px solid #e74c3c; background: #fef9f9; }
        .notif h4 { margin: 0 0 8px; color: #2c3e50; }
        .notif p { margin: 0; color: #777; font-size: 13px; }
        .badge { background: #e74c3c; color: white; padding: 3px 8px; border-radius: 10px; font-size: 12px; }
        .btn-lire { background: #27ae60; color: white; padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; margin-bottom: 20px; font-size: 14px; text-decoration: none; display: inline-block; }
        .aucune { text-align: center; color: #999; padding: 40px; background: white; border-radius: 10px; }
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
        <h2>🔔 Mes notifications</h2>
        <a href="notifications?action=lireTout" class="btn-lire">✅ Tout marquer comme lu</a>

        <% if(notifications != null && !notifications.isEmpty()) {
            for(Map<String, String> n : notifications) {
                boolean nonLue = "0".equals(n.get("lu"));
        %>
        <div class="notif <%= nonLue ? "non-lue" : "" %>">
            <h4>
                🔔 <%= n.get("message") %>
                <% if(nonLue) { %><span class="badge">Nouveau</span><% } %>
            </h4>
            <p>📅 <%= n.get("date") != null ? n.get("date").substring(0,10) : "-" %></p>
        </div>
        <% }} else { %>
            <div class="aucune">
                <p style="font-size:40px;">🔔</p>
                <p>Aucune notification pour le moment</p>
            </div>
        <% } %>
    </div>
</body>
</html>