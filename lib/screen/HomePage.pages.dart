import 'package:flutter/material.dart';
import 'package:formule_one/screen/DetailPage.pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: ListView(
        children: [
          /// 🔴 IMAGE PRINCIPALE
          Stack(
            children: [
              Container(
                height: 220,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Bahrein.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              /// Badge rouge
              Positioned(
                bottom: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    "PLUS D'ACTUALITÉ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// Latest News
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Latest news",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 15),

          /// Liste des news
          _buildNewsItem(
            context,
            "assets/images/sf-26.jpg",
            "Le bilan complet de la pré-saison 2026 de F1",
            "Le rideau tombe sur la préparation hivernale. Qui a bluffé ? Qui domine vraiment ? Tout ce qu'il faut retenir de cette pré-saison intense avant le coup d'envoi officiel de la saison 2026 de la F1.",
            "Il y a 1 j",
            """
##  Les Tops : Ferrari et Mercedes impressionnent

###  Ferrari en patron
La Scuderia semble avoir dompté le nouveau moteur hybride...

###  Mercedes retrouve le sourire
Plus de **6 000 km** parcourus...

##  L'énigme : Où est Red Bull ?
Discrétion inhabituelle pour Max Verstappen...

##  Les Flops : Alerte rouge chez Aston Martin
C'est la douche froide pour Fernando Alonso...

##  3 chiffres clés à retenir
- **1:31.992** → Le chrono de référence établi par Leclerc.
- **50%** → La part de puissance électrique.
- **6 000 km** → Kilométrage record.

##  Le verdict de la rédac'
Ferrari semble devant mais la gestion de l’Aéro Active sera clé.
            """,
          ),

          _buildNewsItem(
            context,
            "assets/images/aston-martin.png",
            "Aston Martin dit stop après une dernière journée catastrophe",
            "Aston Martin a mis fin à ses essais hivernaux 2026 après seulement six tours dans l'ultime journée de roulage.",
            "hier",
            """
Aston Martin a officiellement annoncé la fin de ses essais hivernaux 2026, dans une journée déjà largement entravée par les soucis techniques rencontrés la veille.

Il était clair, dès le communiqué publié par Honda en début de journée, que ce vendredi risquait d'être très long du côté d'Aston Martin. La voiture britannique, victime d'une défaillance de batterie de son moteur jeudi et souffrant d'un manque de pièces de rechange, était en effet cantonnée à des relais "courts".

Et courts, ils l'ont été, sans doute au-delà de ce que beaucoup pouvaient craindre puisque Lance Stroll, au volant ce vendredi, n'a parcouru que deux tours d'installation en matinée, avant d'en ajouter quatre autres lors du début d'après-midi. 

Dans ces conditions, aux alentours de 14h40, plus de deux heures avant le drapeau à damier, un nouveau communiqué venu de l'équipe elle-même est tombé comme un couperet, annonçant la fin de cet ersatz de roulage : "Nous avons terminé notre programme pour aujourd'hui."

Les six tours peu représentatifs de ce vendredi s'ajoutent donc à deux journées déjà loin des standards fixés par la plupart des autres constructeurs lors de ces tests, pour un total sur les trois derniers jours de 128 boucles parcourus par l'AMR26 et le moteur Honda. Un nombre que plusieurs équipes ont, au moment d'écrire ces lignes, déjà dépassé sur ce seul vendredi.

"Hier, nous avons eu quelques problèmes de batterie sur la voiture de Fernando [Alonso], et c'est pourquoi Honda effectue actuellement des simulations sur le banc d'essai de Sakura", expliquait Pedro de la Rosa, ambassadeur de l'équipe pour F1 TV, plus tôt dans la journée.

"Pour cette raison, et aussi parce que nous manquons de pièces, nous ferons très peu de tours aujourd'hui. Ils seront courts et espacés d'au moins une demi-heure, ce qui nous permettra d'étudier attentivement les données et de tester certaines choses lors de ces quelques tours. Mais oui, nous ne ferons certainement pas de longs relais aujourd'hui."

# ❝

> _"Nous ne sommes pas où nous voulions, mais ça ne veut pas dire que nous n'accomplirons pas notre mission."_ 

Dans un message vidéo posté par l'écurie, il avait ajouté : "Nous ne sommes clairement pas là où nous voulions être, mais nous avons réussi à réunir beaucoup de données, et ça va nous donner l'opportunité de les analyser dans les prochains jours, et de trouver des solutions. Nous savons dans quels domaines nous devons mettre l'accent et améliorer la voiture, ce qui est très positif. Le nouveau règlement et très compliqué, mais il est aussi fascinant."

"On savait que ça n'allait pas être facile, mais nous avons aussi de grandes ressources, nous avons notre campus à Silverstone, nous avons Sakura où ils travaillent d'arrache-pied pour nous emmener là où l'on veut être. On doit redoubler d'efforts. Il reste quelques jours avant l'Australie. Nous ne sommes pas où nous voulions, mais ça ne veut pas dire que nous n'accomplirons pas notre mission."    
            """,
          ),

          _buildNewsItem(
            context,
            "assets/images/essaie.jpg",
            "Essais F1 2026 - Mercredi à Bahreïn",
            "Retrouvez les plus belles photos de la journée de mercredi à Bahreïn, où se déroulent les essais hivernaux pour préparer la saison F1 2026.",
            "16 Fev. 2026",
            """
## Les tests 2026 de Pirelli à Bahreïn
Pirelli a poursuivi le développement de ses pneus 2026 à Bahreïn, avec l'aide des écuries Williams et Alpine, les 2 et 3 mars 2025.

![Voiture](resource:assets/images/carlos-sainz.png)
**Carlos sainz ~ Williams**

![Voiture](resource:assets/images/ryo-hirakawa-alpine.png)
**Ryo hirakawa ~ Alpine**

![Voiture](resource:assets/images/isack-hadjar-red-bull-racing-3.png)
**Isack Hadjar ~ Redbull**

![Voiture](resource:assets/images/1200-L-f1-le-verdict-implacable-des-essais-2026-bahren-deux-curies-en-patrons.jpg)
**Charles Leclerc ~ Scuderia Ferrari**
            """,
          ),

          _buildNewsItem(
            context,
            "assets/images/lando-norris-mclaren-3.jpg",
            "Lando Norris remporte son premier championnat du monde des pilotes de Formule 1.",
            "La suprématie n'est pas la seule chose que Norris retiendra en remportant le championnat du monde des pilotes de Formule 1 2025 à Abou Dhabi.",
            "7 dec. 2025",
            """
La Formule 1 compte un nouveau champion du monde. Âgé de 26 ans depuis quelques semaines, Lando Norris est devenu ce dimanche le 35e pilote sacré dans l'histoire de la discipline, lors de la finale de la saison 2025. Le Britannique avait déjà eu une première balle de match au Qatar.

Si, sur les derniers mois, le sacre de Norris paraissait très probable, tant la dynamique globale chez McLaren penchait en sa faveur, la saison du natif de Bristol n'aura pas été un long fleuve tranquille et a bien failli se transformer en cruelle désillusion.
Débutée par une victoire tout en maîtrise dans des conditions pourtant très difficiles à Melbourne, Norris assistait ensuite à la montée en puissance annoncée de son équipier Oscar Piastri, qui prenait les commandes du championnat au soir de la cinquième épreuve de l'année en Arabie saoudite.

![Voiture](resource:assets/images/wdc.jpeg)
**Lando Norris - MCLaren Champion du monde 2025**

S'offrant ensuite un succès de prestige dans les rues de Monaco, Norris allait aussi - quelques semaines plus tard - commettre une grosse erreur d'appréciation en tentant de dépasser son équipier dans les derniers tours du GP du Canada. S'il a de justesse évité l'irréparable, qui aurait été de mettre les deux McLaren au tapis, cela lui coûtait cher sur le plan personnel puisqu'il était alors renvoyé à 22 points de l'Australien.

L'été marquait un véritable rebond pour Norris, vainqueur de trois des quatre Grands Prix avant la trêve estivale, qu'il abordait avec un déficit de neuf unités sur Piastri. Mais cet écart allait de nouveau augmenter de façon spectaculaire en raison d'un nouvel abandon, cette fois sur problème mécanique, dès la manche de rentrée à Zandvoort, alors qu'il était second. Son équipier vainqueur, Norris pointait alors à 34 points de la tête du classement.
            """,
          ),
        ],
      ),
    );
  }

  /// Widget réutilisable pour un article
  static Widget _buildNewsItem(
    BuildContext context,
    String image,
    String title,
    String subtitle,
    String date,
    String content,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(
              image: image,
              title: title,
              subtitle: subtitle,
              date: date,
              content: content,
            ),
          ),
        );
      },
      child: SizedBox(
        height: 230,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  image,
                  width: 170,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    if (date.isNotEmpty)
                      Text(
                        date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}