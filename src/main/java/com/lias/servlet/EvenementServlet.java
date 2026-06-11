package com.lias.servlet;

import com.lias.dao.EvenementDAO;
import com.lias.dao.NotificationDAO;
import com.lias.dao.UtilisateurDAO;
import com.lias.model.Evenement;
import com.lias.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/evenements")
public class EvenementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Evenement> evenements = new EvenementDAO().getAllEvenements();
        request.setAttribute("evenements", evenements);
        request.getRequestDispatcher("/evenements.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if("ajouter".equals(action)) {
            Evenement e = new Evenement();
            e.setTitre(request.getParameter("titre"));
            e.setType(request.getParameter("type"));
            e.setDescription(request.getParameter("description"));
            e.setDateDebut(request.getParameter("dateDebut"));
            e.setDateFin(request.getParameter("dateFin"));
            e.setLieu(request.getParameter("lieu"));
            new EvenementDAO().ajouterEvenement(e);

            // Notifier tous les membres ← ICI dans doPost
            List<Utilisateur> membres = new UtilisateurDAO().getAllMembres();
            NotificationDAO notifDAO = new NotificationDAO();
            for(Utilisateur membre : membres) {
                notifDAO.ajouterNotification(
                    membre.getId(),
                    "📅 Nouvel événement: " + e.getTitre() + " le " + e.getDateDebut()
                );
            }
        }

        response.sendRedirect("evenements");
    }
}