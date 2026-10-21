# Basketball Tanger Shop — guide simple (Android)

## Ce qui est inclus
- `index.html` : site responsive en français, catalogue de démonstration (plus de 70 produits), recherche, filtres, panier sauvegardé dans le navigateur et panier envoyé à WhatsApp.
- `supabase-schema.sql` : structure de base de données et règles de sécurité pour que seul un utilisateur autorisé puisse gérer les produits.
- `README.md` : ce guide.

## Important avant de publier
Les 80 fiches de démonstration sont préchargées dans le SQL, mais volontairement non publiées. Leurs prix et stocks sont fictifs : vérifie et remplace chaque fiche par tes vraies informations, ajoute des photos appropriées, puis publie uniquement les articles réellement disponibles.

L'administration est volontairement désactivée tant que Supabase n'est pas configuré. Ne publie pas en production en croyant que les modifications de démonstration sont synchronisées ou sécurisées.

## Étape 1 — Configurer WhatsApp
1. Ouvre `index.html` avec un éditeur de texte.
2. Cherche `const WHATSAPP_NUMBER = "2126XXXXXXXX";`
3. Remplace par ton numéro WhatsApp marocain au format international, sans `+`, espaces ou tirets (ex. commence par `2126...` ou `2127...`).
4. Enregistre le fichier.

Le site n'encaisse aucun paiement et ne valide aucune commande. Il prépare un message WhatsApp que le client doit envoyer lui-même.

## Étape 2 — Créer la base de données gratuite (Supabase)
Supabase propose un niveau gratuit avec limites d'utilisation qui peuvent changer. Vérifie toujours les conditions et quotas affichés dans ton compte.
1. Ouvre https://supabase.com/ et crée un compte.
2. Crée un nouveau projet. Garde le mot de passe de base de données en lieu sûr et ne le mets jamais dans le code du site.
3. Dans le tableau de bord du projet, ouvre **SQL Editor**.
4. Ouvre le fichier `supabase-schema.sql`, copie tout son contenu, colle-le dans SQL Editor et exécute-le.
5. Dans Supabase, ouvre **Authentication → Users** et crée ton utilisateur propriétaire avec ton adresse e-mail et un mot de passe fort.
6. Copie l'UUID de cet utilisateur depuis la liste Users.
7. Dans SQL Editor, exécute la commande suivante en remplaçant l'UUID par celui de ton compte :
   `insert into public.admin_users (user_id) values ('COLLE-ICI-UUID');`
8. Dans **Project Settings → API** (ou Connect), copie l'URL du projet et la clé publique **anon/publishable**. Ne copie jamais la clé `service_role` / secret.
9. Dans `index.html`, remplis `SUPABASE_URL` et `SUPABASE_ANON_KEY` avec ces deux valeurs.
10. Sauvegarde et republie le site.

Les règles SQL limitent les écritures aux comptes dont l'UUID est ajouté dans `admin_users`. Ne donne jamais cette permission à un client.

## Étape 3 — Publier gratuitement sur Cloudflare Pages (téléphone Android)
La méthode la plus simple est généralement via un dépôt GitHub :
1. Crée un compte sur https://github.com/ si nécessaire.
2. Crée un nouveau dépôt, par exemple `basketball-tanger-shop`. Tu peux le garder privé pendant la configuration.
3. Sur GitHub, ouvre le dépôt, choisis **Add file → Upload files**, puis envoie `index.html`. Tu peux aussi envoyer `supabase-schema.sql` et `README.md` pour garder le guide avec le projet.
4. Valide avec **Commit changes**.
5. Ouvre https://dash.cloudflare.com/ et crée un compte.
6. Va dans **Workers & Pages → Create → Pages → Connect to Git** (le libellé peut varier).
7. Connecte GitHub et choisis ton dépôt.
8. Pour un site HTML statique, choisis le déploiement de site statique. Si Cloudflare demande les paramètres : Framework preset `None`, Build command vide, Build output directory `/` ou `.` selon le formulaire. Si un réglage échoue, consulte l'écran d'aide Cloudflare affiché pour ton compte.
9. Déploie. Cloudflare donnera une adresse en `*.pages.dev`.

## Étape 4 — Se connecter au panneau admin
Après avoir configuré Supabase et republié le site :
1. Ouvre le site public.
2. Descends jusqu'à « Administration propriétaire ».
3. Appuie sur « Ouvrir l'administration ».
4. Connecte-toi avec l'e-mail et le mot de passe créés dans Supabase.
5. Ajoute, modifie, publie ou supprime les produits et mets à jour les stocks.

## Images produits
Pour l'instant, le formulaire admin accepte une URL d'image publique. Utilise uniquement des photos que tu as le droit d'utiliser. Une URL d'image doit être accessible publiquement en HTTPS. L'hébergement d'images dans Supabase Storage peut être ajouté plus tard si nécessaire.

## Notes sécurité / limites
- Les clés publiques Supabase sont conçues pour être présentes dans le navigateur ; la sécurité repose sur l'authentification et les politiques RLS du fichier SQL.
- Ne mets jamais de clé secrète ou `service_role` dans `index.html`.
- Les règles SQL protègent l'ajout, la modification et la suppression de produits. La lecture publique ne montre que les produits publiés.
- Ce starter ne réserve pas de stock lors de l'envoi WhatsApp et ne traite pas les commandes ni les paiements.
- Les exemples de stock/prix sont fictifs et doivent être vérifiés.
- Les offres gratuites des services ont des quotas, conditions et règles de suspension susceptibles d'évoluer.

## Dépannage
- WhatsApp ne s'ouvre pas : vérifie le numéro et que WhatsApp ou WhatsApp Web est disponible sur le téléphone.
- Les produits ne se sauvegardent pas : vérifie URL/clé Supabase, exécution du SQL, utilisateur créé et UUID ajouté à `admin_users`.
- Connexion admin refusée : confirme que l'e-mail est confirmé si la configuration Supabase l'exige et que le compte existe dans Authentication → Users.
- Le site ne se met pas à jour : vérifie que le dernier fichier `index.html` a bien été envoyé au dépôt et que le dernier déploiement Cloudflare a réussi.
