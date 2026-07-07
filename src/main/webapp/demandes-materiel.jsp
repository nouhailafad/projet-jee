<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.DemandeMateriel, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<DemandeMateriel> demandes = (List<DemandeMateriel>) request.getAttribute("demandes");
    Boolean isAdmin = (Boolean) request.getAttribute("isAdmin");
    if(isAdmin == null) isAdmin = false;
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Besoins en matériel</title>
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
        .statut-badge { padding: 4px 10px; border-radius: 10px; font-size: 12px; font-weight: bold; }
        .en_attente { background: #fdebd0; color: #784212; }
        .acceptee { background: #d5f5e3; color: #1e8449; }
        .refusee { background: #fadbd8; color: #922b21; }
        .modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; }
        .modal.active { display:flex; }
        .modal-box { background:white; padding:30px; border-radius:10px; width:420px; }
        .modal-box input, .modal-box textarea { width:100%; padding:8px; margin:6px 0 12px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box; }
        .modal-box button { width:100%; padding:10px; background:#2c3e50; color:white; border:none; border-radius:5px; cursor:pointer; }
        .btn-accepter { background:#27ae60; color:white; border:none; padding:6px 12px; border-radius:5px; cursor:pointer; font-size:12px; margin-right:5px; }
        .btn-refuser { background:#e74c3c; color:white; border:none; padding:6px 12px; border-radius:5px; cursor:pointer; font-size:12px; }
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
        <h2>🖥️ Besoins en matériel</h2>

        <% if(!isAdmin) { %>
        <button class="btn-add" onclick="document.getElementById('modal').classList.add('active')">+ Soumettre une demande</button>
        <% } %>

        <table>
            <tr>
                <% if(isAdmin) { %><th>Membre</th><% } %>
                <th>Matériel demandé</th>
                <th>Description</th>
                <th>Statut</th>
                <th>Date demande</th>
                <% if(isAdmin) { %><th>Actions</th><% } %>
            </tr>
            <% if(demandes != null) { for(DemandeMateriel d : demandes) { %>
            <tr>
                <% if(isAdmin) { %><td><%= d.getPrenomMembre() %> <%= d.getNomMembre() %></td><% } %>
                <td><%= d.getNomMateriel() %></td>
                <td><%= d.getDescription() != null ? d.getDescription() : "-" %></td>
                <td><span class="statut-badge <%= d.getStatut() %>"><%= d.getStatut() %></span></td>
                <td><%= d.getDateDemande() %></td>
                <% if(isAdmin) { %>
                <td>
                    <% if("en_attente".equals(d.getStatut())) { %>
                    <form action="demandes-materiel" method="post" style="display:inline">
                        <input type="hidden" name="action" value="accepter"/>
                        <input type="hidden" name="id" value="<%= d.getId() %>"/>
                        <button type="submit" class="btn-accepter">✅ Accepter</button>
                    </form>
                    <form action="demandes-materiel" method="post" style="display:inline">
                        <input type="hidden" name="action" value="refuser"/>
                        <input type="hidden" name="id" value="<%= d.getId() %>"/>
                        <button type="submit" class="btn-refuser">❌ Refuser</button>
                    </form>
                    <% } else { %>
                        <span style="color:#999;font-size:12px;">Décision prise</span>
                    <% } %>
                </td>
                <% } %>
            </tr>
            <% }} %>
        </table>
    </div>

    <!-- Modal Soumettre -->
    <div class="modal" id="modal">
        <div class="modal-box">
            <h3>Soumettre une demande de matériel</h3>
            <form action="demandes-materiel" method="post">
                <input type="hidden" name="action" value="soumettre"/>
                <input type="text" name="nomMateriel" placeholder="Matériel souhaité (ex: Ordinateur portable)" required/>
                <textarea name="description" placeholder="Description / justification (optionnel)" rows="3"></textarea>
                <button type="submit">Soumettre</button>
            </form>
            <br>
            <button onclick="document.getElementById('modal').classList.remove('active')" style="background:#e74c3c;color:white;width:100%;padding:10px;border-radius:5px;border:none;cursor:pointer;">Annuler</button>
        </div>
    </div>
</body>
</html>