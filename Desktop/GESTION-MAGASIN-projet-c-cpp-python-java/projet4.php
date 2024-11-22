<?php

define("FICHIER", "stock.txt");

class Produit {
    public $nom;
    public $categorie;
    public $prix;
    public $quantite;

    public function __construct($nom, $categorie, $prix, $quantite) {
        $this->nom = $nom;
        $this->categorie = $categorie;
        $this->prix = $prix;
        $this->quantite = $quantite;
    }

    public function __toString() {
        return "Nom: $this->nom, Catégorie: $this->categorie, Prix: $this->prix, Quantité: $this->quantite";
    }
}

// Liste pour stocker les produits
$stock = [];

// Charger les produits depuis un fichier
function chargerStock() {
    global $stock;
    if (!file_exists(FICHIER)) {
        echo "Aucun fichier trouvé. Un nouveau fichier sera créé.\n";
        return;
    }

    $lines = file(FICHIER, FILE_IGNORE_NEW_LINES);
    foreach ($lines as $line) {
        list($nom, $categorie, $prix, $quantite) = explode(",", $line);
        $stock[] = new Produit($nom, $categorie, (float)$prix, (int)$quantite);
    }
}

// Sauvegarder les produits dans un fichier
function sauvegarderStock() {
    global $stock;
    $lines = [];
    foreach ($stock as $produit) {
        $lines[] = "$produit->nom,$produit->categorie,$produit->prix,$produit->quantite";
    }
    file_put_contents(FICHIER, implode(PHP_EOL, $lines));
    echo "Stock sauvegardé avec succès.\n";
}

// Ajouter un produit
function ajouterProduit() {
    global $stock;
    echo "Entrez le nom : ";
    $nom = trim(fgets(STDIN));
    echo "Entrez la catégorie : ";
    $categorie = trim(fgets(STDIN));
    echo "Entrez le prix : ";
    $prix = (float)trim(fgets(STDIN));
    echo "Entrez la quantité : ";
    $quantite = (int)trim(fgets(STDIN));

    $stock[] = new Produit($nom, $categorie, $prix, $quantite);
    echo "Produit ajouté avec succès !\n";
}

// Afficher le stock
function afficherStock() {
    global $stock;
    if (empty($stock)) {
        echo "Le stock est vide.\n";
        return;
    }

    echo "\n--- État actuel du stock ---\n";
    foreach ($stock as $index => $produit) {
        echo ($index + 1) . ". $produit\n";
    }
}

// Rechercher un produit par nom
function rechercherProduit() {
    global $stock;
    echo "Entrez le nom du produit à rechercher : ";
    $nom = trim(fgets(STDIN));

    foreach ($stock as $produit) {
        if (strcasecmp($produit->nom, $nom) === 0) {
            echo "Produit trouvé : $produit\n";
            return;
        }
    }
    echo "Produit non trouvé.\n";
}

// Modifier un produit
function modifierProduit() {
    global $stock;
    echo "Entrez le nom du produit à modifier : ";
    $nom = trim(fgets(STDIN));

    foreach ($stock as $produit) {
        if (strcasecmp($produit->nom, $nom) === 0) {
            echo "Entrez le nouveau nom : ";
            $produit->nom = trim(fgets(STDIN));
            echo "Entrez la nouvelle catégorie : ";
            $produit->categorie = trim(fgets(STDIN));
            echo "Entrez le nouveau prix : ";
            $produit->prix = (float)trim(fgets(STDIN));
            echo "Entrez la nouvelle quantité : ";
            $produit->quantite = (int)trim(fgets(STDIN));
            echo "Produit modifié avec succès.\n";
            return;
        }
    }
    echo "Produit non trouvé.\n";
}

// Supprimer un produit
function supprimerProduit() {
    global $stock;
    echo "Entrez le nom du produit à supprimer : ";
    $nom = trim(fgets(STDIN));

    foreach ($stock as $index => $produit) {
        if (strcasecmp($produit->nom, $nom) === 0) {
            array_splice($stock, $index, 1);
            echo "Produit supprimé avec succès.\n";
            return;
        }
    }
    echo "Produit non trouvé.\n";
}

// Mettre à jour la quantité d'un produit
function mettreAJourQuantite() {
    global $stock;
    echo "Entrez le nom du produit : ";
    $nom = trim(fgets(STDIN));

    foreach ($stock as $produit) {
        if (strcasecmp($produit->nom, $nom) === 0) {
            echo "Entrez la nouvelle quantité : ";
            $produit->quantite = (int)trim(fgets(STDIN));
            echo "Quantité mise à jour avec succès.\n";
            return;
        }
    }
    echo "Produit non trouvé.\n";
}

// Afficher le menu principal
function afficherMenu() {
    echo "\n******************************************\n";
    echo "*         Gestion de Stock Magasin       *\n";
    echo "******************************************\n";
    echo "* 1. Ajouter un produit                  *\n";
    echo "* 2. Afficher le stock                   *\n";
    echo "* 3. Sauvegarder le stock                *\n";
    echo "* 4. Modifier un produit                 *\n";
    echo "* 5. Supprimer un produit                *\n";
    echo "* 6. Rechercher un produit               *\n";
    echo "* 7. Mettre à jour la quantité           *\n";
    echo "* 8. Quitter                             *\n";
    echo "******************************************\n";
}

// Programme principal
function main() {
    chargerStock();
    do {
        afficherMenu();
        echo "Entrez votre choix : ";
        $choix = trim(fgets(STDIN));

        switch ($choix) {
            case "1":
                ajouterProduit();
                break;
            case "2":
                afficherStock();
                break;
            case "3":
                sauvegarderStock();
                break;
            case "4":
                modifierProduit();
                break;
            case "5":
                supprimerProduit();
                break;
            case "6":
                rechercherProduit();
                break;
            case "7":
                mettreAJourQuantite();
                break;
            case "8":
                echo "Merci d'avoir utilisé le programme. Au revoir !\n";
                sauvegarderStock();
                exit;
            default:
                echo "Choix invalide, veuillez réessayer.\n";
        }
    } while (true);
}

// Exécution du programme
main();
