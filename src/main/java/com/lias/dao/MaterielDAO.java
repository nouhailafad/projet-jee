package com.lias.dao;

import com.lias.model.Materiel;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MaterielDAO {

    public List<Materiel> getAllMateriel() {
        List<Materiel> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM materiel ORDER BY date_arrivage DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Materiel m = new Materiel();
                m.setId(rs.getInt("id"));
                m.setNom(rs.getString("nom"));
                m.setDescription(rs.getString("description"));
                m.setDateArrivage(rs.getString("date_arrivage"));
                m.setDateDistribution(rs.getString("date_distribution"));
                liste.add(m);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    public void ajouterMateriel(Materiel m) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO materiel (nom, description, date_arrivage) VALUES (?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, m.getNom());
            ps.setString(2, m.getDescription());
            ps.setString(3, m.getDateArrivage());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }
}