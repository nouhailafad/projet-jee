package com.lias.servlet;

import com.lias.dao.MandatDAO;
import com.lias.dao.UtilisateurDAO;
import com.lias.model.Mandat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/mandats")
public class MandatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        List<Mandat> mandats = new MandatDAO().getAllMandats();
        request.setAttribute("mandats", mandats);
        request.setAttribute("membres", new UtilisateurDAO().getAllMembres());
        request.getRequestDispatcher("/mandats.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if("ajouter".equals(action)) {
            Mandat m = new Mandat();
            m.setUtilisateurId(Integer.parseInt(request.getParameter("utilisateurId")));
            m.setRole(request.getParameter("role"));
            m.setDateDebut(request.getParameter("dateDebut"));
            m.setDateFin(request.getParameter("dateFin"));
            new MandatDAO().ajouterMandat(m);
        }
        response.sendRedirect("mandats");
    }
}