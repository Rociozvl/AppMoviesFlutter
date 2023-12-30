

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';



class MoviesProvider extends ChangeNotifier{
       final String _lenguage ='es-ES';
       final String  _apiKey  ='5c0f832b6608e8e4414036f82061cfe3'; 
       final String  _baseUrl ='api.themoviedb.org';
 
   List<Movie>  onDisplayMovies =[];
   List<Movie>  popularMovies =[];
   Map<int , List<Cast>> moviesCast ={};
   
 


   int _popularPage = 0;
    
    
   final debouncer = Debouncer(
    duration: Duration( milliseconds: 500),
   
    );

   final StreamController<List<Movie>>_suggestionStreamController = StreamController.broadcast();
   Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;

  MoviesProvider(){
   

    getOnDisplayMovies();
    getPopularMovies();
    
    
  }

  Future<String> _getJsonData(String endpoint , [int page = 1]) async{
       final url = Uri.https(_baseUrl, endpoint, {
        'api_key' : _apiKey,
        'lenguage': _lenguage,
        'page': '$page'
   });
     final response = await http.get(url);
     return response.body;

  }



   
   getOnDisplayMovies() async {
      
      final jsonData = await _getJsonData('3/movie/now_playing');
      final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
   
      onDisplayMovies = nowPlayingResponse.results;
      notifyListeners();
}
 getPopularMovies() async {
      _popularPage++;

      final jsonData = await _getJsonData('3/movie/popular' , _popularPage );

      final popularResponse= PopularResponse.fromJson(jsonData);
      popularMovies = [...popularMovies , ...popularResponse.results];
      notifyListeners();
}

Future <List<Cast>> getMovieCast(int movieId) async {

  print('pidiendo info al servidor-Cast');

  final jsonData = await _getJsonData('3/movie/$movieId/credits');
  final creditsResponse = CreditsResponse.fromJson(jsonData);
 


 moviesCast[movieId] = creditsResponse.cast; 

return creditsResponse.cast;

}
 Future<List<Movie>> searchMovies( String query ) async {

    final url = Uri.https( _baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _lenguage,
      'query': query
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson( response.body );

    return searchResponse.results;
  }

  void getSuggestionByQuery(String searchTerm){

      debouncer.value= '';
      debouncer.onValue = ( value) async{
   
           //print('Tenemos valor a buscar: $value');
           final results = await this.searchMovies(value);
           this._suggestionStreamController.add(results);
      };
        
        final timer = Timer.periodic(const Duration(milliseconds: 300), (_){
        debouncer.value = searchTerm;
        });

        Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());
  }


}




