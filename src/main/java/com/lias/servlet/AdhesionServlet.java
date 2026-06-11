package com.lias.servlet;

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

@WebServlet("/adhesion")
public class AdhesionServlet extends HttpServlet {

    // GET → afficher liste des demandes (pour admin)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM demande_adhesion ORDER BY date_demande DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            List<Map<String, String>> demandes = new ArrayList<>();
            while(rs.next()) {
                Map<String, String> d = new HashMap<>();
                d.put("id", rs.getString("id"));
                d.put("nom", rs.getString("nom"));
                d.put("prenom", rs.getString("prenom"));
                d.put("email", rs.getString("email"));
                d.put("motivation", rs.getString("motivation"));
                d.put("statut", rs.getString("statut"));
                d.put("date", rs.getString("date_demande"));
                demandes.add(d);
            }
            request.setAttribute("demandes", demandes);
            request.getRequestDispatcher("/demandes.jsp").forward(request, response);
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // POST → soumettre demande (public) ou accepter/refuser (admin)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if("soumettre".equals(action)) {
            // Visiteur soumet une demande
            try {
                Connection conn = DBConnection.getConnection();
                String sql = "INSERT INTO demande_adhesion (nom, prenom, email, motivation, statut, type_statut) VALUES (?,?,?,?,'en_attente',?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, request.getParameter("nom"));
                ps.setString(2, request.getParameter("prenom"));
                ps.setString(3, request.getParameter("email"));
                ps.setString(4, request.getParameter("motivation"));
                ps.setString(5, request.getParameter("typeStatut"));
                ps.executeUpdate();
                response.sendRedirect("adhesion.jsp?statut=ok");
            } catch(Exception e) {
                System.out.println("Erreur: " + e.getMessage());
                response.sendRedirect("adhesion.jsp");
            }

        } else if("accepter".equals(action)) {
            // Admin accepte → crée compte utilisateur
            try {
                Connection conn = DBConnection.getConnection();
                int id = Integer.parseInt(request.getParameter("id"));

                // Récupérer les infos de la demande
                String sqlGet = "SELECT * FROM demande_adhesion WHERE id=?";
                PreparedStatement psGet = conn.prepareStatement(sqlGet);
                psGet.setInt(1, id);
                ResultSet rs = psGet.executeQuery();

                if(rs.next()) {
                    // Créer le compte utilisateur
                	String sqlUser = "INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, statut) VALUES (?,?,?,MD5('lias2026'),?)";
                	PreparedStatement psUser = conn.prepareStatement(sqlUser);
                	psUser.setString(1, rs.getString("nom"));
                	psUser.setString(2, rs.getString("prenom"));
                	psUser.setString(3, rs.getString("email"));
                	psUser.setString(4, rs.getString("type_statut"));
                	psUser.executeUpdate();
                    // Mettre à jour statut demande
                    String sqlUpdate = "UPDATE demande_adhesion SET statut='acceptee' WHERE id=?";
                    PreparedStatement psUpdate = conn.prepareStatement(sqlUpdate);
                    psUpdate.setInt(1, id);
                    psUpdate.executeUpdate();
                }
                response.sendRedirect("adhesion?msg=accepte");
            } catch(Exception e) {
                System.out.println("Erreur: " + e.getMessage());
                response.sendRedirect("adhesion");
            }

        } else if("refuser".equals(action)) {
            // Admin refuse la demande
            try {
                Connection conn = DBConnection.getConnection();
                int id = Integer.parseInt(request.getParameter("id"));
                String sql = "UPDATE demande_adhesion SET statut='refusee' WHERE id=?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setInt(1, id);
                ps.executeUpdate();
                response.sendRedirect("adhesion?msg=refuse");
            } catch(Exception e) {
                System.out.println("Erreur: " + e.getMessage());
                response.sendRedirect("adhesion");
            }
        }
    }
}