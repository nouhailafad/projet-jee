package com.lias.dao;

import com.lias.model.HistoriqueProfil;
import com.lias.util.DBConnection;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class HistoriqueProfilDAO {

    // Enregistrer un changement (un seul champ) dans l'historique
    public void enregistrerChangement(int utilisateurId, String champModifie, String ancienneValeur, String nouvelleValeur) {
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO historique_profil (utilisateur_id, champ_modifie, ancienne_valeur, nouvelle_valeur, date_modification) VALUES (?,?,?,?,NOW())";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ps.setString(2, champModifie);
            ps.setString(3, ancienneValeur);
            ps.setString(4, nouvelleValeur);
            ps.executeUpdate();
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
    }

    // Récupérer tout l'historique des modifications d'un membre, du plus récent au plus ancien
    public List<HistoriqueProfil> getHistoriqueParMembre(int utilisateurId) {
        List<HistoriqueProfil> liste = new ArrayList<>();
        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM historique_profil WHERE utilisateur_id=? ORDER BY date_modification DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, utilisateurId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                HistoriqueProfil h = new HistoriqueProfil();
                h.setId(rs.getInt("id"));
                h.setUtilisateurId(rs.getInt("utilisateur_id"));
                h.setChampModifie(rs.getString("champ_modifie"));
                h.setAncienneValeur(rs.getString("ancienne_valeur"));
                h.setNouvelleValeur(rs.getString("nouvelle_valeur"));
                h.setDateModification(rs.getTimestamp("date_modification"));
                liste.add(h);
            }
        } catch(Exception e) {
            System.out.println("Erreur: " + e.getMessage());
        }
        return liste;
    }
}