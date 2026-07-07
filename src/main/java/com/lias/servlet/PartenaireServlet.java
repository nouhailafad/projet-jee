package com.lias.servlet;

import com.lias.dao.PartenaireDAO;
import com.lias.model.Partenaire;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/partenaires")
public class PartenaireServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.setAttribute("partenaires", new PartenaireDAO().getAllPartenaires());
        request.getRequestDispatcher("/partenaires.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if("ajouter".equals(action)) {
            Partenaire p = new Partenaire();
            p.setNom(request.getParameter("nom"));
            p.setType(request.getParameter("type"));
            p.setContact(request.getParameter("contact"));
            new PartenaireDAO().ajouterPartenaire(p);
        }
        response.sendRedirect("partenaires");
    }
}