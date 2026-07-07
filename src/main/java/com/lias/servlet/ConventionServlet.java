package com.lias.servlet;

import com.lias.dao.ConventionDAO;
import com.lias.dao.PartenaireDAO;
import com.lias.model.Convention;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/conventions")
public class ConventionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        request.setAttribute("conventions", new ConventionDAO().getAllConventions());
        request.setAttribute("partenaires", new PartenaireDAO().getAllPartenaires());
        request.getRequestDispatcher("/conventions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        ConventionDAO dao = new ConventionDAO();

        if("ajouter".equals(action)) {
            Convention c = new Convention();
            c.setPartenaireId(Integer.parseInt(request.getParameter("partenaireId")));
            c.setObjet(request.getParameter("objet"));
            c.setActivitesAssociees(request.getParameter("activitesAssociees"));

            String dd = request.getParameter("dateDebut");
            if(dd != null && !dd.isEmpty()) {
                c.setDateDebut(Date.valueOf(dd));
            }
            String df = request.getParameter("dateFin");
            if(df != null && !df.isEmpty()) {
                c.setDateFin(Date.valueOf(df));
            }

            dao.ajouterConvention(c);
        } else if("archiverDocument".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String cheminDocument = request.getParameter("cheminDocument");
            dao.mettreAJourDocument(id, cheminDocument);
        }

        response.sendRedirect("conventions");
    }
}