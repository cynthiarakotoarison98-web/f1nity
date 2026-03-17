import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class YouTubeEmbedCard extends StatefulWidget {
  final String videoId; // ex: Pv7QI1ZbbI4
  const YouTubeEmbedCard({super.key, required this.videoId});

  @override
  State<YouTubeEmbedCard> createState() => _YouTubeEmbedCardState();
}

class _YouTubeEmbedCardState extends State<YouTubeEmbedCard> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final html = """
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">
    <style>
      html, body { margin:0; padding:0; background:#000; height:100%; }
      .wrap { position:relative; width:100%; height:100%; }
      iframe {
        position:absolute; top:0; left:0;
        width:100%; height:100%;
        border:0;
      }
    </style>
  </head>
  <body>
    <div class="wrap">
      <iframe
        src="https://www.youtube.com/embed/${widget.videoId}?autoplay=1&playsinline=1&rel=0&modestbranding=1"
        title="YouTube video player"
        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
        allowfullscreen>
      </iframe>
    </div>
  </body>
</html>
""";

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 185,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFF3F3F3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: WebViewWidget(controller: _controller),
    );
  }
}