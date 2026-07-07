package com.lias.model;

import java.sql.Date;

public class Affiliation {
    private int id;
    private int utilisateurId;
    private int equipeId;
    private Date dateDebut;
    private Date dateFin;

    // Champs additionnels pratiques pour l'affichage (issus de jointures SQL)
    private String nomEquipe;
    private String nomMembre;
    private String prenomMembre;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUtilisateurId() { return utilisateurId; }
    public void setUtilisateurId(int utilisateurId) { this.utilisateurId = utilisateurId; }

    public int getEquipeId() { return equipeId; }
    public void setEquipeId(int equipeId) { this.equipeId = equipeId; }

    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }

    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }

    public String getNomEquipe() { return nomEquipe; }
    public void setNomEquipe(String nomEquipe) { this.nomEquipe = nomEquipe; }

    public String getNomMembre() { return nomMembre; }
    public void setNomMembre(String nomMembre) { this.nomMembre = nomMembre; }

    public String getPrenomMembre() { return prenomMembre; }
    public void setPrenomMembre(String prenomMembre) { this.prenomMembre = prenomMembre; }
}