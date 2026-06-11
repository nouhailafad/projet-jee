package com.lias.servlet;

import com.lias.dao.*;
import com.lias.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/recherche")
public class RechercheServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String mot = request.getParameter("mot");

        if(mot != null && !mot.trim().isEmpty()) {
            List<Utilisateur> membres = new UtilisateurDAO().rechercher(mot);
            List<Evenement> evenements = new EvenementDAO().rechercher(mot);
            List<Publication> publications = new PublicationDAO().rechercher(mot);

            request.setAttribute("membres", membres);
            request.setAttribute("evenements", evenements);
            request.setAttribute("publications", publications);
            request.setAttribute("mot", mot);
        }

        request.getRequestDispatcher("/recherche.jsp").forward(request, response);
    }
}