package com.lias.model;

public class Publication {
    private int id;
    private String titre;
    private String auteurs;
    private int annee;
    private String type;
    private String lien;
    private int equipeId;
    private int utilisateurId;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getAuteurs() { return auteurs; }
    public void setAuteurs(String auteurs) { this.auteurs = auteurs; }

    public int getAnnee() { return annee; }
    public void setAnnee(int annee) { this.annee = annee; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getLien() { return lien; }
    public void setLien(String lien) { this.lien = lien; }

    public int getEquipeId() { return equipeId; }
    public void setEquipeId(int equipeId) { this.equipeId = equipeId; }

    public int getUtilisateurId() { return utilisateurId; }
    public void setUtilisateurId(int utilisateurId) { this.utilisateurId = utilisateurId; }
}