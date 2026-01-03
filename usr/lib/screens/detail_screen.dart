import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/drama_model.dart';
import '../services/api_service.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ApiService _apiService = ApiService();
  Future<Map<String, dynamic>>? _detailFuture;
  Drama? _initialDrama;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Drama && _initialDrama == null) {
      _initialDrama = args;
      if (_initialDrama?.id != null) {
        _detailFuture = _apiService.fetchDramaDetail(_initialDrama!.id!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_initialDrama == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _initialDrama!.title,
                style: const TextStyle(
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black, blurRadius: 10)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: _initialDrama!.posterUrl ?? '',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_initialDrama!.genres != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _initialDrama!.genres!,
                        style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Text(
                    _initialDrama!.synopsis ?? 'No synopsis available.',
                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Episodes',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<Map<String, dynamic>>(
                    future: _detailFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      
                      // Handle mock or real data structure
                      List<dynamic> episodes = [];
                      if (snapshot.hasData) {
                        episodes = snapshot.data!['episodes'] ?? [];
                      } else {
                        // Fallback if detail fetch fails but we have the basic object
                        // Just show a placeholder or empty
                        return const Text('Could not load episodes.');
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: episodes.length,
                        separatorBuilder: (context, index) => const Divider(color: Colors.white10),
                        itemBuilder: (context, index) {
                          final ep = episodes[index];
                          final title = ep['title'] ?? 'Episode ${index + 1}';
                          final id = ep['id'] ?? ep['url'];
                          
                          return ListTile(
                            tileColor: Colors.grey[900],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            leading: const Icon(Icons.play_circle_fill, color: Colors.redAccent),
                            title: Text(title, style: const TextStyle(color: Colors.white)),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
                            onTap: () {
                              Navigator.pushNamed(
                                context, 
                                '/player',
                                arguments: {'url': 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', 'title': title} // Using sample video for demo as real links expire/need scraping
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
