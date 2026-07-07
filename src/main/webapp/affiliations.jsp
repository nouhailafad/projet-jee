<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.lias.model.Affiliation, java.util.List" %>
<%
    if(session.getAttribute("utilisateur") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    List<Affiliation> actuelles = (List<Affiliation>) request.getAttribute("actuelles");
    List<Affiliation> historique = (List<Affiliation>) request.getAttribute("historique");
    List<Affiliation> membresEquipe = (List<Affiliation>) request.getAttribute("membresEquipe");
%>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Affiliations</title>
    <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; }
        .content { padding: 30px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; margin-bottom: 30px; }
        th { background: #2c3e50; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        tr:hover { background: #f9f9f9; }
        .btn-add { background: #27ae60; color: white; font-size: 14px; padding: 10px 20px; margin-bottom: 20px; display: inline-block; border-radius: 5px; text-decoration: none; cursor: pointer; border: none; }
        .en-cours { background: #d5f5e3; color: #1e8449; padding: 4px 8px; border-radius: 10px; font-size: 12px; }
        .terminee { background: #eaecee; color: #5d6d7e; padding: 4px 8px; border-radius: 10px; font-size: 12px; }
        .modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); justify-content:center; align-items:center; }
        .modal.active { display:flex; }
        .modal-box { background:white; padding:30px; border-radius:10px; width:400px; }
        .modal-box input, .modal-box select { width:100%; padding:8px; margin:6px 0 12px; border:1px solid #ddd; border-radius:5px; box-sizing:border-box; }
        .modal-box button { width:100%; padding:10px; background:#2c3e50; color:white; border:none; border-radius:5px; cursor:pointer; }
        .btn-terminer { background:#e74c3c; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer; font-size:12px; }
        .btn-historique { background:#2980b9; color:white; border:none; padding:5px 10px; border-radius:5px; cursor:pointer; font-size:12px; text-decoration:none; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2 style="margin:0">🔬 Laboratoire LIAS</h2>
        <div>
            <a href="index.jsp">🏠 Accueil</a>
            <a href="dashboard.jsp">Dashboard</a>
            <a href="equipes">🧩 Équipes</a>
            <a href="login.jsp">Déconnexion</a>
        </div>
    </div>
    <div class="content">

        <% if(historique != null) { %>
            <h2>🏷️ Historique d'affiliation du membre</h2>
            <a href="affiliations" class="btn-historique" style="margin-bottom:20px;display:inline-block;">⬅ Retour à la vue d'ensemble</a>
            <table>
                <tr>
                    <th>Équipe</th>
                    <th>Date début</th>
                    <th>Date fin</th>
                    <th>Statut</th>
                </tr>
                <% for(Affiliation a : historique) { %>
                <tr>
                    <td><%= a.getNomEquipe() %></td>
                    <td><%= a.getDateDebut() %></td>
                    <td><%= a.getDateFin() != null ? a.getDateFin().toString() : "-" %></td>
                    <td>
                        <% if(a.getDateFin() == null) { %>
                            <span class="en-cours">En cours</span>
                        <% } else { %>
                            <span class="terminee">Terminée</span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
            </table>

        <% } else if(membresEquipe != null) { %>
            <h2>🏷️ Membres de l'équipe <%= membresEquipe.size() > 0 ? membresEquipe.get(0).getNomEquipe() : "" %></h2>
            <a href="equipes" class="btn-historique" style="margin-bottom:20px;display:inline-block;">⬅ Retour aux équipes</a>
            <table>
                <tr>
                    <th>Membre</th>
                    <th>Depuis le</th>
                </tr>
                <% if(membresEquipe.size() == 0) { %>
                <tr><td colspan="2">Aucun membre actuellement affilié à cette équipe.</td></tr>
                <% } %>
                <% for(Affiliation a : membresEquipe) { %>
                <tr>
                    <td><%= a.getPrenomMembre() %> <%= a.getNomMembre() %></td>
                    <td><%= a.getDateDebut() %></td>
                </tr>
                <% } %>
            </table>

        <% } else { %>
            <h2>🏷️ Affiliations aux équipes (vue d'ensemble)</h2>
            <button class="btn-add" onclick="document.getElementById('modal').classList.add('active')">+ Affecter un membre à une équipe</button>
            <br/><br/>
            <table>
                <tr>
                    <th>Membre</th>
                    <th>Équipe</th>
                    <th>Depuis le</th>
                    <th>Actions</th>
                </tr>
                <% if(actuelles != null) { for(Affiliation a : actuelles) { %>
                <tr>
                    <td><%= a.getPrenomMembre() %> <%= a.getNomMembre() %></td>
                    <td><%= a.getNomEquipe() %></td>
                    <td><%= a.getDateDebut() %></td>
                    <td>
                        <a href="affiliations?membreId=<%= a.getUtilisateurId() %>" class="btn-historique">📜 Historique</a>
                        <form action="affiliations" method="post" style="display:inline">
                            <input type="hidden" name="action" value="terminer"/>
                            <input type="hidden" name="utilisateurId" value="<%= a.getUtilisateurId() %>"/>
                            <button type="submit" class="btn-terminer" onclick="return confirm('Mettre fin à cette affiliation ?')">Faire quitter l'équipe</button>
                        </form>
                    </td>
                </tr>
                <% }} %>
            </table>
        <% } %>

    </div>

    <!-- Modal Affecter -->
    <div class="modal" id="modal">
        <div class="modal-box">
            <h3>Affecter un membre à une équipe</h3>
            <form action="affiliations" method="post">
                <input type="hidden" name="action" value="affecter"/>
                <label>ID du membre</label>
                <input type="number" name="utilisateurId" placeholder="ID du membre (voir page Membres)" required/>
                <label>ID de l'équipe</label>
                <input type="number" name="equipeId" placeholder="ID de l'équipe (voir page Équipes)" required/>
                <button type="submit">Affecter</button>
            </form>
            <br>
            <button onclick="document.getElementById('modal').classList.remove('active')" style="background:#e74c3c;color:white;width:100%;padding:10px;border-radius:5px;border:none;cursor:pointer;">Annuler</button>
        </div>
    </div>
</body>
</html>