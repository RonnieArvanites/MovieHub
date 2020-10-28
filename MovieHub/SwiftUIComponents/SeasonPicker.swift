//
//  SeasonPicker.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/14/20.
//

import SwiftUI

// Season Picker Overlay
struct SeasonPicker: View {
    
    @Binding var showSeasonPicker: Bool
    @Binding var blurView: Bool
    @StateObject var currentSeason: SeasonState
    var numberOfSeasons: Int
    
    var body: some View {
        ZStack{
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            /*
             Season Buttons
             */
            GeometryReader { geometry in
                
                ScrollViewReader { scrollProxy in
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack(spacing: 20){
                            
                            // Loop through each season number
                            ForEach(1..<(numberOfSeasons + 1)) { seasonNumber in
                                
                                // Check if seasonNumber is equal to current season
                                if seasonNumber == self.currentSeason.currentSeason {
                                    
                                    Text("Season \(seasonNumber)")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .id(seasonNumber)
                                        .onTapGesture {
                                            // Closes Season Picker
                                            self.showSeasonPicker = false
                                            // Unblur view
                                            self.blurView = false
                                        }
                                } else {
                                    Text("Season \(seasonNumber)")
                                        .font(.system(size: 18))
                                        .id(seasonNumber)
                                        .onTapGesture {
                                            // Saves picked choice as the current season
                                            self.currentSeason.currentSeason = seasonNumber
                                            // Closes Season Picker
                                            self.showSeasonPicker = false
                                            // Unblur view
                                            self.blurView = false
                                        }
                                }
                            }
                        }
                        .foregroundColor(Color.white)
                        .frame(width: UIScreen.main.bounds.width)
                        .frame(minHeight: geometry.size.height)
                        .padding(.bottom, 10)
                        
                    }.onAppear(){
                        // Scrolls to current chosen season
                        scrollProxy.scrollTo(currentSeason.currentSeason, anchor: .center)
                    }
                }
            }
            
            /*
             Close Overlay Button
             */
            Button(action:{
                // Close season picker
                self.showSeasonPicker = false
                // Unblur view
                self.blurView = false
            }){
                Image(systemName: "xmark.circle")
                    .font(.system(size: 25))
                    .foregroundColor(Color.white)
            }
            .position(x: 25, y: 25)
        }
    }
}

struct SeasonPicker_Previews: PreviewProvider {
    static var previews: some View {
        SeasonPicker(showSeasonPicker: .constant(true), blurView: .constant(true), currentSeason: SeasonState(), numberOfSeasons: 2)
            .background(Color.gray)
    }
}
