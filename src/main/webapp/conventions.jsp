<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Convention, com.lias.model.Partenaire, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Convention> conventions = (List<Convention>) request.getAttribute("conventions");
    List<Partenaire> partenaires = (List<Partenaire>) request.getAttribute("partenaires");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Conventions</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { padding: 30px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; }
        th { background: #2c3e50; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; font-size: 13px; }
        tr:hover { background: #f9f9f9; }
        .btn-add { background: #27ae60; color: white; padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; margin-bottom: 20px; font-size: 14px; }
        .modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; }
        .modal.active { display:flex; }
        .modal-box { background:white; padding:30px; border-radius:10px; width:450px; max-height:90vh; overflow-y:auto; }
        .modal-box input, .modal-box select, .modal-box textarea { width:100%; padding:8px; margin:6px 0 12px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box; }
        .modal-box label { font-size:13px; color:#555; }
        .modal-box button { width:100%; padding:10px; background:#2c3e50; color:white; border:none; border-radius:5px; cursor:pointer; }
        .doc-badge { background:#d5f5e3; color:#1e8449; padding:3px 8px; border-radius:8px; font-size:11px; }
        .doc-absent { color:#999; font-size:12px; }
        .btn-archiver { background:#2980b9; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer; font-size:11px; }
        .archive-form { display:flex; gap:4px; }
        .archive-form input { margin:0; padding:5px; font-size:12px; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2 style="margin:0">🔬 Laboratoire LIAS</h2>
        <div>
            <a href="index.jsp">🏠 Accueil</a>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="partenaires">🏢 Partenaires</a>
            <a href="login.jsp">🚪 Déconnexion</a>
        </div>
    </div>
    <div class="content">
        <h2>🤝 Conventions & collaborations</h2>
        <button class="btn-add" onclick="document.getElementById('modal').classList.add('active')">+ Créer une convention</button>
        <table>
            <tr>
                <th>Partenaire</th>
                <th>Objet</th>
                <th>Début</th>
                <th>Fin</th>
                <th>Document</th>
                <th>Activités associées</th>
            </tr>
            <% if(conventions != null) { for(Convention c : conventions) { %>
            <tr>
                <td><%= c.getNomPartenaire() %></td>
                <td><%= c.getObjet() %></td>
                <td><%= c.getDateDebut() != null ? c.getDateDebut().toString() : "-" %></td>
                <td><%= c.getDateFin() != null ? c.getDateFin().toString() : "-" %></td>
                <td>
                    <% if(c.getCheminDocument() != null && !c.getCheminDocument().isEmpty()) { %>
                        <span class="doc-badge">📎 <%= c.getCheminDocument() %></span>
                    <% } else { %>
                        <form action="conventions" method="post" class="archive-form">
                            <input type="hidden" name="action" value="archiverDocument"/>
                            <input type="hidden" name="id" value="<%= c.getId() %>"/>
                            <input type="text" name="cheminDocument" placeholder="nom_fichier.pdf" required/>
                            <button type="submit" class="btn-archiver">Archiver</button>
                        </form>
                    <% } %>
                </td>
                <td><%= c.getActivitesAssociees() != null ? c.getActivitesAssociees() : "-" %></td>
            </tr>
            <% }} %>
        </table>
    </div>
    <div class="modal" id="modal">
        <div class="modal-box">
            <h3>Créer une convention</h3>
            <form action="conventions" method="post">
                <input type="hidden" name="action" value="ajouter"/>
                <label>Partenaire</label>
                <select name="partenaireId" required>
                    <option value="">-- Choisir --</option>
                    <% if(partenaires != null) { for(Partenaire p : partenaires) { %>
                    <option value="<%= p.getId() %>"><%= p.getNom() %></option>
                    <% }} %>
                </select>
                <label>Objet de la convention</label>
                <input type="text" name="objet" placeholder="Ex: Échange de chercheurs 2025-2027" required/>
                <label>Date de début</label>
                <input type="date" name="dateDebut"/>
                <label>Date de fin</label>
                <input type="date" name="dateFin"/>
                <label>Activités associées (suivi)</label>
                <textarea name="activitesAssociees" rows="3" placeholder="Ex: 2 séminaires co-organisés, 1 publication conjointe"></textarea>
                <button type="submit">Créer</button>
            </form>
            <br>
            <button onclick="document.getElementById('modal').classList.remove('active')" style="background:#e74c3c;color:white;width:100%;padding:10px;border-radius:5px;border:none;cursor:pointer;">Annuler</button>
        </div>
    </div>
</body>
</html>