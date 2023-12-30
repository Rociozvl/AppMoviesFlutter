


import 'package:flutter/material.dart' ;

import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/casting.cards.dart';




class DetailsScreens extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    //ruta para traer argumentos
    final Movie movie = ModalRoute.of(context)!.settings.arguments  as Movie;
    
    
    
        return Scaffold(
        body:  CustomScrollView( 
          slivers:  [
             _CustomAppBar(movie: movie,),
             SliverList(
              delegate: SliverChildListDelegate(
                [
                  _PosterAndTitle(movie: movie),
                  _OverView(movie : movie),
                   _OverView(movie : movie),
                    _OverView(movie : movie),
                    CastingCards( movie.id,  ),
                  
                  

                 
                
                ]
              )
              
              )
          ],
          ),
    );
  }
}
class _CustomAppBar extends StatelessWidget {

     final Movie movie;

  const _CustomAppBar({super.key, required this.movie});

  
  

  @override
  Widget build(BuildContext context) {

    //sliverappBar tienen comportamientos cuando se hace scroll
    return  SliverAppBar(
      //backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating:false,                                             
      pinned: true,
   
      flexibleSpace: FlexibleSpaceBar(
      centerTitle: true,
      titlePadding: const EdgeInsets.all(0),

        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10,left: 10, right:10),
        
          child: Text( 
            movie.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16)
          ),
        ),


        background: FadeInImage(
        placeholder: const AssetImage('assets/loading.gif'),
        image: NetworkImage(movie.fullBackdropPath),
        fit: BoxFit.cover,
      
      ),
      ),
    );
  }

}


class _PosterAndTitle extends StatelessWidget {
    
    final Movie movie;

  const _PosterAndTitle({super.key, required this.movie});
    
  @override
  Widget build(BuildContext context) {

    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
       margin: const EdgeInsets.only(top: 20),
       padding: const EdgeInsets.symmetric(horizontal:20),
       child: Row(
         children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(movie.fullPosterImg),
              height: 150,
             
             ),
            ),
          ),

          const SizedBox( width: 20 ),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth:size.width - 190),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            
                Text(movie.title , style: textTheme.bodyLarge,overflow: TextOverflow.ellipsis, maxLines: 2,),
                Text(movie.originalTitle, style: textTheme.bodySmall,overflow: TextOverflow.ellipsis, maxLines: 2, ),
              
                    Row(
                      children: [
                        const Icon(Icons.star_border),
                        const SizedBox( width: 5,),
                        Text('${movie.voteAverage}' , style: Theme.of(context).textTheme.bodySmall)
                      ],
                    )
              
              
              
              ],
            ),
          )
         ],
       )

    );
  }
}


class _OverView extends StatelessWidget {

     final Movie movie;

  const _OverView({ required this.movie});

  @override
  Widget build(BuildContext context) {



    return  Container(
      padding: const EdgeInsets.symmetric( horizontal: 10 , vertical: 10),
           child: Text(
           movie.overview,
            textAlign: TextAlign.justify,
            style: Theme.of(context).textTheme.bodyMedium,
            
            ),
           
    
    );
  }
}