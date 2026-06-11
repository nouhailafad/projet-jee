package com.lias.model;

public class PvReunion {
    private int id;
    private String titre;
    private String ordreduJour;
    private String dateReunion;
    private String cheminPv;
    private String dateCreation;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getOrdreduJour() { return ordreduJour; }
    public void setOrdreduJour(String ordreduJour) { this.ordreduJour = ordreduJour; }

    public String getDateReunion() { return dateReunion; }
    public void setDateReunion(String dateReunion) { this.dateReunion = dateReunion; }

    public String getCheminPv() { return cheminPv; }
    public void setCheminPv(String cheminPv) { this.cheminPv = cheminPv; }

    public String getDateCreation() { return dateCreation; }
    public void setDateCreation(String dateCreation) { this.dateCreation = dateCreation; }
}