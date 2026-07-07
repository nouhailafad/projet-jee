package com.lias.dao;

import com.lias.model.Partenaire;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class PartenaireDAO {

    public List<Partenaire> getAllPartenaires() {
        List<Partenaire> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM partenaire ORDER BY nom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Partenaire p = new Partenaire();
                p.setId(rs.getInt("id"));
                p.setNom(rs.getString("nom"));
                p.setType(rs.getString("type"));
                p.setContact(rs.getString("contact"));
                liste.add(p);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    public void ajouterPartenaire(Partenaire p) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO partenaire (nom, type, contact) VALUES (?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, p.getNom());
            ps.setString(2, p.getType());
            ps.setString(3, p.getContact());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }
}