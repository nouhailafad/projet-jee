package com.lias.model;

import java.sql.Date;

public class Convention {
    private int id;
    private int partenaireId;
    private String objet;
    private Date dateDebut;
    private Date dateFin;
    private String cheminDocument;
    private String activitesAssociees;

    // Champ additionnel pratique pour l'affichage (issu de jointure SQL)
    private String nomPartenaire;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPartenaireId() { return partenaireId; }
    public void setPartenaireId(int partenaireId) { this.partenaireId = partenaireId; }

    public String getObjet() { return objet; }
    public void setObjet(String objet) { this.objet = objet; }

    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }

    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }

    public String getCheminDocument() { return cheminDocument; }
    public void setCheminDocument(String cheminDocument) { this.cheminDocument = cheminDocument; }

    public String getActivitesAssociees() { return activitesAssociees; }
    public void setActivitesAssociees(String activitesAssociees) { this.activitesAssociees = activitesAssociees; }

    public String getNomPartenaire() { return nomPartenaire; }
    public void setNomPartenaire(String nomPartenaire) { this.nomPartenaire = nomPartenaire; }
}