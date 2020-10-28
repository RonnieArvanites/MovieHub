//
//  TVShowView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/13/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays TV show data
struct TVShowView: View {
    
    @ObservedObject var tvShowFetcher: TVShowFetcher
    
    // Used for swap back gesture
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var trailerTabState: TrailerPageState
    
    // Grid column formating
    var columns: [GridItem] =
        [GridItem(.adaptive(minimum: 60), spacing: 5)]
    
    var tvShowId: Int
    
    init(tvShowId: Int) {
        self.tvShowId = tvShowId
        // Initializes TVShowFetcher with the tv show id
        _tvShowFetcher = ObservedObject(wrappedValue: TVShowFetcher(tvShowId: tvShowId))
    }
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack{
                /*
                 NavBar
                 */
                NavBarWithShareButton(shareLink: "https://www.themoviedb.org/tv/\(self.tvShowId)")
                
                Spacer().frame(height:0)
                
                ScrollView(showsIndicators: false){
                    // Checks if data is loaded from api call
                    if tvShowFetcher.dataIsLoaded && !tvShowFetcher.connectionError {
                        ZStack{
                            /*
                             Backdrop Image
                             */
                            // Checks if backdrop image is available
                            if tvShowFetcher.tvShow?.backdropURL != nil {
                                WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(tvShowFetcher.tvShow!.backdropURL!)")
                                )
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 187.5)
                                .clipped()
                                .opacity(0.4)
                            }
                            HStack{
                                VStack{
                                    /*
                                     TV Show Poster
                                     */
                                    //Check if tv show poster is available
                                    if tvShowFetcher.tvShow?.posterURL != nil {
                                        WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(tvShowFetcher.tvShow!.posterURL!)"))
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
                                     TV Show Name
                                     */
                                    Text(tvShowFetcher.tvShow!.name)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.center)
                                    
                                    
                                    /*
                                     Number of seasons
                                     */
                                    // Displays SeasonView when number of seasons is tapped on
                                    NavigationLink(destination: LazyView { SeasonView(tvShow: tvShowFetcher.tvShow!, seasonError: tvShowFetcher.seasonConnectionError)}){
                                        Text(tvShowFetcher.tvShow!.numberOfSeasons > 1 ? "\(tvShowFetcher.tvShow!.numberOfSeasons) seasons" : "\(tvShowFetcher.tvShow!.numberOfSeasons) season")
                                            .font(.system(size: 15))
                                        
                                    }
                                    
                                    HStack{
                                        /*
                                         TV Show Rating
                                         */
                                        Text(tvShowFetcher.tvShow!.rating)
                                            .font(.system(size: 15))
                                            .padding(.all, 5)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.white, lineWidth: 1)
                                            )
                                        
                                        /*
                                         TV Show Score
                                         */
                                        //Check if score is available for the tv show
                                        if tvShowFetcher.tvShow!.voteCount != 0 {
                                            ScoreIcon(score: (tvShowFetcher.tvShow!.score / 10) * 100)
                                        }
                                    }
                                    
                                    Spacer().frame(height: 5)
                                    
                                    /*
                                     TV Show Runtime
                                     */
                                    //Check if runtime list is empty
                                    if !tvShowFetcher.tvShow!.episodeRuntime!.isEmpty && tvShowFetcher.tvShow!.episodeRuntime != nil {
                                        // Displays the smallest time in runtime list
                                        Text("\((tvShowFetcher.tvShow!.episodeRuntime?.min())!)m")
                                            .font(.system(size: 15))
                                        
                                        Spacer().frame(height: 5)
                                    }
                                    
                                    /*
                                     TV Show Genres
                                     */
                                    Text(tvShowFetcher.tvShow!.genreList())
                                        .minimumScaleFactor(0.5)
                                        .font(.system(size: 15))
                                        .multilineTextAlignment(.center)
                                }
                                .frame(width: 200, height: 187.5)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        /*
                         TV Show Overview
                         */
                        if !tvShowFetcher.tvShow!.overview.isEmpty {
                            VStack{
                                Text("Overview")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                
                                Text(tvShowFetcher.tvShow!.overview)
                                    .font(.system(size: 15))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                        }
                        
                        Spacer().frame(height: 5)
                        
                        /*
                         TV Show Stats
                         */
                        VStack{
                            /*
                             TV Show Creators
                             */
                            // Checks if creators string is empty
                            if !tvShowFetcher.tvShow!.creatorsString().isEmpty {
                                HStack(alignment: .top){
                                    Text(tvShowFetcher.tvShow!.creators!.count > 1 ? "Creators:" : "Creator:")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .topLeading)
                                    Text(tvShowFetcher.tvShow!.creatorsString())
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                            
                            /*
                             TV Show Status
                             */
                            HStack(alignment: .top){
                                Text("Status:")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .frame(width: 100, alignment: .topLeading)
                                
                                Text(tvShowFetcher.tvShow!.inProduction ? "Returning":"Ended")
                                    .font(.system(size: 15))
                                
                                Spacer()
                            }
                            
                            /*
                             TV Show Type
                             */
                            HStack(alignment: .top){
                                Text("Type:")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .frame(width: 100, alignment: .topLeading)
                                
                                Text(tvShowFetcher.tvShow!.type)
                                    .font(.system(size: 15))
                                
                                Spacer()
                            }
                            
                            
                            /*
                             TV Show First Episode Aired
                             */
                            // Check if firstAirDate is not nil
                            if tvShowFetcher.tvShow!.firstAirDate != nil {
                                HStack(alignment: .top){
                                    Text("First Aired:")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .topLeading)
                                    Text((tvShowFetcher.tvShow!.firstAirDate?.toMDYString())!)
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                            
                            /*
                             TV Show Last Episode Aired
                             */
                            // Check if lastAirDate is not nil
                            if tvShowFetcher.tvShow!.lastAirDate != nil {
                                HStack(alignment: .top){
                                    Text("Last Aired:")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .topLeading)
                                    Text((tvShowFetcher.tvShow!.lastAirDate?.toMDYString())!)
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                            
                            /*
                             TV Show Last Episode Count
                             */
                            HStack(alignment: .top){
                                Text("Episodes:")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .frame(width: 100, alignment: .topLeading)
                                Text("\(tvShowFetcher.tvShow!.numberOfEpisodes)")
                                Spacer()
                            }
                            
                            /*
                             TV Show Film Studios
                             */
                            // Checks if movie has film studios
                            if !tvShowFetcher.tvShow!.filmStudios!.isEmpty {
                                HStack(alignment: .top){
                                    Text(tvShowFetcher.tvShow!.filmStudios!.count > 1 ? "Film Studios:" : "Film Studio:")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .topLeading)
                                    Text("\(tvShowFetcher.tvShow!.filmStudiostoString())")
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                            
                            /*
                             TV Show Network
                             */
                            //Check if networks are available
                            if !tvShowFetcher.tvShow!.networks.isEmpty {
                                HStack(alignment: .top){
                                    Text(tvShowFetcher.tvShow!.networks.count > 1 ? "Networks:" : "Network:")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                        .frame(width: 100, alignment: .topLeading)
                                    ForEach(tvShowFetcher.tvShow!.networks){ network in
                                        VStack{
                                            /*
                                             Network Image
                                             */
                                            // Checks if network has logo image
                                            if network.logoURL != nil {
                                                ZStack{
                                                    Color.white
                                                        .frame(width: 50, height: 50)
                                                    
                                                    WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(network.logoURL!)"))
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 40, height: 40, alignment: .center)
                                                        .clipped()
                                                    
                                                }
                                            } else {
                                                Image("NoImage")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 20, height: 20, alignment: .center)
                                                    .clipped()
                                            }
                                            
                                            /*
                                             Network Name
                                             */
                                            Text(network.name)
                                                .font(.system(size: 15))
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                        
                        Spacer().frame(height: 5)
                        
                        /*
                         TV Show Cast
                         */
                        // Check if cast info is not nil
                        if tvShowFetcher.tvShow?.cast != nil {
                            Text("Cast")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            
                            Spacer().frame(height: 5)
                            
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(spacing: 10) {
                                    ForEach(tvShowFetcher.tvShow!.cast!) { castMember in
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
                             TV Show Trailers
                             */
                            // Check if tv show has trailers
                            if !(tvShowFetcher.tvShow!.trailers?.trailers.isEmpty)! {
                                VStack{
                                    Text("Trailers")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                    
                                    Spacer().frame(height: 0)
                                    
                                    // Check if tv show has vimeo trailers
                                    if tvShowFetcher.tvShow!.vimeoTrailers != nil {
                                        
                                        TabView(selection: self.$trailerTabState.currentPageIndex){
                                            // Check if youtube trailers are available
                                            if tvShowFetcher.tvShow!.youtubeTrailers != nil {
                                                // Displays youtube trailers
                                                ForEach((tvShowFetcher.tvShow!.youtubeTrailers)!, id: \.self){ trailer in
                                                    TrailerListItem(youtubeTrailer: trailer)
                                                }
                                            }
                                            // Check if vimeo trailers are available
                                            if tvShowFetcher.tvShow!.vimeoTrailers != nil {
                                                // Displays vimeo trailers
                                                ForEach((tvShowFetcher.tvShow!.vimeoTrailers)!, id: \.self){ trailer in
                                                    TrailerListItem(vimeoTrailer: trailer)
                                                }
                                            }
                                        }
                                        .frame(width: UIScreen.main.bounds.width, height: (0.56 * UIScreen.main.bounds.width))
                                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                                    } else {
                                        TabView(selection: self.$trailerTabState.currentPageIndex){
                                            // Check if youtube trailers are available
                                            if tvShowFetcher.tvShow!.youtubeTrailers != nil {
                                                // Displays youtube trailers
                                                ForEach((tvShowFetcher.tvShow!.youtubeTrailers)!, id: \.self){ trailer in
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
                             Similar TV Shows
                             */
                            // Check if tv show has similar tv shows
                            if !(tvShowFetcher.tvShow!.similarTVShows?.tvShows.isEmpty)! {
                                Text("Similar TV Shows")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                
                                Spacer().frame(height: 5)
                                
                                ScrollView(.horizontal, showsIndicators: false){
                                    LazyHStack(spacing: 10) {
                                        ForEach((tvShowFetcher.tvShow!.similarTVShows!.tvShows)) { tvShow in
                                            /*
                                             Similar TV Show
                                             */
                                            TVShowGridItem(tvShow: tvShow)
                                                .onAppear(){
                                                    // Checks if more similar tv shows need to be loaded
                                                    self.tvShowFetcher.loadMoreSimilarTVShowIfNeeded(currentTVShow: tvShow)
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
                            NavigationLink(destination: LazyView { ReviewView(contentId: tvShowFetcher.tvShow!.id, contentType: "TV Show")}){
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
                            Text("*All tv show data is provided by the TMDb API.")
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
                        // Closes view
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
            if !self.tvShowFetcher.dataIsLoaded {
                LoadingIcon(isAnimating: true, style: .large, color: UIColor.white)
            }
            
            /*
             Connection Error Message
             */
            // Check if connection error
            if self.tvShowFetcher.dataIsLoaded && self.tvShowFetcher.connectionError {
                Text("Error loading tv show. Please try again.")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                
            }
        }
    }
}

struct TVShowView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowView(tvShowId: 1402)
            .environmentObject(TrailerPageState())
    }
}
