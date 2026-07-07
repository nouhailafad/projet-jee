package com.lias.dao;

import com.lias.model.Equipe;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class EquipeDAO {

    // Récupérer toutes les équipes
    public List<Equipe> getAllEquipes() {
        List<Equipe> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM equipe ORDER BY nom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Equipe e = new Equipe();
                e.setId(rs.getInt("id"));
                e.setNom(rs.getString("nom"));
                e.setDescription(rs.getString("description"));
                e.setDateCreation(rs.getDate("date_creation"));
                liste.add(e);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    // Ajouter une équipe
    public void ajouterEquipe(Equipe e) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO equipe (nom, description, date_creation) VALUES (?,?,CURDATE())";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, e.getNom());
            ps.setString(2, e.getDescription());
            ps.executeUpdate();
        } catch(Exception ex) {
            System.out.println("Erreur: " + ex.getMessage());
        }
    }

    // Récupérer une équipe par ID
    public Equipe getById(int id) {
        Equipe e = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM equipe WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                e = new Equipe();
                e.setId(rs.getInt("id"));
                e.setNom(rs.getString("nom"));
                e.setDescription(rs.getString("description"));
                e.setDateCreation(rs.getDate("date_creation"));
            }
        } catch(Exception ex) {
            System.out.println("Erreur: " + ex.getMessage());
        }
        return e;
    }
}