package com.lias.dao;

import com.lias.model.Evenement;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EvenementDAO {

    public List<Evenement> getAllEvenements() {
        List<Evenement> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM evenement ORDER BY date_debut DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Evenement e = new Evenement();
                e.setId(rs.getInt("id"));
                e.setTitre(rs.getString("titre"));
                e.setType(rs.getString("type"));
                e.setDescription(rs.getString("description"));
                e.setDateDebut(rs.getString("date_debut"));
                e.setDateFin(rs.getString("date_fin"));
                e.setLieu(rs.getString("lieu"));
                liste.add(e);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    public void ajouterEvenement(Evenement e) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO evenement (titre, type, description, date_debut, date_fin, lieu) VALUES (?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, e.getTitre());
            ps.setString(2, e.getType());
            ps.setString(3, e.getDescription());
            ps.setString(4, e.getDateDebut());
            ps.setString(5, e.getDateFin());
            ps.setString(6, e.getLieu());
            ps.executeUpdate();
        } catch(Exception ex) {
            System.out.println("Erreur: " + ex.getMessage());
        }
    }
    //Ajouter méthodes recherche Recherche et consultation: Membre, Documents, Événements,Publications
    public List<Evenement> rechercher(String mot) {
        List<Evenement> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT e.* FROM evenement e " +
                         "LEFT JOIN utilisateur u ON e.organisateur_id = u.id " +
                         "WHERE e.titre LIKE ? OR e.description LIKE ? " +
                         "OR e.lieu LIKE ? OR u.nom LIKE ? OR u.prenom LIKE ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + mot + "%");
            ps.setString(2, "%" + mot + "%");
            ps.setString(3, "%" + mot + "%");
            ps.setString(4, "%" + mot + "%");
            ps.setString(5, "%" + mot + "%");
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Evenement e = new Evenement();
                e.setId(rs.getInt("id"));
                e.setTitre(rs.getString("titre"));
                e.setType(rs.getString("type"));
                e.setDateDebut(rs.getString("date_debut"));
                e.setLieu(rs.getString("lieu"));
                liste.add(e);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }
}