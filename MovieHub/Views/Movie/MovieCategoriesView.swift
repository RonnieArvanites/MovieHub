//
//  MovieCategoriesView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/7/20.
//

import SwiftUI

// Displays the movie categories
struct MovieCategoriesView: View {
    
    // Movie categories
    var categories = ["Most Popular", "Top Rated", "Upcoming", "Trending", "Now Playing","Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western"]
    
    // Grid column formating
    var columns: [GridItem] =
        [GridItem(.adaptive(minimum: 175), spacing: 5)]
    
    var body: some View {
        NavigationView{
            VStack{
                /*
                 NavBar
                 */
                HStack{
                    Text("MovieHub")
                        .foregroundColor(.white)
                        .font(.system(size:25))
                        .fontWeight(.bold)
                }
                .frame(height: Globals.navBarHeight)
                
                Spacer().frame(height: 0)
                
                /*
                 Movie categories grid
                 */
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        
                        ForEach(categories, id: \.self) { category in
                            
                            // Displays MovieListView when grid item is tapped on
                            NavigationLink(destination: LazyView { MovieListView(category: category)}){
                                
                                /*
                                 Movie categories grid item
                                 */
                                Text(category)
                                    .font(.system(size:20))
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)
                                    .frame(width: 175, height: 87.5)
                                    .background(
                                        Image("\(category.replacingOccurrences(of: " ", with: ""))") //removes whitespaces so the name can be matched to the corrent image name
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 175, height: 87.5)
                                            .clipped(antialiased: true)
                                    )
                            }
                        }
                    }
                }
            }
            .background(Color.black
                            .edgesIgnoringSafeArea(.all))
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
        }
    }
}

struct MovieCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        MovieCategoriesView()
    }
}