//
//  MovieListView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/2/20.
//

import SwiftUI

// Displays movie list
struct MovieListView: View {
    
    var category: String
    
    // Used for swap back gesture
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var movieListFetcher: MovieListFetcher
    
    // Grid column formating
    var columns: [GridItem] =
        [GridItem(.adaptive(minimum: 175), spacing: 5)]
    
    init(category: String) {
        // Sets category
        self.category = category
        
        // Initializes the MovieListFetcher with the corresponding categoryId
        switch category {
        
        case "Most Popular":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 0))
            
        case "Top Rated":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 1))
            
        case "Upcoming":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 2))
            
        case "Trending":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 3))
            
        case "Now Playing":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 4))
            
        case "Action":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 28))
            
        case "Adventure":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 12))
            
        case "Animation":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 16))
            
        case "Comedy":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 35))
            
        case "Crime":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 80))
            
        case "Documentary":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 99))
            
        case "Drama":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 18))
            
        case "Family":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 10751))
            
        case "Fantasy":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 14))
            
        case "History":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 36))
            
        case "Horror":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 27))
            
        case "Music":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 10402))
            
        case "Mystery":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 9648))
            
        case "Romance":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 10749))
            
        case "Science Fiction":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 878))
            
        case "TV Movie":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 10770))
            
        case "Thriller":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 53))
            
        case "War":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 10752))
            
        case "Western":
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 37))
            
        default:
            _movieListFetcher = ObservedObject(wrappedValue: MovieListFetcher(categoryId: 28))
        }
    }
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack{
                /*
                 Nav Bar
                 */
                DefaultNavBar(title: category)
                
                Spacer().frame(height:0)
                
                /*
                 Movie List
                 */
                ScrollView(showsIndicators: false){
                    if self.movieListFetcher.dataIsLoaded && !self.movieListFetcher.connectionError {
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(movieListFetcher.movieList!.movies, id: \.self.id) { movie in
                                /*
                                 Movie Grid Item
                                 */
                                MovieGridItem(movie: movie)
                                    .onAppear(){
                                        // Checks if more movies need to be loaded
                                        self.movieListFetcher.loadMoreMoviesIfNeeded(currentMovie: movie)
                                    }
                            }
                        }
                    
                        /*
                         Connection Error Message
                         */
                        if self.movieListFetcher.loadMoreConnectionError {
                            Text("Error loading more movies. Please try again.")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .frame(width: 200)
                            
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                // Drag to go back gesture
                .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in
                    
                    if(value.startLocation.x < 20 && value.translation.width > 100) {
                        // Closes view
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
            if self.movieListFetcher.dataIsLoaded && self.movieListFetcher.connectionError && !self.movieListFetcher.loadMoreConnectionError {
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
        MovieListView(category: "Action")
    }
}
