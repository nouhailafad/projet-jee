package com.lias.dao;

import com.lias.model.Affiliation;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class AffiliationDAO {

    // Affecter un membre à une nouvelle équipe : crée une nouvelle période (date_debut = aujourd'hui, date_fin = NULL)
    public void affecterEquipe(int utilisateurId, int equipeId) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO affiliation (utilisateur_id, equipe_id, date_debut, date_fin) VALUES (?,?,CURDATE(),NULL)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ps.setInt(2, equipeId);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Mettre fin à l'affiliation active d'un membre (date_fin = aujourd'hui sur la ligne où date_fin est NULL)
    public void terminerAffiliationActive(int utilisateurId) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE affiliation SET date_fin=CURDATE() WHERE utilisateur_id=? AND date_fin IS NULL";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Récupérer l'affiliation actuelle (en cours) d'un membre, avec le nom de l'équipe
    public Affiliation getAffiliationActuelle(int utilisateurId) {
        Affiliation a = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT af.*, e.nom AS nom_equipe FROM affiliation af " +
                         "JOIN equipe e ON af.equipe_id = e.id " +
                         "WHERE af.utilisateur_id=? AND af.date_fin IS NULL";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                a = new Affiliation();
                a.setId(rs.getInt("id"));
                a.setUtilisateurId(rs.getInt("utilisateur_id"));
                a.setEquipeId(rs.getInt("equipe_id"));
                a.setDateDebut(rs.getDate("date_debut"));
                a.setDateFin(rs.getDate("date_fin"));
                a.setNomEquipe(rs.getString("nom_equipe"));
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return a;
    }

    // Récupérer tout l'historique des affiliations d'un membre (toutes périodes, anciennes et actuelle)
    public List<Affiliation> getHistoriqueParMembre(int utilisateurId) {
        List<Affiliation> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT af.*, e.nom AS nom_equipe FROM affiliation af " +
                         "JOIN equipe e ON af.equipe_id = e.id " +
                         "WHERE af.utilisateur_id=? ORDER BY af.date_debut DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Affiliation a = new Affiliation();
                a.setId(rs.getInt("id"));
                a.setUtilisateurId(rs.getInt("utilisateur_id"));
                a.setEquipeId(rs.getInt("equipe_id"));
                a.setDateDebut(rs.getDate("date_debut"));
                a.setDateFin(rs.getDate("date_fin"));
                a.setNomEquipe(rs.getString("nom_equipe"));
                liste.add(a);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    // Récupérer les membres actuellement affiliés à une équipe précise
    public List<Affiliation> getMembresParEquipe(int equipeId) {
        List<Affiliation> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT af.*, e.nom AS nom_equipe, u.nom AS nom_membre, u.prenom AS prenom_membre " +
                         "FROM affiliation af " +
                         "JOIN equipe e ON af.equipe_id = e.id " +
                         "JOIN utilisateur u ON af.utilisateur_id = u.id " +
                         "WHERE af.equipe_id=? AND af.date_fin IS NULL ORDER BY u.nom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, equipeId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Affiliation a = new Affiliation();
                a.setId(rs.getInt("id"));
                a.setUtilisateurId(rs.getInt("utilisateur_id"));
                a.setEquipeId(rs.getInt("equipe_id"));
                a.setDateDebut(rs.getDate("date_debut"));
                a.setDateFin(rs.getDate("date_fin"));
                a.setNomEquipe(rs.getString("nom_equipe"));
                a.setNomMembre(rs.getString("nom_membre"));
                a.setPrenomMembre(rs.getString("prenom_membre"));
                liste.add(a);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    // Récupérer toutes les affiliations actuelles de tous les membres (pour une vue d'ensemble par équipe)
    public List<Affiliation> getToutesAffiliationsActuelles() {
        List<Affiliation> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT af.*, e.nom AS nom_equipe, u.nom AS nom_membre, u.prenom AS prenom_membre " +
                         "FROM affiliation af " +
                         "JOIN equipe e ON af.equipe_id = e.id " +
                         "JOIN utilisateur u ON af.utilisateur_id = u.id " +
                         "WHERE af.date_fin IS NULL ORDER BY e.nom, u.nom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Affiliation a = new Affiliation();
                a.setId(rs.getInt("id"));
                a.setUtilisateurId(rs.getInt("utilisateur_id"));
                a.setEquipeId(rs.getInt("equipe_id"));
                a.setDateDebut(rs.getDate("date_debut"));
                a.setDateFin(rs.getDate("date_fin"));
                a.setNomEquipe(rs.getString("nom_equipe"));
                a.setNomMembre(rs.getString("nom_membre"));
                a.setPrenomMembre(rs.getString("prenom_membre"));
                liste.add(a);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }
}