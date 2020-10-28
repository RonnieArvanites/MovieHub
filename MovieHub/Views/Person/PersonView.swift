//
//  PersonView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import SwiftUI
import SDWebImageSwiftUI

struct PersonView: View {
    
    @ObservedObject var personFetcher: PersonFetcher
    
    // Used for swap back gesture
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var personId: Int
    
    init(personId: Int) {
        self.personId = personId
        // Initializes PersonFetcher with the person id
        _personFetcher = ObservedObject(wrappedValue: PersonFetcher(personId: personId))
    }
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack{
                /*
                 NavBar
                 */
                NavBarWithShareButton(shareLink: "https://www.themoviedb.org/person/\(self.personId)")
                
                Spacer().frame(height:0)
                
                ScrollView(showsIndicators: false){
                    // Check if data is loaded from api
                    if personFetcher.dataIsLoaded && !personFetcher.connectionError {
                        
                        VStack{
                            /*
                             Profile Picture
                             */
                            // Check if actor has picture
                            if personFetcher.person?.profileImageUrl != nil {
                                WebImage(url: URL(string: "\(Globals.imageBaseURL)original\(personFetcher.person!.profileImageUrl!)"))
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
                            
                            Spacer().frame(height: 5)
                            
                            VStack{
                                /*
                                 Name
                                 */
                                Text(personFetcher.person!.name)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.center)
                                
                                Spacer().frame(height: 5)
                                
                                /*
                                 Birthday
                                 */
                                // Check if birthday is nil
                                if personFetcher.person?.birthday != nil {
                                    HStack(alignment: .top){
                                        Text("Born:")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                            .frame(width: 85, alignment: .topLeading)
                                        Text(personFetcher.person!.birthday!.toMDYString())
                                            .font(.system(size: 15))
                                        // Check if still alive
                                        if personFetcher.person?.deathday == nil {
                                            Text("(\(personFetcher.person!.birthday!.getAge()) years old)")
                                                .font(.system(size: 15))
                                        }
                                        Spacer()
                                    }
                                    
                                    Spacer().frame(height: 5)
                                }
                                
                                /*
                                 Deathday
                                 */
                                // Check if deathday is nil
                                if personFetcher.person?.deathday != nil {
                                    HStack(alignment: .top){
                                        Text("Died:")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                            .frame(width: 85, alignment: .topLeading)
                                        Text(personFetcher.person!.deathday!.toMDYString())
                                            .font(.system(size: 15))
                                        Text("(\(personFetcher.person!.deathday!.getDeathAge(birthday: personFetcher.person!.birthday!)) years old)")
                                            .font(.system(size: 15))
                                        Spacer()
                                    }
                                    
                                    Spacer().frame(height: 5)
                                }
                                
                                /*
                                 Birthplace
                                 */
                                // Check if birthplace is nil
                                if personFetcher.person?.birthPlace != nil {
                                    HStack(alignment: .top){
                                        Text("Birth Place:")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                            .frame(width: 85, alignment: .topLeading)
                                        Text(personFetcher.person!.birthPlace!)
                                            .font(.system(size: 15))
                                        Spacer()
                                    }
                                    
                                    Spacer().frame(height: 5)
                                }
                                
                                /*
                                 Gender
                                 */
                                // Checks if gender is nil
                                if personFetcher.person?.gender != nil {
                                    HStack(alignment: .top){
                                        Text("Gender:")
                                            .font(.system(size: 15))
                                            .fontWeight(.bold)
                                            .frame(width: 85, alignment: .topLeading)
                                        if personFetcher.person?.gender == 1 {
                                            Text("Female")
                                                .font(.system(size: 15))
                                        } else if personFetcher.person?.gender == 0 {
                                            Text("Male")
                                                .font(.system(size: 15))
                                        }
                                        Spacer()
                                    }
                                    
                                    Spacer().frame(height: 5)
                                }
                                
                                /*
                                 Biography
                                 */
                                Text("Biography")
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    VStack{
                                        // Check if biography is empty
                                        if !personFetcher.person!.biography!.isEmpty {
                                            Text(personFetcher.person!.biography!)
                                                .font(.system(size: 15))
                                        } else {
                                            Text("This actor does not have a biography.")
                                                .font(.system(size: 15))
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width, alignment: .leading)
                                    
                                    Spacer().frame(height: 5)
                                    
                                
                                VStack{
                                    
                                    /*
                                     Known For
                                     */
                                    // Check if known for is empty
                                    if personFetcher.person!.knownFor != nil && !(personFetcher.person!.knownFor?.isEmpty)! {
                                        Text("Known For")
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)

                                        ScrollView(.horizontal, showsIndicators: false){
                                            LazyHStack(spacing: 10) {
                                                ForEach((personFetcher.person?.knownFor)!) { knownFor in
                                                    // Known For List Items
                                                    KnownForListItem(knownFor: knownFor)
                                                }
                                            }
                                        }
                                    }
                                    
                                    /*
                                     Movies
                                     */
                                // Check if movie role list is empty
                                    if personFetcher.person!.movieRoleList != nil && !(personFetcher.person!.movieRoleList?.cast.isEmpty)! {
                                    
                                    Text("Movies")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                    
                                    ScrollView(.horizontal, showsIndicators: false){
                                        LazyHStack(spacing: 10) {
                                            ForEach((personFetcher.person?.movieRoleList?.cast)!) { movieRole in
                                                /*
                                                 Movie Role List Items
                                                 */
                                                MovieRoleListItem(movieRole: movieRole)
                                                
                                            }
                                        }
                                    }
                                }
                                
                                    /*
                                     TV Shows
                                     */
                                // Check if tv show list is empty
                                    if personFetcher.person!.tvRoleList != nil && !(personFetcher.person!.tvRoleList?.cast.isEmpty)! {
                                    
                                    Text("TV Shows")
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)

                                    ScrollView(.horizontal, showsIndicators: false){
                                        LazyHStack(spacing: 10) {
                                            ForEach((personFetcher.person?.tvRoleList?.cast)!) { tvRole in
                                                /*
                                                 TV Show List Item
                                                 */
                                                TVRoleListItem(tvRole: tvRole)
                                            }
                                        }
                                    }
                                }
                                    
                                    Spacer().frame(height: 5)
                                    
                                    /*
                                     Disclaimer
                                     */
                                    Text("*All person data is provided by the TMDb API.")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color.white)
                                        .padding(.horizontal)
                                    
                                }
                                
                            }
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
            // Check is data is loaded
            if !self.personFetcher.dataIsLoaded {
                LoadingIcon(isAnimating: true, style: .large, color: UIColor.white)
            }
            
            /*
             Connection Error Message
             */
            // Check if connection error
            if self.personFetcher.dataIsLoaded && self.personFetcher.connectionError {
                Text("Error loading actor. Please try again.")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
                    
            }
        }
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(personId: 29384)
    }
}
