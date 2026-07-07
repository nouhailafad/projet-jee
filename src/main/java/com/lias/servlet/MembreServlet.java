package com.lias.servlet;
import com.lias.dao.UtilisateurDAO;
import com.lias.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
@WebServlet("/membres")
public class MembreServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        UtilisateurDAO dao = new UtilisateurDAO();
        List<Utilisateur> membres = dao.getAllMembres();
        request.setAttribute("membres", membres);
        request.getRequestDispatcher("/membres.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if("ajouter".equals(action)) {
            Utilisateur u = new Utilisateur();
            u.setNom(request.getParameter("nom"));
            u.setPrenom(request.getParameter("prenom"));
            u.setEmail(request.getParameter("email"));
            u.setMotDePasse(request.getParameter("motDePasse"));
            u.setStatut(request.getParameter("statut"));
            u.setEtablissement(request.getParameter("etablissement"));

            String dn = request.getParameter("dateNaissance");
            if(dn != null && !dn.isEmpty()) {
                u.setDateNaissance(Date.valueOf(dn));
            }
            String de = request.getParameter("dateEmbauche");
            if(de != null && !de.isEmpty()) {
                u.setDateEmbauche(Date.valueOf(de));
            }

            new UtilisateurDAO().ajouterMembre(u);
        } else if("desactiver".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            new UtilisateurDAO().desactiverMembre(id);
        } else if("reactiver".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            new UtilisateurDAO().reactiverMembre(id);
        } else if("retraite".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            new UtilisateurDAO().mettreEnRetraite(id);
        } else if("ancien".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            new UtilisateurDAO().marquerAncienMembre(id);
        } else if("reactiverAvecStatut".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String nouveauStatut = request.getParameter("nouveauStatut");
            new UtilisateurDAO().reactiverAvecStatut(id, nouveauStatut);
        }
        response.sendRedirect("membres");
    }
}