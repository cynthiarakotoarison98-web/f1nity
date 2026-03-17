import 'package:flutter/material.dart';
import 'package:formule_one/models/driver.dart';
import '../widgets/driver_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Liste de données simulée
    final List<Driver> drivers = [

      // --- MCLAREN ---
      Driver(
        firstName: "Lando",
        lastName: "Norris",
        team: "McLaren Formula 1 Team",
        carImage: "assets/images/mcl_car.png",
        driverImage: "assets/images/lando.png",
        detailImage: "assets/images/ln1.png",
        teamLogo: "assets/images/mcl_logo.png",
        flag: "🇬🇧",
        wins: "11",
        gps: "152",
        podiums: "44",
        accentColor: const Color(0xFFFF8700),
        biography: "Champion du monde 2025, Lando Norris est devenu le nouveau visage de la Formule 1. Entré chez McLaren en 2019, il a gravi tous les échelons pour mener son équipe de cœur au sommet.\n\n"
                  "Sa saison 2025 restera dans les annales comme celle de la consécration, où il a su allier une pointe de vitesse dévastatrice à une maturité de champion pour battre Max Verstappen. Artiste dans l'âme, il continue de concevoir ses propres casques, alliant créativité et ambition pour l'ère 2026.",
      ),

      Driver(
        firstName: "Oscar",
        lastName: "Piastri",
        team: "McLaren Formula 1 Team",
        carImage: "assets/images/mcl_car.png",
        driverImage: "assets/images/piastri.png",
        detailImage: "assets/images/op81.png",
        teamLogo: "assets/images/mcl_logo.png",
        flag: "🇦🇺",
        wins: "9",
        gps: "71",
        podiums: "26",
        accentColor: const Color(0xFFFF8700),
        biography: "Né à Melbourne, Oscar Piastri a réalisé l'une des ascensions les plus fulgurantes de l'histoire du sport. Champion consécutif de F3 et F2, il a confirmé son statut de prodige dès ses débuts chez McLaren.\n\n"
                  "En 2025, il a lutté pour le titre jusqu'à l'ultime Grand Prix à Abu Dhabi. Calme et d'une précision chirurgicale, il forme avec Norris le duo le plus compétitif du plateau, prêt à défendre les titres mondiaux de McLaren sous la nouvelle réglementation.",
      ),

      // --- RED BULL RACING ---
      Driver(
        firstName: "Max",
        lastName: "Verstappen",
        team: "Oracle Red Bull Racing",
        carImage: "assets/images/rb_car.png",
        driverImage: "assets/images/max.png",
        detailImage: "assets/images/max-verstappen.png",
        teamLogo: "assets/images/rb_logo.png",
        flag: "🇳🇱",
        wins: "71",
        gps: "233",
        podiums: "127",
        accentColor: const Color(0xFF0600EF),
        biography: "Quadruple champion du monde, Max Verstappen entame 2026 avec une soif de revanche. Après avoir dominé l'ère précédente, il entame un nouveau chapitre avec le moteur Red Bull-Ford.\n\n"
                  "Pilote de records, il reste la référence absolue en termes de talent pur. En 2026, il délaisse le numéro 1 pour reprendre son numéro 33 fétiche, avec l'objectif clair de replacer Red Bull sur le toit du monde face à la menace orange de McLaren.",
      ),

      Driver(
        firstName: "Isack",
        lastName: "Hadjar",
        team: "Oracle Red Bull Racing",
        carImage: "assets/images/rb_car.png",
        driverImage: "assets/images/IsackHadjar.png",
        detailImage: "assets/images/isack-hadjar.png",
        teamLogo: "assets/images/rb_logo.png",
        flag: "🇫🇷",
        wins: "0",
        gps: "23",
        podiums: "1",
        accentColor: const Color(0xFF0600EF),
        biography: "Le nouveau joyau de la filière Red Bull. Après avoir brillé en Formule 2, Isack Hadjar a impressionné le paddock lors de sa première saison chez Racing Bulls en 2025, décrochant un podium historique à Zandvoort.\n\n"
                  "Sa promotion chez Red Bull Racing pour 2026 aux côtés de Verstappen marque le retour d'un pur produit de la filière junior dans l'équipe principale. Rapide et audacieux, il représente l'avenir de la marque autrichienne pour cette nouvelle ère technique.",
      ),

      // --- SCUDERIA FERRARI ---
      Driver(
        firstName: "Charles",
        lastName: "Leclerc",
        team: "Scuderia Ferrari",
        carImage: "assets/images/sf.jpg",
        driverImage: "assets/images/charles.png",
        detailImage: "assets/images/charles16.png",
        teamLogo: "assets/images/sf_logo.png",
        flag: "🇲🇨",
        wins: "8",
        gps: "171",
        podiums: "50",
        accentColor: const Color(0xFFE92C2F),
        biography: "Le Prince de Monaco entame sa huitième saison en rouge. Maître absolu des qualifications, Charles Leclerc porte sur ses épaules les espoirs de tout un peuple, les Tifosi.\n\n"
                  "Pour 2026, il doit faire face au plus grand défi de sa carrière : partager le garage avec Lewis Hamilton. Mais sa détermination reste intacte : ramener le titre mondial à Maranello pour honorer la mémoire de son père et de Jules Bianchi.",
      ),

      Driver(
        firstName: "Lewis",
        lastName: "Hamilton",
        team: "Scuderia Ferrari",
        carImage: "assets/images/sf.jpg",
        driverImage: "assets/images/hamilton.png",
        detailImage: "assets/images/hamilton_full.png",
        teamLogo: "assets/images/sf_logo.png",
        flag: "🇬🇧",
        wins: "105",
        gps: "380",
        podiums: "202",
        accentColor: const Color(0xFFE92C2F),
        biography: "Le transfert du siècle. Lewis Hamilton entame sa deuxième année chez Ferrari avec l'ambition ultime de décrocher un huitième titre mondial historique en rouge.\n\n"
                  "À plus de 40 ans, sa passion et sa science de la course restent inégalées. Dans cette ère 2026, son expérience sera le moteur de la Scuderia pour tenter de dominer la nouvelle réglementation technique et inscrire son nom à jamais dans la légende de Maranello.",
      ),

      // --- MERCEDES ---
      Driver(
        firstName: "George",
        lastName: "Russell",
        team: "Mercedes-AMG Petronas F1",
        carImage: "assets/images/mer_car.png",
        driverImage: "assets/images/russell.png",
        detailImage: "assets/images/russell_full.png",
        teamLogo: "assets/images/mer_logo.png",
        flag: "🇬🇧",
        wins: "5",
        gps: "152",
        podiums: "25",
        accentColor: const Color(0xFF27F4D2),
        biography: "Désormais leader incontesté des Flèches d'Argent, George Russell a la lourde tâche de ramener Mercedes au sommet. Sa constance et son intelligence technique sont ses plus grands atouts.\n\n"
                  "Ayant passé l'essentiel de sa carrière sous l'aile de Toto Wolff, il incarne le présent et le futur de l'étoile. Pour 2026, il compte sur l'excellence du département moteur de Brackley pour redevenir un prétendant régulier à la victoire.",
      ),

      Driver(
        firstName: "Kimi",
        lastName: "Antonelli",
        team: "Mercedes-AMG Petronas F1",
        carImage: "assets/images/mer_car.png",
        driverImage: "assets/images/antonelli.png",
        detailImage: "assets/images/antonelli_full.png",
        teamLogo: "assets/images/mer_logo.png",
        flag: "🇮🇹",
        wins: "0",
        gps: "24",
        podiums: "3",
        accentColor: const Color(0xFF27F4D2),
        biography: "Le futur de l'Italie et de Mercedes. Andrea Kimi Antonelli a brûlé toutes les étapes pour atteindre la F1 à seulement 18 ans. Sa première saison en 2025 a prouvé qu'il avait l'étoffe des plus grands.\n\n"
                  "Plus jeune pilote sur un podium en 2025, il entame 2026 avec une expérience précieuse. Sous la tutelle de Russell, il est prêt à exploser et à ramener le drapeau italien sur la plus haute marche du podium.",
      ),

      // --- AUDI (Anciennement Sauber) ---
      Driver(
        firstName: "Nico",
        lastName: "Hülkenberg",
        team: "Audi F1 Team",
        carImage: "assets/images/aud_car.png",
        driverImage: "assets/images/hulkenberg.png",
        detailImage: "assets/images/hulkenberg_full.png",
        teamLogo: "assets/images/audi_logo.png",
        flag: "🇩🇪",
        wins: "0",
        gps: "244",
        podiums: "0",
        accentColor: const Color(0xFFFF5C00),
        biography: "L'expérience au service de l'ambition allemande. Nico Hülkenberg a été choisi par Audi pour mener son entrée historique en Formule 1.\n\n"
                  "Réputé pour sa fiabilité et sa finesse technique, il est le pilote idéal pour développer le tout nouveau moteur Audi. Pour 2026, son objectif est de transformer les anneaux d'Audi en une force capable de bousculer la hiérarchie établie.",
      ),
      Driver(
        firstName: "Gabriel",
        lastName: "Bortoleto",
        team: "Audi F1 Team",
        carImage: "assets/images/aud_car.png",
        driverImage: "assets/images/bortoleto.png",
        detailImage: "assets/images/bortoleto_full.png",
        teamLogo: "assets/images/audi_logo.png",
        flag: "🇧🇷",
        wins: "0",
        gps: "24",
        podiums: "0",
        accentColor: const Color(0xFFFF5C00),
        biography: "Champion de F3 et de F2, le prodige brésilien Gabriel Bortoleto représente l'avenir d'Audi. Après une année d'apprentissage chez Sauber en 2025, il devient pilote d'usine officiel pour le lancement du projet allemand en 2026. Sous l'aile de Hülkenberg, il a pour mission de porter les espoirs du Brésil vers les sommets de la nouvelle ère technique.",
      ),

      // --- CADILLAC (Nouvelle Écurie) ---
      Driver(
        firstName: "Sergio",
        lastName: "Pérez",
        team: "Cadillac F1 Team",
        carImage: "assets/images/cad_car.png",
        driverImage: "assets/images/perez.png",
        detailImage: "assets/images/perez_full.png",
        teamLogo: "assets/images/cadillac_logo.png",
        flag: "🇲🇽",
        wins: "6",
        gps: "278",
        podiums: "39",
        accentColor: const Color(0xFF302F2F),
        biography: "Un nouveau départ pour 'Checo'. Après ses années Red Bull, le Mexicain devient le visage de l'ambition américaine avec l'arrivée de Cadillac en F1.\n\n"
                  "Son expérience immense et son sens de la gestion pneumatique sont des atouts cruciaux pour une écurie débutante. Pilote de rue hors pair, il espère faire briller les couleurs de Cadillac sur les circuits urbains du monde entier.",
      ),
      Driver(
        firstName: "Valtteri",
        lastName: "Bottas",
        team: "Cadillac F1 Team",
        carImage: "assets/images/cad_car.png",
        driverImage: "assets/images/bottas.png",
        detailImage: "assets/images/bottas_full.png",
        teamLogo: "assets/images/cadillac_logo.png",
        flag: "🇫🇮",
        wins: "10",
        gps: "244",
        podiums: "67",
        accentColor: const Color(0xFF302F2F),
        biography: "Après une année de retrait, Valtteri Bottas fait son grand retour pour mener l'écurie américaine Cadillac. Son expérience de vainqueur de Grand Prix et sa rigueur technique sont des atouts indispensables pour stabiliser cette nouvelle structure. Il forme avec Pérez l'un des duos les plus expérimentés du plateau, prêt à relever le défi de la nouvelle réglementation.",
      ),
      // --- ASTON MARTIN ---
      Driver(
        firstName: "Fernando",
        lastName: "Alonso",
        team: "Aston Martin Aramco F1",
        carImage: "assets/images/ast_car.png",
        driverImage: "assets/images/fernando.png",
        detailImage: "assets/images/fernando_full.png",
        teamLogo: "assets/images/aston_logo.png",
        flag: "🇪🇸",
        wins: "32",
        gps: "426",
        podiums: "106",
        accentColor: const Color(0xFF006F62),
        biography: "Le doyen de la grille entame l'ère Honda-Aston Martin avec une détermination intacte. À 44 ans, l'Espagnol mise sur le nouveau partenariat moteur et les infrastructures de pointe de Silverstone pour décrocher sa mythique 33ème victoire. Son expertise reste l'atout majeur du projet de Lawrence Stroll pour 2026.",
      ),

      Driver(
        firstName: "Lance",
        lastName: "Stroll",
        team: "Aston Martin Aramco F1",
        carImage: "assets/images/ast_car.png",
        driverImage: "assets/images/lance.png",
        detailImage: "assets/images/lance_full.png",
        teamLogo: "assets/images/aston_logo.png",
        flag: "🇨🇦",
        wins: "0",
        gps: "185",
        podiums: "3",
        accentColor: const Color(0xFF006F62),
        biography: "Fidèle à l'écurie depuis 2019, Lance Stroll continue de porter les ambitions d'Aston Martin. Souvent capable de coups d'éclat sous la pluie, il entame cette nouvelle ère avec l'objectif de monter régulièrement sur le podium grâce aux investissements massifs de l'équipe et à l'appui technique de Honda.",
      ),

      // --- WILLIAMS ---
      Driver(
        firstName: "Carlos",
        lastName: "Sainz",
        team: "Williams Racing",
        carImage: "assets/images/wil_car.png",
        driverImage: "assets/images/sainz.png",
        detailImage: "assets/images/sainz_full.png",
        teamLogo: "assets/images/williams_logo.png",
        flag: "🇪🇸",
        wins: "4",
        gps: "228",
        podiums: "30",
        accentColor: const Color(0xFF005AFF),
        biography: "Arrivé chez Williams en 2025, l'Espagnol est le leader technique dont l'écurie avait besoin. Son expérience chez Ferrari est cruciale pour le développement de la FW48. Travailleur acharné, il a pour mission de ramener cette équipe historique vers le haut du milieu de tableau en 2026.",
      ),

      Driver(
        firstName: "Alex",
        lastName: "Albon",
        team: "Williams Racing",
        carImage: "assets/images/wil_car.png",
        driverImage: "assets/images/albon.png",
        detailImage: "assets/images/albon_full.png",
        teamLogo: "assets/images/williams_logo.png",
        flag: "🇹🇭",
        wins: "0",
        gps: "129",
        podiums: "2",
        accentColor: const Color(0xFF005AFF),
        biography: "Pilier de Williams depuis 2022, Alex Albon forme avec Sainz l'un des duos les plus solides de la grille. Sa loyauté et sa capacité à extraire le maximum de sa monoplace ont été récompensées par un contrat longue durée, faisant de lui une pièce maîtresse du renouveau de l'écurie de Grove.",
      ),

      // --- ALPINE ---
      Driver(
        firstName: "Pierre",
        lastName: "Gasly",
        team: "Alpine F1 Team",
        carImage: "assets/images/alp_car.png",
        driverImage: "assets/images/gasly.png",
        detailImage: "assets/images/gasly_full.png",
        teamLogo: "assets/images/alpine_logo.png",
        flag: "🇫🇷",
        wins: "1",
        gps: "170",
        podiums: "4",
        accentColor: const Color(0xFFf5aac9),
        biography: "Le Français mène Alpine dans une phase de transition historique avec l'adoption du moteur Mercedes pour 2026. Malgré les remous techniques, Gasly reste un leader déterminé, espérant que ce changement de motorisation permettra enfin à l'écurie d'Enstone de retrouver les podiums réguliers.",
      ),

      Driver(
        firstName: "Franco",
        lastName: "Colapinto",
        team: "Alpine F1 Team",
        carImage: "assets/images/alp_car.png",
        driverImage: "assets/images/franco.png",
        detailImage: "assets/images/franco_full.png",
        teamLogo: "assets/images/alpine_logo.png",
        flag: "🇦🇷",
        wins: "0",
        gps: "33",
        podiums: "0",
        accentColor: const Color(0xFFf5aac9),
        biography: "Après avoir brillé en remplaçant Doohan en 2025, Franco Colapinto a sécurisé son baquet titulaire chez Alpine. Premier Argentin titulaire depuis des décennies, il apporte une énergie nouvelle et une rapidité qui ont déjà conquis le paddock et ses nouveaux dirigeants.",
      ),

      // --- HAAS ---
      Driver(
        firstName: "Esteban",
        lastName: "Ocon",
        team: "Haas F1 Team",
        carImage: "assets/images/haa_car.png",
        driverImage: "assets/images/ocon.png",
        detailImage: "assets/images/ocon_full.png",
        teamLogo: "assets/images/haas_logo.png",
        flag: "🇫🇷",
        wins: "1",
        gps: "170",
        podiums: "3",
        accentColor: const Color(0xFFE60000),
        biography: "Désormais chez Haas, Esteban Ocon apporte son expérience de vainqueur de Grand Prix à l'écurie américaine. Dans le cadre du nouveau partenariat Toyota-Haas, il a pour rôle d'encadrer le jeune Bearman tout en prouvant qu'il reste l'un des pilotes les plus combatifs du plateau.",
      ),

      Driver(
        firstName: "Oliver",
        lastName: "Bearman",
        team: "Haas F1 Team",
        carImage: "assets/images/haa_car.png",
        driverImage: "assets/images/bearman.png",
        detailImage: "assets/images/bearman_full.png",
        teamLogo: "assets/images/haas_logo.png",
        flag: "🇬🇧",
        wins: "0",
        gps: "25",
        podiums: "0",
        accentColor: const Color(0xFFE60000),
        biography: "Le protégé de la Ferrari Driver Academy entame sa deuxième saison complète avec Haas. Après des débuts tonitruants, il est considéré comme l'un des plus grands espoirs britanniques. 2026 doit être l'année de la confirmation pour celui que beaucoup voient déjà dans un futur baquet rouge.",
      ),

      // --- RACING BULLS (VCARB) ---
      Driver(
        firstName: "Liam",
        lastName: "Lawson",
        team: "Visa Cash App RB",
        carImage: "assets/images/vca_car.png",
        driverImage: "assets/images/lawson.png",
        detailImage: "assets/images/lawson_full.png",
        teamLogo: "assets/images/vcab_logo.png",
        flag: "🇳🇿",
        wins: "0",
        gps: "35",
        podiums: "0",
        accentColor: const Color(0xFF0000FF),
        biography: "Après une longue attente, le Néo-Zélandais est enfin le leader désigné de Racing Bulls. Sa mission pour 2026 est double : obtenir des résultats solides pour l'équipe italienne et prouver qu'il mérite une future promotion chez Red Bull Racing aux côtés de Verstappen.",
      ),

      Driver(
        firstName: "Arvid",
        lastName: "Lindblad",
        team: "Visa Cash App RB",
        carImage: "assets/images/vca_car.png",
        driverImage: "assets/images/lindblad.png",
        detailImage: "assets/images/lindblad_full.png",
        teamLogo: "assets/images/vcab_logo.png",
        flag: "🇬🇧",
        wins: "0",
        gps: "0",
        podiums: "0",
        accentColor: const Color(0xFF0000FF),
        biography: "L'unique véritable rookie de la grille 2026. Issu directement de la filière junior Red Bull, le jeune Britannique Arvid Lindblad fait le grand saut avec le numéro 41. Sa rapidité en formules de promotion a convaincu Helmut Marko de lui donner sa chance dès l'entrée en vigueur des nouvelles règles.",
      ),
      
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.only(
          left: 12,
          right: 12,
          top: 12,
          bottom: 100,
        ),
        itemCount: drivers.length,
        itemBuilder: (context, index) => DriverCard(driver: drivers[index]),
      ),
    );
  }
}
