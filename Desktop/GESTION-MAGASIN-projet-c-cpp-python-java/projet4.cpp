#include <iostream> // C++ pour gerer les entrees/sorties
#include <fstream>// C++ pour gerer les fichiers
#include <string>// C++ pour gerer les chaines de caracteres
#include <vector>// C++ pour gerer les tableaux dynamiques
using namespace std;

struct Produit {
    string nom;
    string categorie;
    float prix;
    int quantite;
};

vector<Produit> stock;

void afficherMenu();
void ajouterProduit();
void afficherStock();
void sauvegarderStock();
void chargerStock();
void modifierProduit();
void supprimerProduit();
void rechercherProduit();
void mettreAJourQuantite();
int rechercherIndexProduit(const string& nom);

int main() {
    chargerStock();
    int choix;
    do {
        afficherMenu();
        cout << "Entrez votre choix : ";
        cin >> choix;
        cin.ignore();

        switch (choix) {
            case 1: ajouterProduit(); break;
            case 2: afficherStock(); break;
            case 3: sauvegarderStock(); break;
            case 4: modifierProduit(); break;
            case 5: supprimerProduit(); break;
            case 6: rechercherProduit(); break;
            case 7: mettreAJourQuantite(); break;
            case 8: cout << "Au revoir !" << endl; break;
            default: cout << "Choix invalide, veuillez réessayer.\n";
        }
    } while (choix != 8);
    return 0;
}

void afficherMenu() {
    cout << "\n******************************************\n";
    cout << "*         Gestion de Stock Magasin       *\n";
    cout << "******************************************\n";
    cout << "* 1. Ajouter un produit                  *\n";
    cout << "* 2. Afficher le stock                   *\n";
    cout << "* 3. Sauvegarder le stock                *\n";
    cout << "* 4. Modifier un produit                 *\n";
    cout << "* 5. Supprimer un produit                *\n";
    cout << "* 6. Rechercher un produit               *\n";
    cout << "* 7. Mettre à jour la quantité           *\n";
    cout << "* 8. Quitter                             *\n";
    cout << "******************************************\n";
}

void ajouterProduit() {
    Produit p;
    cout << "Entrez le nom : ";
    cin >> p.nom;
    cout << "Entrez la catégorie : ";
    cin >> p.categorie;
    cout << "Entrez le prix : ";
    cin >> p.prix;
    cout << "Entrez la quantité : ";
    cin >> p.quantite;
    stock.push_back(p);
    cout << "Produit ajouté avec succès !" << endl;
}

void afficherStock() {
    if (stock.empty()) {
        cout << "Le stock est vide.\n";
        return;
    }
    cout << "\n--- État actuel du stock ---\n";
    for (size_t i = 0; i < stock.size(); i++) {
        cout << i + 1 << ". Nom: " << stock[i].nom
             << " | Catégorie: " << stock[i].categorie
             << " | Prix: " << stock[i].prix
             << " | Quantité: " << stock[i].quantite << endl;
    }
}

void sauvegarderStock() {
    ofstream fichier("stock.txt");
    if (!fichier) {
        cout << "Erreur d'ouverture du fichier pour la sauvegarde.\n";
        return;
    }
    for (const auto& produit : stock) {
        fichier << produit.nom << " " << produit.categorie << " "
                << produit.prix << " " << produit.quantite << endl;
    }
    fichier.close();
    cout << "Stock sauvegardé avec succès.\n";
}

void chargerStock() {
    ifstream fichier("stock.txt");
    if (!fichier) {
        cout << "Aucun fichier trouvé. Un nouveau fichier sera créé.\n";
        return;
    }
    Produit p;
    while (fichier >> p.nom >> p.categorie >> p.prix >> p.quantite) {
        stock.push_back(p);
    }
    fichier.close();
}

int rechercherIndexProduit(const string& nom) {
    for (size_t i = 0; i < stock.size(); i++) {
        if (stock[i].nom == nom) {
            return i;
        }
    }
    return -1;
}

void modifierProduit() {
    string nom;
    cout << "Entrez le nom du produit à modifier : ";
    cin >> nom;

    int index = rechercherIndexProduit(nom);
    if (index == -1) {
        cout << "Produit non trouvé.\n";
        return;
    }

    Produit& p = stock[index];
    cout << "Entrez le nouveau nom : ";
    cin >> p.nom;
    cout << "Entrez la nouvelle catégorie : ";
    cin >> p.categorie;
    cout << "Entrez le nouveau prix : ";
    cin >> p.prix;
    cout << "Entrez la nouvelle quantité : ";
    cin >> p.quantite;

    cout << "Produit modifié avec succès.\n";
}

void supprimerProduit() {
    string nom;
    cout << "Entrez le nom du produit à supprimer : ";
    cin >> nom;

    int index = rechercherIndexProduit(nom);
    if (index == -1) {
        cout << "Produit non trouvé.\n";
        return;
    }

    stock.erase(stock.begin() + index);
    cout << "Produit supprimé avec succès.\n";
}

void rechercherProduit() {
    string nom;
    cout << "Entrez le nom du produit à rechercher : ";
    cin >> nom;

    int index = rechercherIndexProduit(nom);
    if (index == -1) {
        cout << "Produit non trouvé.\n";
    } else {
        const Produit& p = stock[index];
        cout << "Produit trouvé : Nom: " << p.nom
             << " | Catégorie: " << p.categorie
             << " | Prix: " << p.prix
             << " | Quantité: " << p.quantite << endl;
    }
}

void mettreAJourQuantite() {
    string nom;
    cout << "Entrez le nom du produit : ";
    cin >> nom;

    int index = rechercherIndexProduit(nom);
    if (index == -1) {
        cout << "Produit non trouvé.\n";
        return;
    }

    cout << "Entrez la nouvelle quantité : ";
    cin >> stock[index].quantite;

    cout << "Quantité mise à jour avec succès.\n";
}
