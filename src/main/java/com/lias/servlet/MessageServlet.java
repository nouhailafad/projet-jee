package com.lias.servlet;

import com.lias.model.Utilisateur;
import com.lias.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/messages")
public class MessageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur u = (Utilisateur) request.getSession().getAttribute("utilisateur");
        if(u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT m.*, u.nom, u.prenom, u.statut FROM message m " +
                        "JOIN utilisateur u ON m.utilisateur_id = u.id " +
                        "ORDER BY m.date_envoi DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            List<Map<String, String>> messages = new ArrayList<>();
            while(rs.next()) {
                Map<String, String> msg = new HashMap<>();
                msg.put("id", rs.getString("id"));
                msg.put("contenu", rs.getString("contenu"));
                msg.put("nom", rs.getString("nom"));
                msg.put("prenom", rs.getString("prenom"));
                msg.put("statut", rs.getString("statut"));
                msg.put("date", rs.getString("date_envoi"));
                messages.add(msg);
            }
            request.setAttribute("messages", messages);
            request.getRequestDispatcher("/messages.jsp").forward(request, response);
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Utilisateur u = (Utilisateur) request.getSession().getAttribute("utilisateur");
        if(u == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String contenu = request.getParameter("contenu");
        if(contenu != null && !contenu.trim().isEmpty()) {
            try {
                Connection conn = DBConnection.getConnection();
                String sql = "INSERT INTO message (utilisateur_id, contenu) VALUES (?,?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, u.getId());
                ps.setString(2, contenu);
                ps.executeUpdate();
            } catch(Exception e) {
                System.out.println("Erreur: " + e.getMessage());
            }
        }
        response.sendRedirect("messages");
    }
}