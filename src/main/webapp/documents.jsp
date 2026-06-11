<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Document, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Document> documents = (List<Document>) request.getAttribute("documents");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Documents</title>
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
        .type { padding: 4px 8px; border-radius: 10px; font-size: 12px; background: #d6eaf8; color: #1a5276; }
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
            <a href="dashboard.jsp">Dashboard</a>
            <a href="membres">Membres</a>
            <a href="evenements">Événements</a>
            <a href="publications">Publications</a>
            <a href="login.jsp">Déconnexion</a>
        </div>
    </div>
    <div class="content">
        <h2>📁 Gestion des documents</h2>
        <button class="btn-add" onclick="document.getElementById('modal').classList.add('active')">+ Ajouter un document</button>
        <table>
            <tr>
                <th>Nom</th>
                <th>Type</th>
                <th>Chemin</th>
                <th>Date upload</th>
            </tr>
            <% if(documents != null) { for(Document d : documents) { %>
            <tr>
                <td><%= d.getNom() %></td>
                <td><span class="type"><%= d.getType() %></span></td>
                <td><%= d.getChemin() != null ? d.getChemin() : "-" %></td>
                <td><%= d.getDateUpload() != null ? d.getDateUpload() : "-" %></td>
            </tr>
            <% }} %>
        </table>
    </div>
    <div class="modal" id="modal">
        <div class="modal-box">
            <h3>Ajouter un document</h3>
            <form action="documents" method="post">
                <input type="hidden" name="action" value="ajouter"/>
                <input type="text" name="nom" placeholder="Nom du document" required/>
                <select name="type">
                    <option value="financement">Financement</option>
                    <option value="programme">Programme</option>
                    <option value="attestation">Attestation</option>
                    <option value="rapport">Rapport</option>
                    <option value="administratif">Administratif</option>
                </select>
                <input type="text" name="chemin" placeholder="Chemin ou lien du fichier"/>
                <button type="submit">Ajouter</button>
            </form>
            <br>
            <button onclick="document.getElementById('modal').classList.remove('active')" style="background:#e74c3c;color:white;width:100%;padding:10px;border-radius:5px;border:none;cursor:pointer;">Annuler</button>
        </div>
    </div>
</body>
</html>