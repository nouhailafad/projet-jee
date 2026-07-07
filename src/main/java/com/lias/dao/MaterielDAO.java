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
            String sql = "SELECT m.*, u.nom AS nom_membre, u.prenom AS prenom_membre " +
                         "FROM materiel m " +
                         "LEFT JOIN utilisateur u ON m.utilisateur_id = u.id " +
                         "ORDER BY m.date_arrivage DESC";
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

    // Distribuer un matériel (encore non distribué) à un membre précis : on enregistre qui le reçoit et quand
    public void distribuer(int materielId, int utilisateurId) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE materiel SET utilisateur_id=?, date_distribution=CURDATE() WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ps.setInt(2, materielId);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Liste de tout le matériel encore en stock (jamais distribué), pour savoir ce qui reste disponible
    public List<Materiel> getMaterielDisponible() {
        List<Materiel> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT m.*, u.nom AS nom_membre, u.prenom AS prenom_membre " +
                         "FROM materiel m " +
                         "LEFT JOIN utilisateur u ON m.utilisateur_id = u.id " +
                         "WHERE m.utilisateur_id IS NULL ORDER BY m.date_arrivage";
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

    // Historique de tout le matériel reçu par un membre précis (pour vérifier l'équité de distribution)
    public List<Materiel> getMaterielParMembre(int utilisateurId) {
        List<Materiel> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT m.*, u.nom AS nom_membre, u.prenom AS prenom_membre " +
                         "FROM materiel m " +
                         "LEFT JOIN utilisateur u ON m.utilisateur_id = u.id " +
                         "WHERE m.utilisateur_id=? ORDER BY m.date_distribution DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                liste.add(mapper(rs));
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    // Méthode utilitaire privée pour éviter de répéter le mapping dans chaque méthode
    private Materiel mapper(ResultSet rs) throws SQLException {
        Materiel m = new Materiel();
        m.setId(rs.getInt("id"));
        m.setNom(rs.getString("nom"));
        m.setDescription(rs.getString("description"));
        m.setDateArrivage(rs.getString("date_arrivage"));
        m.setUtilisateurId(rs.getInt("utilisateur_id"));
        m.setDateDistribution(rs.getString("date_distribution"));
        return m;
    }
}