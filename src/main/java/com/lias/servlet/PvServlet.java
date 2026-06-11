package com.lias.servlet;

import com.lias.dao.PvReunionDAO;
import com.lias.model.PvReunion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/pv")
public class PvServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        PvReunionDAO dao = new PvReunionDAO();
        List<PvReunion> pvList = dao.getAllPv();
        request.setAttribute("pvList", pvList);
        request.getRequestDispatcher("/pv.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if("ajouter".equals(action)) {
            PvReunion pv = new PvReunion();
            pv.setTitre(request.getParameter("titre"));
            pv.setOrdreduJour(request.getParameter("ordreduJour"));
            pv.setDateReunion(request.getParameter("dateReunion"));
            pv.setCheminPv(request.getParameter("cheminPv"));
            new PvReunionDAO().ajouterPv(pv);
        }

        response.sendRedirect("pv");
    }
}