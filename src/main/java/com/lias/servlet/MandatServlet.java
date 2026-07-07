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
        MandatDAO dao = new MandatDAO();

        if("ajouter".equals(action)) {
            int utilisateurId = Integer.parseInt(request.getParameter("utilisateurId"));

            // On ferme d'abord le mandat actif de ce membre (s'il en a un),
            // pour ne jamais avoir deux mandats "en cours" en même temps pour la même personne
            dao.terminerMandatActif(utilisateurId);

            Mandat m = new Mandat();
            m.setUtilisateurId(utilisateurId);
            m.setRole(request.getParameter("role"));
            m.setDateDebut(request.getParameter("dateDebut"));
            m.setDateFin(null);
            dao.ajouterMandat(m);
        } else if("terminer".equals(action)) {
            int utilisateurId = Integer.parseInt(request.getParameter("utilisateurId"));
            dao.terminerMandatActif(utilisateurId);
        }

        response.sendRedirect("mandats");
    }
}