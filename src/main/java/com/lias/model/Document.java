package com.lias.model;

public class Document {
    private int id;
    private String nom;
    private String type;
    private String chemin;
    private int evenementId;
    private int utilisateurId;
    private String dateUpload;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getChemin() { return chemin; }
    public void setChemin(String chemin) { this.chemin = chemin; }

    public int getEvenementId() { return evenementId; }
    public void setEvenementId(int evenementId) { this.evenementId = evenementId; }

    public int getUtilisateurId() { return utilisateurId; }
    public void setUtilisateurId(int utilisateurId) { this.utilisateurId = utilisateurId; }

    public String getDateUpload() { return dateUpload; }
    public void setDateUpload(String dateUpload) { this.dateUpload = dateUpload; }
}