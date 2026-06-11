package com.lias.dao;

import com.lias.model.PvReunion;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PvReunionDAO {

    public List<PvReunion> getAllPv() {
        List<PvReunion> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM pv_reunion ORDER BY date_reunion DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                PvReunion pv = new PvReunion();
                pv.setId(rs.getInt("id"));
                pv.setTitre(rs.getString("titre"));
                pv.setOrdreduJour(rs.getString("ordre_du_jour"));
                pv.setDateReunion(rs.getString("date_reunion"));
                pv.setCheminPv(rs.getString("chemin_pv"));
                pv.setDateCreation(rs.getString("date_creation"));
                liste.add(pv);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    public void ajouterPv(PvReunion pv) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO pv_reunion (titre, ordre_du_jour, date_reunion, chemin_pv) VALUES (?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, pv.getTitre());
            ps.setString(2, pv.getOrdreduJour());
            ps.setString(3, pv.getDateReunion());
            ps.setString(4, pv.getCheminPv());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }
}