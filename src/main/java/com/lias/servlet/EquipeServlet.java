package com.lias.servlet;

import com.lias.dao.EquipeDAO;
import com.lias.model.Equipe;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/equipes")
public class EquipeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        EquipeDAO dao = new EquipeDAO();
        List<Equipe> equipes = dao.getAllEquipes();
        request.setAttribute("equipes", equipes);
        request.getRequestDispatcher("/equipes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if("ajouter".equals(action)) {
            Equipe e = new Equipe();
            e.setNom(request.getParameter("nom"));
            e.setDescription(request.getParameter("description"));
            new EquipeDAO().ajouterEquipe(e);
        }
        response.sendRedirect("equipes");
    }
}