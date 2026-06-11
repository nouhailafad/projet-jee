package com.lias.servlet;

import com.lias.dao.DocumentDAO;
import com.lias.dao.NotificationDAO;
import com.lias.dao.UtilisateurDAO;
import com.lias.model.Document;
import com.lias.model.Utilisateur;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/documents")
public class DocumentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if(request.getSession().getAttribute("utilisateur") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        List<Document> documents = new DocumentDAO().getAllDocuments();
        request.setAttribute("documents", documents);
        request.getRequestDispatcher("/documents.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if("ajouter".equals(action)) {
            Document d = new Document();
            d.setNom(request.getParameter("nom"));
            d.setType(request.getParameter("type"));
            d.setChemin(request.getParameter("chemin"));
            new DocumentDAO().ajouterDocument(d);

            // Notifier tous les membres ← ICI dans doPost
            List<Utilisateur> membres = new UtilisateurDAO().getAllMembres();
            NotificationDAO notifDAO = new NotificationDAO();
            for(Utilisateur membre : membres) {
                notifDAO.ajouterNotification(
                    membre.getId(),
                    "📁 Nouveau document ajouté: " + d.getNom()
                );
            }
        }

        response.sendRedirect("documents");
    }
}