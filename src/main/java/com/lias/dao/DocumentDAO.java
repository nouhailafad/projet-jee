package com.lias.dao;

import com.lias.model.Document;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DocumentDAO {

    public List<Document> getAllDocuments() {
        List<Document> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM document ORDER BY date_upload DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Document d = new Document();
                d.setId(rs.getInt("id"));
                d.setNom(rs.getString("nom"));
                d.setType(rs.getString("type"));
                d.setChemin(rs.getString("chemin"));
                d.setDateUpload(rs.getString("date_upload"));
                liste.add(d);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    public void ajouterDocument(Document d) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO document (nom, type, chemin) VALUES (?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, d.getNom());
            ps.setString(2, d.getType());
            ps.setString(3, d.getChemin());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }
}