import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/screens/screens.dart';
import 'package:peliculas/search/search_delegate.dart';

import 'package:peliculas/widgets/card_swiper.dart';
import 'package:provider/provider.dart';



class HomeScreens extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    
   final moviesProvider = Provider.of<MoviesProvider>(context);
   
   print(moviesProvider.onDisplayMovies);

    return Scaffold( 
      appBar: AppBar(
        title: const Text('Peliculas de cines'),
        elevation: 0,
        centerTitle: true,
         actions:  [
           IconButton(
             onPressed: ()=> showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(Icons.search_outlined))
         ],
      ),
      body:  SingleChildScrollView(
        child: Column(
        children: [
          CardSwiper( movies: moviesProvider.onDisplayMovies,),
          MovieSlider(
            movies: moviesProvider.popularMovies,
            title: 'Populares',
            onNextPage: ()=>{
              moviesProvider.getPopularMovies()
            }
            ,
          ),
        ],
      )
      ),
    );
  }
}