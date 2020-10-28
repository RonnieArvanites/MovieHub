//
//  GenreListView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/2/20.
//

import SwiftUI

struct CategoryListView: View {
    
    var genre: String
    //Used for swap back gesture
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
//    @StateObject var movieListFetcher: MovieListFetcher
    @ObservedObject var movieListFetcher: MovieListFetcher
    
    var columns: [GridItem] =
        [GridItem(.adaptive(minimum: 175), spacing: 5)]
    
    init(genre: String) {
        self.genre = genre
        switch genre {
        case "Action":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 28))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 28))

        case "Adventure":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 12))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 12))

        case "Animation":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 16))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 16))
            
        case "Comedy":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 35))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 35))
            
        case "Crime":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 80))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 80))
            
        case "Documentary":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 99))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 99))
            
        case "Drama":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 18))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 18))
            
        case "Family":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 10751))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 10751))
            
        case "Fantasy":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 14))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 14))
            
        case "History":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 36))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 36))
            
        case "Horror":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 27))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 27))
            
        case "Music":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 10402))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 10402))
            
        case "Mystery":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 9648))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 9648))
            
        case "Romance":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 10749))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 10749))
            
        case "Science Fiction":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 878))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 878))
        
        case "TV Movie":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 10770))
            
        case "Thriller":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 53))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 53))
            
        case "War":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 10752))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 10752))
            
        case "Western":
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 37))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 37))

        default:
//            _movieListFetcher = StateObject(wrappedValue: MovieListFetcher(genreId: 28))
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(genreId: 28))
        }
    }
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
        VStack{
                //NavBar
                DefaultNavBar(title: genre)
                
                Spacer().frame(height:0)
                
                ScrollView(showsIndicators: false){
                    if self.movieListFetcher.dataIsLoaded && !self.movieListFetcher.connectionError {
                            
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(movieListFetcher.movieList!.movies, id: \.self.id) { movie in
                                MovieGridItem(movie: movie)
                                    .onAppear(){
                                        self.movieListFetcher.loadMoreMoviesIfNeeded(currentMovie: movie)
                                    }
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in

                    if(value.startLocation.x < 20 && value.translation.width > 100) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }))
                

        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
            
            /// Loading Icon ///
            if !self.movieListFetcher.dataIsLoaded {
                LoadingIcon(isAnimating: true, style: .large, color: UIColor.white)
            }
            
            //Connection Error Message ///
            if self.movieListFetcher.dataIsLoaded && self.movieListFetcher.connectionError {
                Text("Error loading movies. Please try again.")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                    
            }
            
        }
    }
}

struct GenreView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryListView(genre: "Action")
    }
}
