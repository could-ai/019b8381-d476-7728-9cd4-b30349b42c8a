import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/drama_model.dart';

class ApiService {
  // Base URL based on the repository info provided
  static const String baseUrl = 'https://dramabox.sansekai.my.id/api'; 

  // Fetch Home/Popular Dramas
  Future<List<Drama>> fetchPopularDramas() async {
    try {
      // Trying to hit the likely endpoint. 
      // If this fails (CORS/Offline), we fall back to mock data.
      final response = await http.get(Uri.parse('$baseUrl/popular'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Adjust parsing based on actual API structure. 
        // Assuming { status: true, data: [...] } or just [...]
        List<dynamic> list = (data is Map && data.containsKey('data')) ? data['data'] : data;
        return list.map((e) => Drama.fromJson(e)).toList();
      }
    } catch (e) {
      print('API Error: $e. Using Mock Data.');
    }
    
    // Fallback Mock Data
    return _getMockDramas();
  }

  // Fetch Search Results
  Future<List<Drama>> searchDramas(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search?q=$query'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> list = (data is Map && data.containsKey('data')) ? data['data'] : data;
        return list.map((e) => Drama.fromJson(e)).toList();
      }
    } catch (e) {
      print('Search Error: $e');
    }
    return [];
  }

  // Fetch Details
  Future<Map<String, dynamic>> fetchDramaDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/detail?id=$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Detail Error: $e');
    }
    return _getMockDetail(id);
  }

  // Mock Data Generators for UI testing when API is unreachable
  List<Drama> _getMockDramas() {
    return List.generate(10, (index) => Drama(
      title: 'Drama Title ${index + 1}',
      posterUrl: 'https://picsum.photos/300/450?random=$index',
      id: 'drama_$index',
      synopsis: 'This is a mock synopsis for Drama ${index + 1}. It tells a compelling story about something interesting happening in a fictional world.',
      status: 'Ongoing',
      genres: 'Action, Romance',
    ));
  }

  Map<String, dynamic> _getMockDetail(String id) {
    return {
      'title': 'Mock Drama Detail',
      'poster': 'https://picsum.photos/300/450?random=99',
      'synopsis': 'Full detail synopsis goes here. This is a fallback because the API might be down or blocked by CORS in the browser.',
      'genres': 'Drama, Thriller',
      'episodes': List.generate(5, (i) => {
        'title': 'Episode ${i + 1}',
        'id': 'ep_$i',
        'date': '2023-10-0${i+1}'
      })
    };
  }
}
