package com.lias.servlet;

import com.lias.dao.AffiliationDAO;
import com.lias.model.Affiliation;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/affiliations")
public class AffiliationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        AffiliationDAO dao = new AffiliationDAO();
        String membreIdParam = request.getParameter("membreId");
        String equipeIdParam = request.getParameter("equipeId");

        if(membreIdParam != null && !membreIdParam.isEmpty()) {
            // Affichage de l'historique d'un membre précis
            int membreId = Integer.parseInt(membreIdParam);
            List<Affiliation> historique = dao.getHistoriqueParMembre(membreId);
            request.setAttribute("historique", historique);
            request.setAttribute("membreId", membreId);
        } else if(equipeIdParam != null && !equipeIdParam.isEmpty()) {
            // Affichage des membres d'une équipe précise
            int equipeId = Integer.parseInt(equipeIdParam);
            List<Affiliation> membresEquipe = dao.getMembresParEquipe(equipeId);
            request.setAttribute("membresEquipe", membresEquipe);
        } else {
            // Vue d'ensemble : toutes les affiliations actuelles
            List<Affiliation> actuelles = dao.getToutesAffiliationsActuelles();
            request.setAttribute("actuelles", actuelles);
        }

        request.getRequestDispatcher("/affiliations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        AffiliationDAO dao = new AffiliationDAO();

        if("affecter".equals(action)) {
            int utilisateurId = Integer.parseInt(request.getParameter("utilisateurId"));
            int equipeId = Integer.parseInt(request.getParameter("equipeId"));
            // On termine l'affiliation active avant d'en ouvrir une nouvelle,
            // pour éviter qu'un membre se retrouve dans deux équipes "actives" en même temps
            dao.terminerAffiliationActive(utilisateurId);
            dao.affecterEquipe(utilisateurId, equipeId);
        } else if("terminer".equals(action)) {
            int utilisateurId = Integer.parseInt(request.getParameter("utilisateurId"));
            dao.terminerAffiliationActive(utilisateurId);
        }

        response.sendRedirect("affiliations");
    }
}