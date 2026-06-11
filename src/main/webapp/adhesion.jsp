<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Demande d'adhésion</title>
   <style>
        body { font-family: Arial; margin: 0; background: #f0f0f0; }
        .navbar { background: #2c3e50; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { color: white; text-decoration: none; }
        .content { max-width: 600px; margin: 50px auto; background: white; padding: 40px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #2c3e50; margin-bottom: 20px; }
        input, textarea, select { width: 100%; padding: 10px; margin: 6px 0 15px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #2c3e50; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }
        .success { background: #d5f5e3; color: #1e8449; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="navbar">
        <h2 style="margin:0">🔬 Laboratoire LIAS</h2>
        <a href="index.jsp">← Retour</a>
    </div>
    <div class="content">
        <h2>📝 Demande d'adhésion</h2>
        <% if("ok".equals(request.getParameter("statut"))) { %>
            <div class="success">✅ Votre demande a été envoyée! Le directeur va la traiter.</div>
        <% } %>
          <form action="adhesion" method="post">
            <input type="hidden" name="action" value="soumettre"/>
            <input type="text" name="nom" placeholder="Nom" required/>
            <input type="text" name="prenom" placeholder="Prénom" required/>
            <input type="email" name="email" placeholder="Email" required/>
            <textarea name="motivation" placeholder="Lettre de motivation..." rows="5" required></textarea>
             <select name="typeStatut">
               <option value="permanent">Permanent</option>
               <option value="associe">Associé</option>
               <option value="doctorant">Doctorant</option>
             </select>
<button type="submit">Envoyer la demande</button>
        </form>
    </div>
</body>
</html>