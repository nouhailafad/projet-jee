package com.lias.dao;

import com.lias.model.Mandat;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MandatDAO {

    public List<Mandat> getAllMandats() {
        List<Mandat> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT m.*, u.nom, u.prenom FROM mandat m JOIN utilisateur u ON m.utilisateur_id = u.id ORDER BY m.date_debut DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Mandat m = new Mandat();
                m.setId(rs.getInt("id"));
                m.setUtilisateurId(rs.getInt("utilisateur_id"));
                m.setRole(rs.getString("role"));
                m.setDateDebut(rs.getString("date_debut"));
                m.setDateFin(rs.getString("date_fin"));
                m.setNomMembre(rs.getString("nom"));
                m.setPrenomMembre(rs.getString("prenom"));
                liste.add(m);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    public void ajouterMandat(Mandat m) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO mandat (utilisateur_id, role, date_debut, date_fin) VALUES (?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, m.getUtilisateurId());
            ps.setString(2, m.getRole());
            ps.setString(3, m.getDateDebut());
            ps.setString(4, m.getDateFin());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }
}