package com.lias.dao;

import com.lias.model.DemandeMateriel;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class DemandeMaterielDAO {

    // Soumettre une nouvelle demande de matériel (statut par défaut = en_attente, géré par la base)
    public void soumettreDemande(DemandeMateriel d) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO demande_materiel (utilisateur_id, nom_materiel, description, date_demande) VALUES (?,?,?,NOW())";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, d.getUtilisateurId());
            ps.setString(2, d.getNomMateriel());
            ps.setString(3, d.getDescription());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Récupérer toutes les demandes (pour la direction, vue d'ensemble)
    public List<DemandeMateriel> getAllDemandes() {
        List<DemandeMateriel> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT dm.*, u.nom AS nom_membre, u.prenom AS prenom_membre " +
                         "FROM demande_materiel dm " +
                         "JOIN utilisateur u ON dm.utilisateur_id = u.id " +
                         "ORDER BY dm.date_demande DESC";
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

    // Récupérer uniquement les demandes d'un membre précis (pour qu'il suive ses propres demandes)
    public List<DemandeMateriel> getDemandesParMembre(int utilisateurId) {
        List<DemandeMateriel> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT dm.*, u.nom AS nom_membre, u.prenom AS prenom_membre " +
                         "FROM demande_materiel dm " +
                         "JOIN utilisateur u ON dm.utilisateur_id = u.id " +
                         "WHERE dm.utilisateur_id=? ORDER BY dm.date_demande DESC";
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

    // Accepter une demande : statut = acceptee, date_decision = maintenant
    public void accepterDemande(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE demande_materiel SET statut='acceptee', date_decision=NOW() WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Refuser une demande : statut = refusee, date_decision = maintenant
    public void refuserDemande(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE demande_materiel SET statut='refusee', date_decision=NOW() WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Méthode utilitaire privée pour ne pas répéter le mapping ResultSet -> objet dans chaque méthode
    private DemandeMateriel mapper(ResultSet rs) throws SQLException {
        DemandeMateriel d = new DemandeMateriel();
        d.setId(rs.getInt("id"));
        d.setUtilisateurId(rs.getInt("utilisateur_id"));
        d.setNomMateriel(rs.getString("nom_materiel"));
        d.setDescription(rs.getString("description"));
        d.setStatut(rs.getString("statut"));
        d.setDateDemande(rs.getTimestamp("date_demande"));
        d.setDateDecision(rs.getTimestamp("date_decision"));
        d.setNomMembre(rs.getString("nom_membre"));
        d.setPrenomMembre(rs.getString("prenom_membre"));
        return d;
    }
}