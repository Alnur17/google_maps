import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  final String apiKey;

  SearchService({required this.apiKey});

  Future<List<dynamic>> getSuggestions(String input) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String url = '$baseUrl?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['predictions'];
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/details/json';
    String url = '$baseUrl?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['result']['geometry']['location'];
    } else {
      throw Exception('Failed to load place details');
    }
  }
}
