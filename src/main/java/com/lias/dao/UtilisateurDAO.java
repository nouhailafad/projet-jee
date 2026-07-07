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
                u.setDateNaissance(rs.getDate("date_naissance"));
                u.setDateEmbauche(rs.getDate("date_embauche"));
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
                u.setDateNaissance(rs.getDate("date_naissance"));
                u.setDateEmbauche(rs.getDate("date_embauche"));
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
            String sql = "INSERT INTO utilisateur (nom, prenom, email, mot_de_passe, statut, etablissement, date_naissance, date_embauche) VALUES (?,?,?,MD5(?),?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getMotDePasse());
            ps.setString(5, u.getStatut());
            ps.setString(6, u.getEtablissement());
            ps.setDate(7, u.getDateNaissance());
            ps.setDate(8, u.getDateEmbauche());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Modifier profil (avec historisation : on compare l'ancienne et la nouvelle valeur de chaque champ)
    public void modifierProfil(Utilisateur u) {
        // 1. On récupère l'ancien profil avant d'écraser quoi que ce soit, pour pouvoir comparer
        Utilisateur ancien = getById(u.getId());
        HistoriqueProfilDAO historiqueDao = new HistoriqueProfilDAO();

        if(ancien != null) {
            comparerEtEnregistrer(historiqueDao, u.getId(), "nom", ancien.getNom(), u.getNom());
            comparerEtEnregistrer(historiqueDao, u.getId(), "prenom", ancien.getPrenom(), u.getPrenom());
            comparerEtEnregistrer(historiqueDao, u.getId(), "email", ancien.getEmail(), u.getEmail());
            comparerEtEnregistrer(historiqueDao, u.getId(), "etablissement", ancien.getEtablissement(), u.getEtablissement());
            comparerEtEnregistrer(historiqueDao, u.getId(), "laboratoire_origine", ancien.getLaboratoireOrigine(), u.getLaboratoireOrigine());
            comparerEtEnregistrer(historiqueDao, u.getId(), "biographie", ancien.getBiographie(), u.getBiographie());
            comparerEtEnregistrer(historiqueDao, u.getId(), "centres_interet", ancien.getCentresInteret(), u.getCentresInteret());
        }

        // 2. Une fois l'historique enregistré, on applique la modification comme avant
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE utilisateur SET nom=?, prenom=?, email=?, etablissement=?, laboratoire_origine=?, biographie=?, centres_interet=?, date_naissance=?, date_embauche=? WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, u.getNom());
            ps.setString(2, u.getPrenom());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getEtablissement());
            ps.setString(5, u.getLaboratoireOrigine());
            ps.setString(6, u.getBiographie());
            ps.setString(7, u.getCentresInteret());
            ps.setDate(8, u.getDateNaissance());
            ps.setDate(9, u.getDateEmbauche());
            ps.setInt(10, u.getId());
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Méthode utilitaire : compare deux valeurs et enregistre dans l'historique seulement si elles diffèrent
    private void comparerEtEnregistrer(HistoriqueProfilDAO dao, int utilisateurId, String champ, String ancienneValeur, String nouvelleValeur) {
        String av = (ancienneValeur == null) ? "" : ancienneValeur;
        String nv = (nouvelleValeur == null) ? "" : nouvelleValeur;
        if(!av.equals(nv)) {
            dao.enregistrerChangement(utilisateurId, champ, av, nv);
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
                u.setActif(rs.getBoolean("actif"));
                u.setDateNaissance(rs.getDate("date_naissance"));
                u.setDateEmbauche(rs.getDate("date_embauche"));
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

    // Mettre un membre en retraite : compte gelé, statut="retraite", actif=0
    public void mettreEnRetraite(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE utilisateur SET statut='retraite', actif=0 WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Marquer un membre comme ancien membre : compte désactivé mais historique conservé, réactivable
    public void marquerAncienMembre(int id) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE utilisateur SET statut='ancien', actif=0 WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Réactiver un ancien membre en lui redonnant un statut actif choisi (permanent/associe/doctorant)
    public void reactiverAvecStatut(int id, String nouveauStatut) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE utilisateur SET statut=?, actif=1 WHERE id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, nouveauStatut);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }
}