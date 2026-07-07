package com.lias.model;

public class Materiel {
    private int id;
    private String nom;
    private String description;
    private String dateArrivage;
    private int utilisateurId;
    private String dateDistribution;

    // Champs additionnels pratiques pour l'affichage (issus de jointure SQL)
    private String nomMembre;
    private String prenomMembre;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getDateArrivage() { return dateArrivage; }
    public void setDateArrivage(String dateArrivage) { this.dateArrivage = dateArrivage; }

    public int getUtilisateurId() { return utilisateurId; }
    public void setUtilisateurId(int utilisateurId) { this.utilisateurId = utilisateurId; }

    public String getDateDistribution() { return dateDistribution; }
    public void setDateDistribution(String dateDistribution) { this.dateDistribution = dateDistribution; }

    public String getNomMembre() { return nomMembre; }
    public void setNomMembre(String nomMembre) { this.nomMembre = nomMembre; }

    public String getPrenomMembre() { return prenomMembre; }
    public void setPrenomMembre(String prenomMembre) { this.prenomMembre = prenomMembre; }
}