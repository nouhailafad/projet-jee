package com.lias.dao;

import com.lias.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NotificationDAO {

    // Récupérer notifications d'un utilisateur
    public List<Map<String, String>> getNotifications(int utilisateurId) {
        List<Map<String, String>> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM notification WHERE utilisateur_id=? ORDER BY date_creation DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Map<String, String> n = new HashMap<>();
                n.put("id", rs.getString("id"));
                n.put("message", rs.getString("message"));
                n.put("lu", rs.getString("lu"));
                n.put("date", rs.getString("date_creation"));
                liste.add(n);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    // Compter notifications non lues
    public int compterNonLues(int utilisateurId) {
        int count = 0;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) FROM notification WHERE utilisateur_id=? AND lu=0";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) count = rs.getInt(1);
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return count;
    }

    // Marquer comme lue
    public void marquerLue(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE notification SET lu=1 WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Marquer toutes comme lues
    public void marquerToutesLues(int utilisateurId) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE notification SET lu=1 WHERE utilisateur_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Ajouter une notification
    public void ajouterNotification(int utilisateurId, String message) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO notification (utilisateur_id, message) VALUES (?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ps.setString(2, message);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }
}