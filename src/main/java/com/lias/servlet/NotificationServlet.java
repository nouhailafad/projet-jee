package com.lias.servlet;

import com.lias.dao.NotificationDAO;
import com.lias.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur u = (Utilisateur) request.getSession().getAttribute("utilisateur");
        if(u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if("lireTout".equals(action)) {
            new NotificationDAO().marquerToutesLues(u.getId());
            response.sendRedirect("notifications");
            return;
        }

        List<Map<String, String>> notifications = new NotificationDAO().getNotifications(u.getId());
        request.setAttribute("notifications", notifications);
        request.getRequestDispatcher("/notifications.jsp").forward(request, response);
    }
}