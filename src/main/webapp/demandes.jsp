<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Map<String, String>> demandes = (List<Map<String, String>>) request.getAttribute("demandes");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Demandes d'adhésion</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { padding: 30px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; }
        th { background: #2c3e50; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; vertical-align: top; }
        tr:hover { background: #f9f9f9; }
        .statut { padding: 4px 10px; border-radius: 10px; font-size: 12px; font-weight: bold; }
        .en_attente { background: #fdebd0; color: #784212; }
        .acceptee { background: #d5f5e3; color: #1e8449; }
        .refusee { background: #fadbd8; color: #922b21; }
        .btn { padding: 6px 12px; border: none; border-radius: 5px; cursor: pointer; font-size: 12px; margin: 2px; }
        .btn-ok { background: #27ae60; color: white; }
        .btn-non { background: #e74c3c; color: white; }
        .success { background: #d5f5e3; color: #1e8449; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
        .refuse { background: #fadbd8; color: #922b21; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
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
        <h2>📝 Demandes d'adhésion</h2>

        <% if("accepte".equals(request.getParameter("msg"))) { %>
            <div class="success">✅ Demande acceptée! Compte créé avec mot de passe: lias2026</div>
        <% } else if("refuse".equals(request.getParameter("msg"))) { %>
            <div class="refuse">❌ Demande refusée!</div>
        <% } %>

        <table>
            <tr>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Email</th>
                <th>Motivation</th>
                <th>Date</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
            <% if(demandes != null) { for(Map<String, String> d : demandes) { %>
            <tr>
                <td><%= d.get("nom") %></td>
                <td><%= d.get("prenom") %></td>
                <td><%= d.get("email") %></td>
                <td><%= d.get("motivation") != null ? d.get("motivation") : "-" %></td>
                <td><%= d.get("date") != null ? d.get("date").substring(0,10) : "-" %></td>
                <td><span class="statut <%= d.get("statut") %>"><%= d.get("statut") %></span></td>
                <td>
                    <% if("en_attente".equals(d.get("statut"))) { %>
                    <form action="adhesion" method="post" style="display:inline">
                        <input type="hidden" name="action" value="accepter"/>
                        <input type="hidden" name="id" value="<%= d.get("id") %>"/>
                        <button class="btn btn-ok" type="submit">✅ Accepter</button>
                    </form>
                    <form action="adhesion" method="post" style="display:inline">
                        <input type="hidden" name="action" value="refuser"/>
                        <input type="hidden" name="id" value="<%= d.get("id") %>"/>
                        <button class="btn btn-non" type="submit">❌ Refuser</button>
                    </form>
                    <% } %>
                </td>
            </tr>
            <% }} %>
        </table>
    </div>
</body>
</html>