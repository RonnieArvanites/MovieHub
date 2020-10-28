//
//  MovieView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays movie data
struct MovieView: View {
    
    @ObservedObject var movieFetcher: MovieFetcher
    
    // Used for swap back gesture
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var trailerTabState: TrailerPageState
    
    // Grid column formating
    var columns: [GridItem] =
        [GridItem(.adaptive(minimum: 60), spacing: 5)]
    
    var movieId: Int
    
    init(movieId: Int) {
        self.movieId = movieId
        // Initializes MovieFetcher with the movie id
        _movieFetcher = ObservedObject(wrappedValue: MovieFetcher(movieId: movieId))
    }
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack{
                /*
                 NavBar
                 */
                NavBarWithShareButton(shareLink: "https://www.themoviedb.org/movie/\(self.movieId)")
                
                Spacer().frame(height:0)
                
                ScrollView(showsIndicators: false){
                    // Checks if data is loaded from api call
                    if movieFetcher.dataIsLoaded && !movieFetcher.connectionError {
                        ZStack{
                            /*
                             Backdrop Image
                             */
                            // Checks if backdrop image is available
                            if movieFetcher.movie?.backdropURL != nil {
                                WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(movieFetcher.movie!.backdropURL!)")
                                )
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: 187.5)
                                .clipped()
                                .opacity(0.4)
                            }
                            HStack{
                                VStack{
                                    /*
                                     Movie Poster
                                     */
                                    // Check if movie poster is available
                                    if movieFetcher.movie?.posterURL != nil {
                                        WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(movieFetcher.movie!.posterURL!)"))
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 125, height: 187.5, alignment: .center)
                                            .clipped()
                                    } else {
                                        Image("NoImage")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 125, height: 187.5, alignment: .center)
                                            .clipped()
                                    }
                                }
                                
                                VStack{
                                    /*
                                     Movie Title
                                     */
                                    Text(movieFetcher.movie!.title)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.center)
                                    
                                    HStack{
                                        /*
                                         Movie Rating
                                         */
                                        Text(movieFetcher.movie!.rating!)
                                            .font(.system(size: 15))
                                            .padding(.all, 5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.white, lineWidth: 1)
                                            )
                                        
                                        /*
                                         Movie Score
                                         */
                                        // Checks if score is available for that movie
                                        if movieFetcher.movie!.voteCount != 0{
                                            ScoreIcon(score: (movieFetcher.movie!.score / 10) * 100)
                                        }
                                    }
                                    
                                    Spacer().frame(height: 5)
                                    
                                    /*
                                     Movie Runtime
                                     */
                                    // Checks if runtime is 0 which means no runtime info for that movie
                                    if movieFetcher.movie!.runtime != 0 && movieFetcher.movie!.runtime != nil {
                                        HStack{
                                            // Checks if hour is zero
                                            if (movieFetcher.movie!.runtime! / 60 != 0) {
                                                Text("\(movieFetcher.movie!.runtime! / 60)h")
                                                    .font(.system(size: 15))
                                            }
                                            // Checks if minute is zero
                                            if (movieFetcher.movie!.runtime! % 60 != 0) {
                                                Text("\(movieFetcher.movie!.runtime! % 60)m")
                                                    .font(.system(size: 15))
                                            }
                                        }
                                        
                                        Spacer().frame(height: 5)
                                    }
                                    
                                    /*
                                     Movie Release Date
                                     */
                                    // Checks if release date is nil
                                    if movieFetcher.movie!.releaseDate != nil {
                                        Text(movieFetcher.movie!.releaseDate!.toMDYString())
                                            .minimumScaleFactor(0.5)
                                            .font(.system(size: 15))
                                        
                                        Spacer().frame(height: 5)
                                    }
                                    
                                    /*
                                     Movie Genres
                                     */
                                    Text(movieFetcher.movie!.genreList())
                                        .minimumScaleFactor(0.5)
                                        .font(.system(size: 15))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 200, height: 187.5)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        /*
                         Movie Overview
                         */
                        if !movieFetcher.movie!.overview.isEmpty {
                            VStack{
                                Text("Overview")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                
                                Text(movieFetcher.movie!.overview)
                                    .font(.system(size: 15))
                                    .fixedSize(horizontal: false, vertical: true)
                                
                            }
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        }
                        
                        Spacer().frame(height: 5)
                        
                        /*
                         Movie Stats
                         */
                        VStack{
                            /*
                             Movie Directors
                             */
                            // Check if directors is empty
                            if !movieFetcher.movie!.directors!.isEmpty {
                                HStack(alignment: .top){
                                    Text(movieFetcher.movie!.directors!.count > 1 ? "Directors:" : "Director:")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .topLeading)
                                    Text("\(movieFetcher.movie!.directorString())")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                            
                            /*
                             Movie Writer
                             */
                            //Check if writer is empty
                            if !movieFetcher.movie!.writers!.isEmpty {
                                HStack(alignment: .top){
                                    Text(movieFetcher.movie!.writers!.count > 1 ? "Writers:" : "Writer:")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .topLeading)
                                    Text("\(movieFetcher.movie!.writersString())")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                            
                            /*
                             Movie Film Studios
                             */
                            //Checks if movie has film studios
                            if !movieFetcher.movie!.filmStudios!.isEmpty {
                                HStack(alignment: .top){
                                    Text(movieFetcher.movie!.filmStudios!.count > 1 ? "Film Studios:" : "Film Studio:")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .topLeading)
                                    Text("\(movieFetcher.movie!.filmStudiostoString())")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                            
                            /*
                              Movie Revenue
                             */
                            // Checks if revenue is 0
                            if movieFetcher.movie!.revenue != 0{
                                HStack(alignment: .top){
                                    Text("Revenue:")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .topLeading)
                                    Text("$\(movieFetcher.movie!.revenue)")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                            
                            /*
                              Movie Budget
                             */
                            // Checks if budget is 0
                            if movieFetcher.movie!.budget != 0 {
                                HStack(alignment: .top){
                                    Text("Budget:")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .topLeading)
                                    Text("$\(movieFetcher.movie!.budget)")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                        }
                        
                        Spacer().frame(height: 5)
                        
                        
                        /*
                         Movie Cast
                         */
                        // Check if cast list is not empty
                        if !(movieFetcher.movie?.castAndCrew?.cast.isEmpty)! {
                            Text("Cast")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            
                            Spacer().frame(height: 5)
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                LazyHStack(spacing: 10) {
                                    ForEach((movieFetcher.movie?.castAndCrew?.cast)!) { castMember in
                                        /*
                                         Cast List Item
                                         */
                                        CastListItem(castMember: castMember)
                                    }
                                }
                            }
                            .frame(height: 200)
                            
                            Spacer().frame(height: 5)
                        }
                        
                        VStack{
                            /*
                             Movie Trailers
                             */
                            // Check if movie has trailers
                            if !(movieFetcher.movie?.trailers?.trailers.isEmpty)! {
                                VStack{
                                    Text("Trailers")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                    
                                    Spacer().frame(height: 0)
                                    
                                        // Check if movie has vimeo trailers
                                    if movieFetcher.movie?.vimeoTrailers != nil {
                                        TabView(selection: self.$trailerTabState.currentPageIndex){
                                            // Check if youtube trailers are available
                                            if movieFetcher.movie?.youtubeTrailers != nil {
                                                // Displays youtube trailers
                                                ForEach((movieFetcher.movie?.youtubeTrailers)!, id: \.self){ trailer in
                                                    TrailerListItem(youtubeTrailer: trailer)
                                                }
                                            }
                                            // Check if vimeo trailers are available
                                            if movieFetcher.movie?.vimeoTrailers != nil {
                                                // Displays vimoe trailers
                                                ForEach((movieFetcher.movie?.vimeoTrailers)!, id: \.self){ trailer in
                                                    TrailerListItem(vimeoTrailer: trailer)
                                                }
                                            }
                                        }
                                        .frame(width: UIScreen.main.bounds.width, height: (0.56 * UIScreen.main.bounds.width))
                                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                    } else {
                                        TabView(selection: self.$trailerTabState.currentPageIndex){
                                            //Check if youtube trailers are available
                                            if movieFetcher.movie?.youtubeTrailers != nil {
                                                // Displays youtube trailers
                                                ForEach((movieFetcher.movie?.youtubeTrailers)!, id: \.self){ trailer in
                                                    TrailerListItem(youtubeTrailer: trailer)
                                                }
                                            }
                                        }
                                        .frame(width: UIScreen.main.bounds.width, height: (0.56 * UIScreen.main.bounds.width))
                                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                    }
                                }
                            }
                            
                            /*
                             Movie Collection
                             */
                            // Checks if movie is part of a collection
                            if movieFetcher.movie?.movieCollection != nil && !(movieFetcher.movie?.movieCollectionMovies?.isEmpty)! {
                                Text("Part of the \((movieFetcher.movie?.movieCollection!.name)!)")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                
                                Spacer().frame(height: 5)
                                
                                ScrollView(.horizontal, showsIndicators: false){
                                    HStack(spacing: 10) {
                                        ForEach((movieFetcher.movie?.movieCollectionMovies)!) { movie in
                                            /*
                                             Collecton Movie
                                             */
                                            MovieGridItem(movie: movie)
                                        }
                                    }
                                }
                                .frame(height: 262.5)
                            }
                            
                            /*
                             Similar Movies
                             */
                            // Checks if movie has similar movies
                            if !(movieFetcher.movie?.similarMovies?.movies.isEmpty)! {
                                Text("Similar Movies")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                
                                Spacer().frame(height: 5)
                                
                                ScrollView(.horizontal, showsIndicators: false){
                                    LazyHStack(spacing: 10) {
                                        ForEach((movieFetcher.movie?.similarMovies?.movies)!) { movie in
                                            /*
                                             Similar Movies
                                             */
                                            MovieGridItem(movie: movie)
                                                .onAppear(){
                                                    // Checks if more similar movies need to be loaded
                                                    self.movieFetcher.loadMoreSimilarMoviesIfNeeded(currentMovie: movie)
                                                }
                                        }
                                    }
                                }
                                .frame(height: 262.5)
                                
                                Spacer().frame(height: 5)
                            }
                            
                            /*
                             Review Button
                             */
                            // Displays ReviewView when tapped on
                            NavigationLink(destination: LazyView { ReviewView(contentId: movieFetcher.movie!.id, contentType: "Movie")}){
                                Text("View Reviews")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black)
                                    .padding(.horizontal)
                            }
                            .frame(height: 30)
                            .background(Color.white)
                            .padding(.top, 5)
                            
                            Spacer().frame(height: 5)
                            
                            /*
                             Disclaimer
                             */
                            Text("*All movie data is provided by the TMDb API.")
                                .font(.system(size: 10))
                                .foregroundColor(Color.white)
                                .padding(.horizontal)
                            
                            Spacer()
                        }
                    }
                }
                .foregroundColor(Color.white)
                // Drag to go back gesture
                .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
                    
                    if(value.startLocation.x < 20 && value.translation.width > 100) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }))
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
            /*
             Loading Icon
             */
            // Check if data is loaded
            if !self.movieFetcher.dataIsLoaded {
                LoadingIcon(isAnimating: true, style: .large, color: UIColor.white)
            }
            
            /*
             Connection Error Message
             */
            // Check if connection error
            if self.movieFetcher.dataIsLoaded && self.movieFetcher.connectionError {
                Text("Error loading movie. Please try again.")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                
            }
            
        }
        
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(movieId: 38700)
            .environmentObject(TrailerPageState())
    }
}
