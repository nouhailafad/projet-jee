package com.lias.servlet;
import com.lias.dao.UtilisateurDAO;
import com.lias.dao.HistoriqueProfilDAO;
import com.lias.model.Utilisateur;
import com.lias.model.HistoriqueProfil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/profil")
public class ProfilServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
        if(u == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        Utilisateur profil = new UtilisateurDAO().getById(u.getId());
        request.setAttribute("profil", profil);

        // Récupération de l'historique des modifications de ce profil
        List<HistoriqueProfil> historique = new HistoriqueProfilDAO().getHistoriqueParMembre(u.getId());
        request.setAttribute("historique", historique);

        request.getRequestDispatcher("/profil.jsp").forward(request, response);
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
        u.setNom(request.getParameter("nom"));
        u.setPrenom(request.getParameter("prenom"));
        u.setEmail(request.getParameter("email"));
        u.setEtablissement(request.getParameter("etablissement"));
        u.setLaboratoireOrigine(request.getParameter("laboratoireOrigine"));
        u.setBiographie(request.getParameter("biographie"));
        u.setCentresInteret(request.getParameter("centresInteret"));
        new UtilisateurDAO().modifierProfil(u);
        session.setAttribute("utilisateur", u);
        response.sendRedirect("profil?msg=ok");
    }
}