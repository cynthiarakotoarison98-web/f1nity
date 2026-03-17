import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DetailPage extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String date;
  final String content;

  const DetailPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFFE92C2F),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          Image.asset(
            image,
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(date, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 20),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 10),
                Markdown(
                  data: content,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(4.0),
                  physics: const NeverScrollableScrollPhysics(),
                  styleSheet: MarkdownStyleSheet(
                    // 1. Centrage des titres et paragraphes
                    h1Align: WrapAlignment.center,
                    
                    // 2. Les Guillemets Jaunes
                    h1: const TextStyle(
                      fontSize: 60,
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.bold,
                    ),

                    // 3. LA CORRECTION : Style de la citation via 'em' (italique)
                    // On définit la couleur marron ici pour qu'elle ne soit pas écrasée par le noir de 'p'
                    em: const TextStyle(
                      fontSize: 19,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(221, 219, 164, 0),
                      height: 1.5,
                      
                    ),
                    strong: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 2, 33, 76)
                    ),

                    // 4. Nettoyage du bloc de citation
                    blockquoteAlign: WrapAlignment.center,
                    blockquotePadding: EdgeInsets.zero,
                    blockquoteDecoration: const BoxDecoration(color: Colors.transparent),

                    // 5. Styles standards
                    h2: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE92C2F)),
                    p: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.black87),
                    blockSpacing: 20,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
