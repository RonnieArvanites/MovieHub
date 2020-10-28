//
//  SeasonView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/14/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Displays season data
struct SeasonView: View {
    
    // Used for swap back gesture
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var trailerTabState: TrailerPageState
    
    var tvShow: TVShow
    var seasonError: Bool
    
    @State var blurView: Bool = false

    @State var showSeasonPicker: Bool = false
    
    @StateObject var currentSeason = SeasonState()
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment:.leading){
                /*
                 NavBar
                 */
                DefaultNavBar(title: "Seasons")
                
                Spacer().frame(height:0)
                
                // Check if season error
                if !seasonError {
                    /*
                     Season Menu
                     */
                HStack{
                    Text("Season \(self.currentSeason.currentSeason)")
                        .font(.system(size: 15))
                        .fontWeight(.bold)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 13))
                    
                }
                .padding(.all, 5)
                .border(Color.white, width: 1)
                .foregroundColor(Color.white)
                .onTapGesture {
                    self.showSeasonPicker = true
                    self.blurView = true
                }
                
                ScrollViewReader { scrollProxy in
                ScrollView(showsIndicators: false){
                    
                    /*
                     Season Name
                     */
                    Text(verbatim: tvShow.seasons![currentSeason.currentSeason-1].name)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .id(0)
                    
                    /*
                     Season Overview
                     */
                    //Check if overview is empty
                    if tvShow.seasons![currentSeason.currentSeason-1].overview != nil {
                        Text("Overview")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        
                        Text(verbatim: tvShow.seasons![currentSeason.currentSeason-1].overview!)
                            .font(.system(size: 15))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    
                    /*
                     Season Traiers
                     */
                    // Check if season has trailers
                    if !tvShow.seasons![currentSeason.currentSeason-1].trailers!.trailers.isEmpty {
                        Text("Trailers")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                        
                        Spacer().frame(height: 0)
                        
                        // Check if season has vimeo trailers
                        if tvShow.seasons![currentSeason.currentSeason-1].vimeoTrailers != nil {

                            TabView(selection: self.$trailerTabState.currentPageIndex){
                                // Check if season has youtube trailers
                                if tvShow.seasons![currentSeason.currentSeason-1].youtubeTrailers != nil {
                                    // Displays youtube trailers
                                    ForEach((tvShow.seasons![currentSeason.currentSeason-1].youtubeTrailers)!, id: \.self){ trailer in
                                        TrailerListItem(youtubeTrailer: trailer)
                                    }
                                }

                                // Check if season has vimeo trailers
                                if tvShow.seasons![currentSeason.currentSeason-1].vimeoTrailers != nil {
                                    // Displays vimeo trailers
                                    ForEach((tvShow.seasons![currentSeason.currentSeason-1].vimeoTrailers)!, id: \.self){ trailer in
                                        TrailerListItem(vimeoTrailer: trailer)
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width, height: (0.56 * UIScreen.main.bounds.width))
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                            .id(tvShow.seasons![currentSeason.currentSeason-1].vimeoTrailers)

                        } else {
                            TabView(selection: self.$trailerTabState.currentPageIndex){
                                // Check if season has youtube trailers
                                if tvShow.seasons![currentSeason.currentSeason-1].youtubeTrailers != nil {
                                    // Displays youtube trailers
                                    ForEach((tvShow.seasons![currentSeason.currentSeason-1].youtubeTrailers)!, id: \.self){ trailer in
                                        TrailerListItem(youtubeTrailer: trailer)
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width, height: (0.56 * UIScreen.main.bounds.width))
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
                            .id(tvShow.seasons![currentSeason.currentSeason-1].youtubeTrailers)
                        }
                    }
                    
                    /*
                     Episodes
                     */
                    Text("Episodes")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                    
                    ForEach(self.tvShow.seasons![currentSeason.currentSeason-1].episodes){ episode in
                        /*
                         Episode List Item
                         */
                        EpisodeListItem(episode: episode)
                    }
                    // Listens for when the current season changes
                    .onReceive(self.currentSeason.$currentSeason) { action in
                        // Scrolls to top of view
                        scrollProxy.scrollTo(0, anchor: .top)
                    }
                    
                }
                // Drag to go back gesture
                .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in

                    if(value.startLocation.x < 20 && value.translation.width > 100) {
                        // Closes view
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }))
                }
                
                } else {
                    /*
                     Connection Error Message
                     */
                    VStack{
                    Text("Error loading seasons. Please try again.")
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .frame(width: 200, alignment: .center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .blur(radius: self.blurView ? 20:0)
            .disabled(self.blurView)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
            /*
             Season Picker
             */
            if self.showSeasonPicker {
                SeasonPicker(showSeasonPicker: self.$showSeasonPicker, blurView: self.$blurView, currentSeason: self.currentSeason, numberOfSeasons: self.tvShow.numberOfSeasons)
            }
        }.foregroundColor(Color.white)
    }
}

struct SeasonView_Previews: PreviewProvider {
    static var previews: some View {
        
        SeasonView(tvShow: TVShow(id: 76479, name: "The Boys", posterURL: "/mY7SeH4HFFxW1hiI6cWuwCRKptN.jpg", backdropURL: "/mGVrXeIjyecj6TKmwPVpHlscEmw.jpg", genres: [Genre(id: 10765, name: "Sci-Fi & Fantasy"), Genre(id: 10759, name: "Action & Adventure")], overview: "A group of vigilantes known informally as “The Boys” set out to take down corrupt superheroes with no more than blue-collar grit and a willingness to fight dirty.", firstAirDate: DateFormatter().date(from: "2019-07-25"), lastAirDate: DateFormatter().date(from: "2020-10-09"), episodeRuntime: [60], score: 7.4, voteCount: 200, rating: "PG-13", filmStudios: [FilmStudio(id: 20580, logoURL: "/tkFE81jJIqiFYPP8Tho57MXRQEx.png", name: "Amazon Studios"), FilmStudio(id: 333, logoURL: "/5xUJfzPZ8jWJUDzYtIeuPO4qPIa.png", name: "Original Film"), FilmStudio(id: 11073, logoURL: "/wHs44fktdoj6c378ZbSWfzKsM2Z.png", name: "Sony Pictures Television")], trailers: TrailerList(trailers: [Trailer(name: "The Boys - NYCC Teaser: Vought is Here For You | Prime Video", site: "YouTube", key: "FG1EByNnHUU", type: "Teaser"), Trailer(name: "The Boys – Official Teaser | Prime Video", site: "YouTube", key: "NilteC-7jeM", type: "Teaser")]), similarTVShows: nil, inProduction: true, numberOfSeasons: 2, numberOfEpisodes: 16, creators: [TVShow.Creator(id: 58321, name: "Eric Kripke")], networks: [TVShow.Network(id: 1024, name: "Amazon", logoURL: "/ifhbNuuVnlwYy5oXA5VIb2YR8AZ.png")], type: "Scripted", cast: [CastMember(id: 1030513, character: "Hughie Campbell", name: "Jack Quaid", profilePictureURL: "/c06rdofVnM7rIv7ATsrxfLGz5yo.jpg"), CastMember(id: 1372, character: "Billy Butcher", name: "Karl Urban", profilePictureURL: "/bsAnEFgVm5kn8DbBZKfnlLNll89.jpg")], seasons: [Season(id: 98085, name: "Season 1", overview: "", seasonNumber: 1, episodes: [Episode(id: 1705013, episodeNumber: 1, name: "The Name of the Game", airDate: DateFormatter().date(from: "2019-07-25"), overview: "When a Supe kills the love of his life, A/V salesman Hughie Campbell teams up with Billy Butcher, a vigilante hell-bent on punishing corrupt Supes — and Hughie’s life will never be the same again.", thumbnailURL: "/83vFYTHtCqWwaDtZluSU8bmnFYG.jpg", score: 8.4, voteCount: 3029)], posterURL: "/g3HjUeFCwKOfBxlM97lv016mnol.jpg", castAndCrew: CastAndCrew(cast: [CastMember(id: 1030513, character: "Hughie Campbell", name: "Jack Quaid", profilePictureURL: "/c06rdofVnM7rIv7ATsrxfLGz5yo.jpg"), CastMember(id: 1372, character: "Billy Butcher", name: "Karl Urban", profilePictureURL: "/bsAnEFgVm5kn8DbBZKfnlLNll89.jpg")], crew: [CrewMember(id: 1234, name: "Mike", job: "Production", profilePictureURL: nil)]), trailers: nil, vimeoTrailers: nil, youtubeTrailers: nil)]), seasonError: false)
            .environmentObject(TrailerPageState())
    }
}
