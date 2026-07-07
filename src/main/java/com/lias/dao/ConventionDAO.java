package com.lias.dao;

import com.lias.model.Convention;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class ConventionDAO {

    public List<Convention> getAllConventions() {
        List<Convention> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT c.*, p.nom AS nom_partenaire FROM convention c " +
                         "JOIN partenaire p ON c.partenaire_id = p.id " +
                         "ORDER BY c.date_debut DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                liste.add(mapper(rs));
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    public void ajouterConvention(Convention c) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO convention (partenaire_id, objet, date_debut, date_fin, activites_associees) VALUES (?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, c.getPartenaireId());
            ps.setString(2, c.getObjet());
            ps.setDate(3, c.getDateDebut());
            ps.setDate(4, c.getDateFin());
            ps.setString(5, c.getActivitesAssociees());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Met à jour uniquement le chemin du document archivé (après upload)
    public void mettreAJourDocument(int conventionId, String cheminDocument) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE convention SET chemin_document=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, cheminDocument);
            ps.setInt(2, conventionId);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Récupère toutes les conventions d'un partenaire précis (suivi des collaborations avec cette entité)
    public List<Convention> getConventionsParPartenaire(int partenaireId) {
        List<Convention> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT c.*, p.nom AS nom_partenaire FROM convention c " +
                         "JOIN partenaire p ON c.partenaire_id = p.id " +
                         "WHERE c.partenaire_id=? ORDER BY c.date_debut DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, partenaireId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                liste.add(mapper(rs));
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    private Convention mapper(ResultSet rs) throws SQLException {
        Convention c = new Convention();
        c.setId(rs.getInt("id"));
        c.setPartenaireId(rs.getInt("partenaire_id"));
        c.setObjet(rs.getString("objet"));
        c.setDateDebut(rs.getDate("date_debut"));
        c.setDateFin(rs.getDate("date_fin"));
        c.setCheminDocument(rs.getString("chemin_document"));
        c.setActivitesAssociees(rs.getString("activites_associees"));
        c.setNomPartenaire(rs.getString("nom_partenaire"));
        return c;
    }
}