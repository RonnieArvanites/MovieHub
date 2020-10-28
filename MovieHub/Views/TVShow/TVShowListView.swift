//
//  TVShowListView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/13/20.
//

import SwiftUI

// Displays tv show list
struct TVShowListView: View {
    
    var category: String
    
    // Used for swap back gesture
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @ObservedObject var tvShowListFetcher: TVShowListFetcher
    
    // Grid column formating
    var columns: [GridItem] =
        [GridItem(.adaptive(minimum: 175), spacing: 5)]
    
    init(category: String) {
        // Sets category
        self.category = category
        
        // Initializes the TVShowListFetcher with the corresponding categoryId
        switch category {
        
        case "Most Popular":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 0))
            
        case "Top Rated":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 1))
            
        case "On The Air":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 2))
            
        case "Trending":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 3))
            
        case "Action & Adventure":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 10759))
            
        case "Animation":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 16))
            
        case "Comedy":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 35))
            
        case "Crime":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 80))
            
        case "Documentary":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 99))
            
        case "Drama":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 18))
            
        case "Family":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 10751))
            
        case "Kids":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 10762))
            
        case "Mystery":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 9648))
            
        case "News":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 10763))
            
        case "Reality":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 10764))
            
        case "Sci-Fi & Fantasy":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 10765))
            
        case "Soap":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 10766))
            
        case "Talk":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 10767))
            
        case "War & Politics":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 10768))
            
        case "Western":
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 37))
            
        default:
            _tvShowListFetcher = ObservedObject(wrappedValue: TVShowListFetcher(categoryId: 10759))
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
                 TV Show List
                 */
                ScrollView(showsIndicators: false){
                    if self.tvShowListFetcher.dataIsLoaded && !self.tvShowListFetcher.connectionError {
                        
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(tvShowListFetcher.tvShowList!.tvShows, id: \.self.id){ tvShow in
                                
                                /*
                                 TV Show Grid Item
                                 */
                                TVShowGridItem(tvShow: tvShow)
                                    .onAppear(){
                                        // Checks if more tv shows need to be loaded
                                        self.tvShowListFetcher.loadMoreTVShowsIfNeeded(currentTVShow: tvShow)
                                    }
                            }
                        }
                        
                        /*
                         Connection Error Message
                         */
                        if self.tvShowListFetcher.loadMoreConnectionError {
                            
                            Text("Error loading more tv shows. Please try again.")
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
            if !self.tvShowListFetcher.dataIsLoaded {
                LoadingIcon(isAnimating: true, style: .large, color: UIColor.white)
            }
            
            //Connection Error Message ///
            if self.tvShowListFetcher.dataIsLoaded && self.tvShowListFetcher.connectionError {
                Text("Error loading tv shows. Please try again.")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
            }
        }
    }
}

struct TVShowCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowListView(category: "Animation")
    }
}
