package com.lias.dao;

import com.lias.model.Publication;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PublicationDAO {

    public List<Publication> getAllPublications() {
        List<Publication> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM publication ORDER BY annee DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Publication p = new Publication();
                p.setId(rs.getInt("id"));
                p.setTitre(rs.getString("titre"));
                p.setAuteurs(rs.getString("auteurs"));
                p.setAnnee(rs.getInt("annee"));
                p.setType(rs.getString("type"));
                p.setLien(rs.getString("lien"));
                liste.add(p);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    public void ajouterPublication(Publication p) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO publication (titre, auteurs, annee, type, lien) VALUES (?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, p.getTitre());
            ps.setString(2, p.getAuteurs());
            ps.setInt(3, p.getAnnee());
            ps.setString(4, p.getType());
            ps.setString(5, p.getLien());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }
    //Ajouter méthodes recherche Recherche et consultation: Membre, Documents, Événements,Publications
    public List<Publication> rechercher(String mot) {
        List<Publication> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM publication WHERE titre LIKE ? OR auteurs LIKE ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + mot + "%");
            ps.setString(2, "%" + mot + "%");
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Publication p = new Publication();
                p.setId(rs.getInt("id"));
                p.setTitre(rs.getString("titre"));
                p.setAuteurs(rs.getString("auteurs"));
                p.setAnnee(rs.getInt("annee"));
                p.setType(rs.getString("type"));
                liste.add(p);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }
}