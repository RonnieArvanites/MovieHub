//
//  TVShowCategoriesView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/7/20.
//

import SwiftUI

// Displays the tv show categories
struct TVShowCategoriesView: View {
    
    // TV show categories
    var categories = ["Most Popular", "Top Rated", "Trending", "On The Air" ,"Action & Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Kids", "Mystery", "News", "Reality", "Sci-Fi & Fantasy", "Soap", "Talk", "War & Politics", "Western"]
    
    // Grid column formating
    var columns: [GridItem] =
        [GridItem(.adaptive(minimum: 175), spacing: 5)]
    
    var body: some View {
        NavigationView{
            VStack{
                //// NavBar /////
                HStack{
                    Text("MovieHub")
                        .foregroundColor(.white)
                        .font(.system(size:25))
                        .fontWeight(.bold)
                }
                .frame(height: Globals.navBarHeight)
                
                Spacer().frame(height: 0)
                
                /*
                 TV Show categories grid
                 */
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(categories, id: \.self) { category in
                            
                            // Displays TVShowListView when grid item is tapped on
                            NavigationLink(destination: LazyView { TVShowListView(category: category)}){
                                
                                /*
                                 TV Show categories grid item
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

struct TVShowCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowCategoriesView()
    }
}
