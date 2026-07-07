package com.lias.model;

import java.sql.Timestamp;

public class DemandeMateriel {
    private int id;
    private int utilisateurId;
    private String nomMateriel;
    private String description;
    private String statut;
    private Timestamp dateDemande;
    private Timestamp dateDecision;

    // Champs additionnels pratiques pour l'affichage (issus de jointures SQL)
    private String nomMembre;
    private String prenomMembre;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUtilisateurId() { return utilisateurId; }
    public void setUtilisateurId(int utilisateurId) { this.utilisateurId = utilisateurId; }

    public String getNomMateriel() { return nomMateriel; }
    public void setNomMateriel(String nomMateriel) { this.nomMateriel = nomMateriel; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Timestamp getDateDemande() { return dateDemande; }
    public void setDateDemande(Timestamp dateDemande) { this.dateDemande = dateDemande; }

    public Timestamp getDateDecision() { return dateDecision; }
    public void setDateDecision(Timestamp dateDecision) { this.dateDecision = dateDecision; }

    public String getNomMembre() { return nomMembre; }
    public void setNomMembre(String nomMembre) { this.nomMembre = nomMembre; }

    public String getPrenomMembre() { return prenomMembre; }
    public void setPrenomMembre(String prenomMembre) { this.prenomMembre = prenomMembre; }
}