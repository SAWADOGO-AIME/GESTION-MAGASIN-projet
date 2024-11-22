import java.io.*;
import java.util.ArrayList;
import java.util.Scanner;

class Produit {
    String nom;
    String categorie;
    double prix;
    int quantite;

    public Produit(String nom, String categorie, double prix, int quantite) {
        this.nom = nom;
        this.categorie = categorie;
        this.prix = prix;
        this.quantite = quantite;
    }

    @Override
    public String toString() {
        return "Nom: " + nom + ", Catégorie: " + categorie + ", Prix: " + prix + ", Quantité: " + quantite;
    }
}

public class GestionStock {
    private static final String FICHIER = "stock.txt";
    private static ArrayList<Produit> stock = new ArrayList<>();
    private static Scanner scanner = new Scanner(System.in);

    public static void main(String[] args) {
        chargerStock();
        int choix;

        do {
            afficherMenu();
            System.out.print("Entrez votre choix : ");
            choix = scanner.nextInt();
            scanner.nextLine(); // Consomme la nouvelle ligne

            switch (choix) {
                case 1 -> ajouterProduit();
                case 2 -> afficherStock();
                case 3 -> sauvegarderStock();
                case 4 -> modifierProduit();
                case 5 -> supprimerProduit();
                case 6 -> rechercherProduit();
                case 7 -> mettreAJourQuantite();
                case 8 -> System.out.println("Merci d'avoir utilisé le programme. Au revoir !");
                default -> System.out.println("Choix invalide, veuillez réessayer.");
            }
        } while (choix != 8);
    }

    private static void afficherMenu() {
        System.out.println("\n******************************************");
        System.out.println("*         Gestion de Stock Magasin       *");
        System.out.println("******************************************");
        System.out.println("* 1. Ajouter un produit                  *");
        System.out.println("* 2. Afficher le stock                   *");
        System.out.println("* 3. Sauvegarder le stock                *");
        System.out.println("* 4. Modifier un produit                 *");
        System.out.println("* 5. Supprimer un produit                *");
        System.out.println("* 6. Rechercher un produit               *");
        System.out.println("* 7. Mettre à jour la quantité           *");
        System.out.println("* 8. Quitter                             *");
        System.out.println("******************************************");
    }

    private static void ajouterProduit() {
        System.out.print("Entrez le nom du produit : ");
        String nom = scanner.nextLine();
        System.out.print("Entrez la catégorie : ");
        String categorie = scanner.nextLine();
        System.out.print("Entrez le prix : ");
        double prix = scanner.nextDouble();
        System.out.print("Entrez la quantité : ");
        int quantite = scanner.nextInt();

        stock.add(new Produit(nom, categorie, prix, quantite));
        System.out.println("Produit ajouté avec succès !");
    }

    private static void afficherStock() {
        if (stock.isEmpty()) {
            System.out.println("Le stock est vide.");
            return;
        }

        System.out.println("\n--- État actuel du stock ---");
        for (int i = 0; i < stock.size(); i++) {
            System.out.println((i + 1) + ". " + stock.get(i));
        }
    }

    private static void sauvegarderStock() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FICHIER))) {
            for (Produit produit : stock) {
                writer.write(produit.nom + "," + produit.categorie + "," + produit.prix + "," + produit.quantite);
                writer.newLine();
            }
            System.out.println("Stock sauvegardé avec succès.");
        } catch (IOException e) {
            System.out.println("Erreur lors de la sauvegarde du stock : " + e.getMessage());
        }
    }

    private static void chargerStock() {
        File fichier = new File(FICHIER);
        if (!fichier.exists()) {
            System.out.println("Aucun fichier trouvé. Un nouveau fichier sera créé.");
            return;
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(fichier))) {
            String ligne;
            while ((ligne = reader.readLine()) != null) {
                String[] parts = ligne.split(",");
                if (parts.length == 4) {
                    String nom = parts[0];
                    String categorie = parts[1];
                    double prix = Double.parseDouble(parts[2]);
                    int quantite = Integer.parseInt(parts[3]);
                    stock.add(new Produit(nom, categorie, prix, quantite));
                }
            }
        } catch (IOException e) {
            System.out.println("Erreur lors du chargement du stock : " + e.getMessage());
        }
    }

    private static void modifierProduit() {
        System.out.print("Entrez le nom du produit à modifier : ");
        String nom = scanner.nextLine();
        Produit produit = rechercherProduitParNom(nom);

        if (produit == null) {
            System.out.println("Produit non trouvé.");
            return;
        }

        System.out.print("Entrez le nouveau nom : ");
        produit.nom = scanner.nextLine();
        System.out.print("Entrez la nouvelle catégorie : ");
        produit.categorie = scanner.nextLine();
        System.out.print("Entrez le nouveau prix : ");
        produit.prix = scanner.nextDouble();
        System.out.print("Entrez la nouvelle quantité : ");
        produit.quantite = scanner.nextInt();

        System.out.println("Produit modifié avec succès.");
    }

    private static void supprimerProduit() {
        System.out.print("Entrez le nom du produit à supprimer : ");
        String nom = scanner.nextLine();
        Produit produit = rechercherProduitParNom(nom);

        if (produit == null) {
            System.out.println("Produit non trouvé.");
            return;
        }

        stock.remove(produit);
        System.out.println("Produit supprimé avec succès.");
    }

    private static void rechercherProduit() {
        System.out.print("Entrez le nom du produit à rechercher : ");
        String nom = scanner.nextLine();
        Produit produit = rechercherProduitParNom(nom);

        if (produit == null) {
            System.out.println("Produit non trouvé.");
        } else {
            System.out.println("Produit trouvé : " + produit);
        }
    }

    private static void mettreAJourQuantite() {
        System.out.print("Entrez le nom du produit : ");
        String nom = scanner.nextLine();
        Produit produit = rechercherProduitParNom(nom);

        if (produit == null) {
            System.out.println("Produit non trouvé.");
            return;
        }

        System.out.print("Entrez la nouvelle quantité : ");
        produit.quantite = scanner.nextInt();
        System.out.println("Quantité mise à jour avec succès.");
    }

    private static Produit rechercherProduitParNom(String nom) {
        for (Produit produit : stock) {
            if (produit.nom.equalsIgnoreCase(nom)) {
                return produit;
            }
        }
        return null;
    }
}
