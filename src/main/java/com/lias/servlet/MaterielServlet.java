package com.lias.servlet;

import com.lias.dao.MaterielDAO;
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
        request.getRequestDispatcher("/materiel.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if("ajouter".equals(action)) {
            Materiel m = new Materiel();
            m.setNom(request.getParameter("nom"));
            m.setDescription(request.getParameter("description"));
            m.setDateArrivage(request.getParameter("dateArrivage"));
            new MaterielDAO().ajouterMateriel(m);
        }

        response.sendRedirect("materiel");
    }
}
