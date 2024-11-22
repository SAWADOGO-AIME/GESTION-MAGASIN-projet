import os

# Structure des données pour un produit
class Produit:
    def __init__(self, nom, categorie, prix, quantite):
        self.nom = nom
        self.categorie = categorie
        self.prix = prix
        self.quantite = quantite

    def __str__(self):
        return f"Nom: {self.nom}, Catégorie: {self.categorie}, Prix: {self.prix:.2f}, Quantité: {self.quantite}"


# Liste pour stocker les produits
stock = []

# Fichier pour la persistance
FICHIER = "stock.txt"


# Fonction pour afficher le menu
def afficher_menu():
    print("\n******************************************")
    print("*         Gestion de Stock Magasin       *")
    print("******************************************")
    print("* 1. Ajouter un produit                  *")
    print("* 2. Afficher le stock                   *")
    print("* 3. Sauvegarder le stock                *")
    print("* 4. Modifier un produit                 *")
    print("* 5. Supprimer un produit                *")
    print("* 6. Rechercher un produit               *")
    print("* 7. Mettre à jour la quantité           *")
    print("* 8. Quitter                             *")
    print("******************************************")


# Charger les données depuis un fichier
def charger_stock():
    if not os.path.exists(FICHIER):
        print(f"Fichier '{FICHIER}' introuvable. Un nouveau fichier sera créé.")
        return

    with open(FICHIER, "r") as f:
        for ligne in f:
            parts = ligne.strip().split(",")
            if len(parts) == 4:
                nom, categorie, prix, quantite = parts
                stock.append(Produit(nom, categorie, float(prix), int(quantite)))


# Sauvegarder les données dans un fichier
def sauvegarder_stock():
    with open(FICHIER, "w") as f:
        for produit in stock:
            f.write(f"{produit.nom},{produit.categorie},{produit.prix},{produit.quantite}\n")
    print("Stock sauvegardé avec succès.")


# Ajouter un produit
def ajouter_produit():
    nom = input("Entrez le nom du produit : ")
    categorie = input("Entrez la catégorie : ")
    prix = float(input("Entrez le prix : "))
    quantite = int(input("Entrez la quantité : "))
    stock.append(Produit(nom, categorie, prix, quantite))
    print("Produit ajouté avec succès !")


# Afficher le stock
def afficher_stock():
    if not stock:
        print("Le stock est vide.")
        return

    print("\n--- État actuel du stock ---")
    for i, produit in enumerate(stock, 1):
        print(f"{i}. {produit}")


# Rechercher un produit par son nom
def rechercher_produit():
    nom = input("Entrez le nom du produit à rechercher : ")
    for produit in stock:
        if produit.nom.lower() == nom.lower():
            print("Produit trouvé :")
            print(produit)
            return
    print("Produit non trouvé.")


# Modifier un produit
def modifier_produit():
    nom = input("Entrez le nom du produit à modifier : ")
    for produit in stock:
        if produit.nom.lower() == nom.lower():
            produit.nom = input("Entrez le nouveau nom : ")
            produit.categorie = input("Entrez la nouvelle catégorie : ")
            produit.prix = float(input("Entrez le nouveau prix : "))
            produit.quantite = int(input("Entrez la nouvelle quantité : "))
            print("Produit modifié avec succès.")
            return
    print("Produit non trouvé.")


# Supprimer un produit
def supprimer_produit():
    nom = input("Entrez le nom du produit à supprimer : ")
    for i, produit in enumerate(stock):
        if produit.nom.lower() == nom.lower():
            del stock[i]
            print("Produit supprimé avec succès.")
            return
    print("Produit non trouvé.")


# Mettre à jour la quantité d'un produit
def mettre_a_jour_quantite():
    nom = input("Entrez le nom du produit : ")
    for produit in stock:
        if produit.nom.lower() == nom.lower():
            produit.quantite = int(input("Entrez la nouvelle quantité : "))
            print("Quantité mise à jour avec succès.")
            return
    print("Produit non trouvé.")


# Fonction principale
def main():
    charger_stock()
    while True:
        afficher_menu()
        choix = input("Entrez votre choix : ")
        if choix == "1":
            ajouter_produit()
        elif choix == "2":
            afficher_stock()
        elif choix == "3":
            sauvegarder_stock()
        elif choix == "4":
            modifier_produit()
        elif choix == "5":
            supprimer_produit()
        elif choix == "6":
            rechercher_produit()
        elif choix == "7":
            mettre_a_jour_quantite()
        elif choix == "8":
            print("Merci d'avoir utilisé le programme. Au revoir !")
            sauvegarder_stock()
            break
        else:
            print("Choix invalide, veuillez réessayer.")


if __name__ == "__main__":
    main()
