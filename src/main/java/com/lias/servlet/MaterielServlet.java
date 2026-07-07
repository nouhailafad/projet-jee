package com.lias.servlet;
import com.lias.dao.MaterielDAO;
import com.lias.dao.UtilisateurDAO;
import com.lias.model.Materiel;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
@WebServlet("/materiel")
public class MaterielServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        MaterielDAO dao = new MaterielDAO();
        List<Materiel> materiels = dao.getAllMateriel();
        request.setAttribute("materiels", materiels);

        // Liste des membres, nécessaire pour le formulaire "Distribuer à..."
        request.setAttribute("membres", new UtilisateurDAO().getAllMembres());

        request.getRequestDispatcher("/materiel.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        MaterielDAO dao = new MaterielDAO();

        if("ajouter".equals(action)) {
            Materiel m = new Materiel();
            m.setNom(request.getParameter("nom"));
            m.setDescription(request.getParameter("description"));
            m.setDateArrivage(request.getParameter("dateArrivage"));
            dao.ajouterMateriel(m);
        } else if("distribuer".equals(action)) {
            int materielId = Integer.parseInt(request.getParameter("materielId"));
            int utilisateurId = Integer.parseInt(request.getParameter("utilisateurId"));
            dao.distribuer(materielId, utilisateurId);
        }

        response.sendRedirect("materiel");
    }
}