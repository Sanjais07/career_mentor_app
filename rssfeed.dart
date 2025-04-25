import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class RSSFeedPage extends StatefulWidget {
  const RSSFeedPage({super.key});

  @override
  State<RSSFeedPage> createState() => _RSSFeedPageState();
}

class _RSSFeedPageState extends State<RSSFeedPage> {
  RssFeed? _feed;
  bool _isLoading = true;

  // Feed URL using AllOrigins to bypass CORS (for web)
  final String _rssUrl = 'https://api.allorigins.win/get?url=https://medium.com/feed/flutter';

  @override
  void initState() {
    super.initState();
    _loadFeed();
  }

  Future<void> _loadFeed() async {
    try {
      final response = await http.get(Uri.parse(_rssUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final String rawXml = jsonResponse['contents'];

        final rssFeed = RssFeed.parse(rawXml);

        setState(() {
          _feed = rssFeed;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load RSS feed');
      }
    } catch (e) {
      print("RSS Fetch Error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _openLink(String? url) async {
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot open link")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter RSS Feed (dart_rss)"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 5,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _feed == null
              ? const Center(child: Text("Failed to load RSS feed"))
              : ListView.builder(
                  itemCount: _feed!.items.length,
                  itemBuilder: (context, index) {
                    final item = _feed!.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        title: Text(
                          item.title ?? "No Title",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          item.pubDate ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: const Icon(
                          Icons.open_in_new,
                          color: Colors.blue,
                        ),
                        onTap: () => _openLink(item.link),
                      ),
                    );
                  },
                ),
    );
  }
}
