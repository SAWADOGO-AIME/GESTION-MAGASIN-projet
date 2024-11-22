#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_PRODUITS 100
#define FICHIER "stock.txt"

// D�finition de la structure Produit
typedef struct {
    char nom[50];
    char categorie[50];
    float prix;
    int quantite;
} Produit;

// D�claration globale du stock et du nombre de produits
Produit stock[MAX_PRODUITS];
int nbProduits = 0;

// Prototypes des fonctions
void afficherMenu();
void ajouterProduit();
void afficherStock();
void sauvegarderStock();
void chargerStock();
void modifierProduit();
void supprimerProduit();
void rechercherProduit();
void mettreAJourQuantite();
int rechercherIndexProduit(const char *nom);

// Fonction principale
int main() {
    chargerStock();
    int choix;

    do {
        afficherMenu();
        printf("Entrez votre choix : ");
        scanf("%d", &choix);
        getchar(); //Pour �vite les r�sidus de saisie

        switch (choix) {
            case 1:
                ajouterProduit();
                break;
            case 2:
                afficherStock();
                break;
            case 3:
                sauvegarderStock();
                printf("Stock sauvegard� avec succ�s.\n");
                break;
            case 4:
                modifierProduit();
                break;
            case 5:
                supprimerProduit();
                break;
            case 6:
                rechercherProduit();
                break;
            case 7:
                mettreAJourQuantite();
                break;
            case 8:
                printf("Merci d'avoir utilis� le programme. Au revoir !\n");
                break;
            default:
                printf("Choix invalide, veuillez r�essayer.\n");
        }
    } while (choix != 8);

    return 0;
}

// Affiche un menu esth�tique
void afficherMenu() {
    printf("\n******************************************\n");
    printf("*         Gestion de Stock Magasin       *\n");
    printf("******************************************\n");
    printf("* 1. Ajouter un produit                  *\n");
    printf("* 2. Afficher le stock                   *\n");
    printf("* 3. Sauvegarder le stock                *\n");
    printf("* 4. Modifier un produit                 *\n");
    printf("* 5. Supprimer un produit                *\n");
    printf("* 6. Rechercher un produit               *\n");
    printf("* 7. Mettre � jour la quantit�           *\n");
    printf("* 8. Quitter                             *\n");
    printf("******************************************\n");
}

// Charge les donn�es depuis le fichier texte
void chargerStock() {
    FILE *f = fopen(FICHIER, "r");
    if (!f) {
        printf("Aucun fichier trouv�. Un nouveau fichier sera cr��.\n");
        return;
    }

    while (fscanf(f, "%49s %49s %f %d", stock[nbProduits].nom, stock[nbProduits].categorie, 
                  &stock[nbProduits].prix, &stock[nbProduits].quantite) == 4) {
        nbProduits++;//en fait le 49, on pouvais se passer et mettre %s seulement
    }
    fclose(f);
}

// Sauvegarde les donn�es dans le fichier texte
void sauvegarderStock() {
    FILE *f = fopen(FICHIER, "w");
    int i;

    if (!f) {
        printf("Erreur lors de l'ouverture du fichier pour la sauvegarde.\n");
        return;
    }

    for (i = 0; i < nbProduits; i++) {
        fprintf(f, "%s %s %.2f %d\n", stock[i].nom, stock[i].categorie, stock[i].prix, stock[i].quantite);
    }
    fclose(f);
}

// Ajoute un produit au stock
void ajouterProduit() {
    if (nbProduits >= MAX_PRODUITS) {
        printf("Stock plein. Impossible d'ajouter plus de produits.\n");//c'est quand meme logique qu'un magasin a une limite de stock
        return;
    }

    Produit p;
    printf("Entrez le nom : ");
    scanf("%49s", p.nom);
    printf("Entrez la cat�gorie : ");
    scanf("%49s", p.categorie);
    printf("Entrez le prix : ");
    scanf("%f", &p.prix);
    printf("Entrez la quantit� : ");
    scanf("%d", &p.quantite);

    stock[nbProduits++] = p;
    printf("Produit ajout� avec succ�s !\n");
}

// Affiche le stock
void afficherStock() {
    int i;

    if (nbProduits == 0) {
        printf("Le stock est vide.\n");
        return;
    }

    printf("\n--- �tat actuel du stock ---\n");
    for (i = 0; i < nbProduits; i++) {
        printf("%d. Nom: %s | Cat�gorie: %s | Prix: %.2f | Quantit�: %d\n", 
               i + 1, stock[i].nom, stock[i].categorie, stock[i].prix, stock[i].quantite);
    }
    printf("-----------------------------\n");
}

// Recherche un produit par nom?ICI NOUS AVONS PRIS LE NOM COMME CLE OU IDENTIFIANT
int rechercherIndexProduit(const char *nom) {
    int i;
    for (i = 0; i < nbProduits; i++) {
        if (strcmp(stock[i].nom, nom) == 0) {//strcmp compare deux chaines de caract�res
            return i;
        }
    }
    return -1; //PURQUOI -1? PARCE QUE SI ON NE TROUVE PAS LE PRODUIT, ON RETOURNE -1
}

void rechercherProduit() {
    char nom[50];
    int index;

    printf("Entrez le nom du produit � rechercher : ");
    scanf("%49s", nom);

    index = rechercherIndexProduit(nom);
    if (index == -1) {
        printf("Produit non trouv�.\n");
    } else {
        Produit p = stock[index];
        printf("Produit trouv� : Nom: %s | Cat�gorie: %s | Prix: %.2f | Quantit�: %d\n", 
               p.nom, p.categorie, p.prix, p.quantite);
    }
}

// Modifie un produit existant
void modifierProduit() {
    char nom[50];
    int index;

    printf("Entrez le nom du produit � modifier : ");
    scanf("%49s", nom);

    index = rechercherIndexProduit(nom);
    if (index == -1) {
        printf("Produit non trouv�.\n");
        return;
    }

    Produit *p = &stock[index];
    printf("Entrez le nouveau nom : ");
    scanf("%49s", p->nom);
    printf("Entrez la nouvelle cat�gorie : ");
    scanf("%49s", p->categorie);
    printf("Entrez le nouveau prix : ");
    scanf("%f", &p->prix);
    printf("Entrez la nouvelle quantit� : ");
    scanf("%d", &p->quantite);

    printf("Produit modifi� avec succ�s.\n");
}

// Supprime un produit
void supprimerProduit() {
    char nom[50];
    int index, i;

    printf("Entrez le nom du produit � supprimer : ");
    scanf("%49s", nom);

    index = rechercherIndexProduit(nom);
    if (index == -1) {
        printf("Produit non trouv�.\n");
        return;
    }

    for (i = index; i < nbProduits - 1; i++) {
        stock[i] = stock[i + 1];
    }
    nbProduits--;
    printf("Produit supprim� avec succ�s.\n");
}

// Met � jour la quantit� d'un produit
void mettreAJourQuantite() {
    char nom[50];
    int index;

    printf("Entrez le nom du produit : ");
    scanf("%49s", nom);// 49 caract�res maximum

    index = rechercherIndexProduit(nom);
    if (index == -1) {
        printf("Produit non trouv�.\n");
        return;
    }

    printf("Entrez la nouvelle quantit� : ");
    scanf("%d", &stock[index].quantite);

    printf("Quantit� mise � jour avec succ�s.\n");
}

