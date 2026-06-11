package com.lias.dao;

import com.lias.model.Utilisateur;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class UtilisateurDAO {

    // Vérifier login
    public Utilisateur login(String email, String motDePasse) {
        Utilisateur u = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM utilisateur WHERE email=? AND mot_de_passe=MD5(?) AND actif=1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, motDePasse);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                u = new Utilisateur();
                u.setId(rs.getInt("id"));
                u.setNom(rs.getString("nom"));
                u.setPrenom(rs.getString("prenom"));
                u.setEmail(rs.getString("email"));
                u.setStatut(rs.getString("statut"));
            }
        } catch (Exception e) {
            System.out.println("Erreur login: " + e.getMessage());
        }
        return u;
    }

    // Récupérer tous les membres
    public List<Utilisateur> getAllMembres() {
        List<Utilisateur> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM utilisateur ORDER BY nom";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Utilisateur u = new Utilisateur();
                u.setId(rs.getInt("id"));
                u.setNom(rs.getString("nom"));
                u.setPrenom(rs.getString("prenom"));
                u.setEmail(rs.getString("email"));
                u.setStatut(rs.getString("statut"));
                u.setActif(rs.getBoolean("actif"));
                liste.add(u);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }

    // Ajouter un membre
    public void ajouterMembre(Utilisateur u) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, statut, etablissement) VALUES (?,?,?,MD5(?),?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getMotDePasse());
            ps.setString(5, u.getStatut());
            ps.setString(6, u.getEtablissement());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Modifier profil
    public void modifierProfil(Utilisateur u) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE utilisateur SET nom=?, prenom=?, email=?, etablissement=?, laboratoire_origine=?, biographie=?, centres_interet=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getEtablissement());
            ps.setString(5, u.getLaboratoireOrigine());
            ps.setString(6, u.getBiographie());
            ps.setString(7, u.getCentresInteret());
            ps.setInt(8, u.getId());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Récupérer membre par ID
    public Utilisateur getById(int id) {
        Utilisateur u = null;
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM utilisateur WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                u = new Utilisateur();
                u.setId(rs.getInt("id"));
                u.setNom(rs.getString("nom"));
                u.setPrenom(rs.getString("prenom"));
                u.setEmail(rs.getString("email"));
                u.setStatut(rs.getString("statut"));
                u.setEtablissement(rs.getString("etablissement"));
                u.setLaboratoireOrigine(rs.getString("laboratoire_origine"));
                u.setBiographie(rs.getString("biographie"));
                u.setCentresInteret(rs.getString("centres_interet"));
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return u;
    }
    //Ajouter méthodes recherche Recherche et consultation: Membre, Documents, Événements,Publications
    public List<Utilisateur> rechercher(String mot) {
        List<Utilisateur> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM utilisateur WHERE nom LIKE ? OR prenom LIKE ? OR email LIKE ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + mot + "%");
            ps.setString(2, "%" + mot + "%");
            ps.setString(3, "%" + mot + "%");
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Utilisateur u = new Utilisateur();
                u.setId(rs.getInt("id"));
                u.setNom(rs.getString("nom"));
                u.setPrenom(rs.getString("prenom"));
                u.setEmail(rs.getString("email"));
                u.setStatut(rs.getString("statut"));
                liste.add(u);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }
    public void desactiverMembre(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE utilisateur SET actif=0 WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    public void reactiverMembre(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE utilisateur SET actif=1 WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }
}