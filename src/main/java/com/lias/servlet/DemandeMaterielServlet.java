package com.lias.servlet;

import com.lias.dao.DemandeMaterielDAO;
import com.lias.model.DemandeMateriel;
import com.lias.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/demandes-materiel")
public class DemandeMaterielServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
        if(u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        DemandeMaterielDAO dao = new DemandeMaterielDAO();
        boolean isAdmin = "permanent".equals(u.getStatut());

        if(isAdmin) {
            // Les permanents (direction) voient toutes les demandes pour pouvoir les valider
            List<DemandeMateriel> demandes = dao.getAllDemandes();
            request.setAttribute("demandes", demandes);
        } else {
            // Les autres membres ne voient que leurs propres demandes
            List<DemandeMateriel> demandes = dao.getDemandesParMembre(u.getId());
            request.setAttribute("demandes", demandes);
        }
        request.setAttribute("isAdmin", isAdmin);

        request.getRequestDispatcher("/demandes-materiel.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
        if(u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        DemandeMaterielDAO dao = new DemandeMaterielDAO();

        if("soumettre".equals(action)) {
            DemandeMateriel d = new DemandeMateriel();
            d.setUtilisateurId(u.getId());
            d.setNomMateriel(request.getParameter("nomMateriel"));
            d.setDescription(request.getParameter("description"));
            dao.soumettreDemande(d);
        } else if("accepter".equals(action)) {
            // Seul un permanent (direction) peut valider une demande
            if("permanent".equals(u.getStatut())) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.accepterDemande(id);
            }
        } else if("refuser".equals(action)) {
            if("permanent".equals(u.getStatut())) {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.refuserDemande(id);
            }
        }

        response.sendRedirect("demandes-materiel");
    }
}