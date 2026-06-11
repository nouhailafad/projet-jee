<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>LIAS - Connexion</title>
    <style>
        body { font-family: Arial; background: #f0f0f0; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .login-box { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 0 20px rgba(0,0,0,0.1); width: 350px; }
        h2 { text-align: center; color: #2c3e50; }
        input { width: 100%; padding: 10px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #2c3e50; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; }
        button:hover { background: #34495e; }
        .erreur { color: red; text-align: center; }
    </style>
</head>
<body>
    <div class="login-box">
        <h2>🔬 Laboratoire LIAS</h2>
        <h3 style="text-align:center; color:#777">Connexion</h3>
        <% if(request.getParameter("erreur") != null) { %>
            <p class="erreur">❌ Email ou mot de passe incorrect!</p>
        <% } %>
        <form action="login" method="post">
            <input type="email" name="email" placeholder="Email" required/>
            <input type="password" name="motDePasse" placeholder="Mot de passe" required/>
            <button type="submit">Se connecter</button>
        </form>
    </div>
</body>
</html>