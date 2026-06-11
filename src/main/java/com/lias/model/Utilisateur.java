package com.lias.model;

public class Utilisateur {
    private int id;
    private String nom;
    private String prenom;
    private String email;
    private String motDePasse;
    private String statut;
    private String etablissement;
    private String laboratoireOrigine;
    private String biographie;
    private String photo;
    private boolean actif;
    private String centresInteret;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public String getEtablissement() { return etablissement; }
    public void setEtablissement(String etablissement) { this.etablissement = etablissement; }

    public String getLaboratoireOrigine() { return laboratoireOrigine; }
    public void setLaboratoireOrigine(String laboratoireOrigine) { this.laboratoireOrigine = laboratoireOrigine; }

    public String getBiographie() { return biographie; }
    public void setBiographie(String biographie) { this.biographie = biographie; }

    public String getPhoto() { return photo; }
    public void setPhoto(String photo) { this.photo = photo; }

    public boolean isActif() { return actif; }
    public void setActif(boolean actif) { this.actif = actif; }

    public String getCentresInteret() { return centresInteret; }
    public void setCentresInteret(String centresInteret) { this.centresInteret = centresInteret; }
}