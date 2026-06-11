package com.lias.servlet;

import com.lias.dao.PublicationDAO;
import com.lias.model.Publication;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/publications")
public class PublicationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        PublicationDAO dao = new PublicationDAO();
        List<Publication> publications = dao.getAllPublications();
        request.setAttribute("publications", publications);
        request.getRequestDispatcher("/publications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if("ajouter".equals(action)) {
            Publication p = new Publication();
            p.setTitre(request.getParameter("titre"));
            p.setAuteurs(request.getParameter("auteurs"));
            p.setAnnee(Integer.parseInt(request.getParameter("annee")));
            p.setType(request.getParameter("type"));
            p.setLien(request.getParameter("lien"));
            new PublicationDAO().ajouterPublication(p);
        }

        response.sendRedirect("publications");
    }
}