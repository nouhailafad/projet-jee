package com.lias.servlet;

import com.lias.dao.UtilisateurDAO;
import com.lias.model.Utilisateur;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Récupérer email et mot de passe du formulaire
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");

        // 2. Vérifier dans la BD
        UtilisateurDAO dao = new UtilisateurDAO();
        Utilisateur u = dao.login(email, motDePasse);

        // 3. Si trouvé → dashboard, sinon → erreur
        if (u != null) {
            HttpSession session = request.getSession();
            session.setAttribute("utilisateur", u);
            response.sendRedirect("dashboard.jsp");
        } else {
            response.sendRedirect("login.jsp?erreur=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}