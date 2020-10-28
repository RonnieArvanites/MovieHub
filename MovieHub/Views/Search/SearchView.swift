//
//  SearchView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/16/20.
//

import SwiftUI
import SDWebImageSwiftUI

// Allows user to search for movies, tv shows, and people
struct SearchView: View {
    
    @State private var search: String = ""
    
    @EnvironmentObject var tabState: TabState
    
    @State private var mediaTypeIndex = 0
    
    @State var showMediaPicker: Bool = false
    
    @StateObject var searchFetcher = SearchFetcher()
    
    @StateObject var autoCompleteFetcher = AutoCompleteFetcher()
    
    @State var didSearch: Bool = false
    
    @State var searchEditMode: Bool = false
    
    // Customizes Picker
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.boldSystemFont(ofSize: 15)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    // Used to set the media type index after the search results are returned
    private func setMediaTypeIndex(){
        // Sets the picker's first index to a media type that has at least one result
        if searchFetcher.movieResults!.totalResults != 0 {
            self.mediaTypeIndex = 0
        } else if searchFetcher.tvShowResults!.totalResults != 0 {
            self.mediaTypeIndex = 1
        } else if searchFetcher.peopleResults!.totalResults != 0 {
            self.mediaTypeIndex = 2
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .top){
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
                 Search Bar
                 */
                HStack{
                    /*
                     Search TextField
                     */
                    CustomTextField(text: self.$search, searchEditMode: self.$searchEditMode, isFirstResponder: ((tabState.currentTabIndex == 2) && !didSearch), keyboardType: .default, fontSize: 18, placeholder: "Search for a movie, tv show, or person", onSearchPressed: {
                        self.didSearch = true
                        // Api search request
                        searchFetcher.search(searchString: self.search, completion: { self.setMediaTypeIndex()})
                    }, onTextChange: {
                        // AutoFill Api request
                        autoCompleteFetcher.getAutoComplete(searchString: self.search)
                    })
                    
                    /*
                     Search Icon
                     */
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.system(size: 25))
                        .foregroundColor(Color.black)
                        .onTapGesture {
                            self.didSearch = true
                            // Api search request
                            searchFetcher.search(searchString: self.search, completion: { self.setMediaTypeIndex() })
                            // Closes keyboard
                            UIApplication.shared.endEditing()
                        }
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
                .frame(width: UIScreen.main.bounds.size.width, height: 35)
                .background(Color.white)
                .cornerRadius(25)
                                
                /*
                 Search Results
                 */
                    // Checks if user requested a search
                    if didSearch {
                        // Checks if the search fetcher has an error
                        if searchFetcher.connectionError {
                            /*
                             Connection Error Message
                             */
                            Text("Error loading results. Please try again.")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .frame(width: 200)
                            
                            Spacer()
                            
                        } else if searchFetcher.dataIsLoaded {
                            /*
                             Search Picker
                             */
                            Picker("", selection: self.$mediaTypeIndex) {
                                
                                Text("Movies(\(searchFetcher.movieResults!.totalResults))")
                                    .tag(0)
                                
                                Text("TV Shows(\(searchFetcher.tvShowResults!.totalResults))")
                                    .tag(1)
                                
                                Text("People(\(searchFetcher.peopleResults!.totalResults))")
                                    .tag(2)
                                
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            
                            /*
                             Search Result Items
                             */
                            // Check media type to filter results
                            if self.mediaTypeIndex == 0 {
                                // If movie media type is selected
                                // Check if movie results is empty
                                if !(self.searchFetcher.movieResults?.results.isEmpty)! {
                                    
                                    ScrollView{
                                        LazyVStack{
                                            ForEach(self.searchFetcher.movieResults!.results) { result in
                                                /*
                                                 Movie Results
                                                 */
                                                MovieSearchResultListItem(result: result)
                                                    .frame(width: UIScreen.main.bounds.size.width, height: 150)
                                                    .onAppear() {
                                                        // Checks if more movies are needed
                                                        self.searchFetcher.loadMoreMoviesIfNeeded(currentMovie: result)
                                                    }
                                            }
                                            
                                            /*
                                             Connection Error Message
                                             */
                                            if self.searchFetcher.loadMoreMovieResultsConnectionError {
                                                Text("Error loading more movies. Please try again.")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 15))
                                                    .fontWeight(.bold)
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: 200)
                                            }
                                        }
                                    }
                                    
                                } else {
                                    /*
                                     No Movies Message
                                     */
                                    Text("No movies match '\(self.searchFetcher.searchString.removingPercentEncoding!)'.")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 200)
                                }
                                
                            } else if self.mediaTypeIndex == 1 {
                                // If tv show media type is selected
                                //Check if tv show results is empty
                                if !(self.searchFetcher.tvShowResults?.results.isEmpty)! {
                                ScrollView{
                                    LazyVStack{
                                        ForEach(self.searchFetcher.tvShowResults!.results) { result in
                                            /*
                                             TV Show Results
                                             */
                                            TVShowSearchResultListItem(result: result)
                                                .frame(width: UIScreen.main.bounds.size.width, height: 150)
                                                .onAppear() {
                                                    // Checks if more tv shows need to be loaded
                                                    self.searchFetcher.loadMoreTVShowsIfNeeded(currentTVShow: result)
                                                }
                                        }
                                        
                                        /*
                                         Connection Error Message
                                         */
                                        if self.searchFetcher.loadMoreTVShowResultsConnectionError {
                                            Text("Error loading more tv shows. Please try again.")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                                .fontWeight(.bold)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 200)
                                        }
                                    }
                                }
                                } else {
                                    /*
                                     No tv shows message
                                     */
                                    Text("No tv shows match '\(self.searchFetcher.searchString.removingPercentEncoding!)'.")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 200)
                                }
                            } else {
                                // If people media type is selected
                                // Check if tv show results is empty
                                if !(self.searchFetcher.peopleResults?.results.isEmpty)! {
                                ScrollView{
                                    LazyVStack{
                                        ForEach(self.searchFetcher.peopleResults!.results) { result in
                                            /*
                                             People Results
                                             */
                                            PeopleSearchResultListItem(result: result)
                                                .frame(width: UIScreen.main.bounds.size.width, height: 150)
                                                .onAppear() {
                                                    // Check if more people need to be loaded
                                                    self.searchFetcher.loadMorePeopleIfNeeded(currentPerson: result)
                                                }
                                        }
                                        
                                        /*
                                         Connection Error Message
                                         */
                                        if self.searchFetcher.loadMorePeopleResultsConnectionError {
                                            Text("Error loading more people. Please try again.")
                                                .foregroundColor(.white)
                                                .font(.system(size: 15))
                                                .fontWeight(.bold)
                                                .multilineTextAlignment(.center)
                                                .frame(width: 200)
                                        }
                                    }
                                }
                                } else {
                                    /*
                                     No people message
                                     */
                                    Text("No people match '\(self.searchFetcher.searchString.removingPercentEncoding!)'.")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 200)
                                }
                                
                            }
                            
                        }
                        else {
                            /*
                             Loading Icon
                             */
                            LoadingIcon(isAnimating: true, style: .large, color: UIColor.white)
                            
                            Spacer()
                        }
                    }
                
                Spacer()
                
            }
            .foregroundColor(Color.white)
            .background(Color.black
                            .edgesIgnoringSafeArea(.all))
            .navigationBarTitle("")
            .navigationBarHidden(true)
                
                /*
                 Cancel Search Button
                 */
                if self.searchEditMode {
                    Text("Cancel")
                        .foregroundColor(.white)
                        .font(.system(size:18))
                        .fontWeight(.bold)
                        .padding(.trailing, 5)
                        .frame(width: UIScreen.main.bounds.size.width, height: Globals.navBarHeight, alignment: .trailing)
                        .onTapGesture {
                            // Sets search edit mode to false
                            self.searchEditMode = false
                            // Closes keyboard
                            UIApplication.shared.endEditing()
                        }
                }
                
                /*
                 AutoFill Results
                 */
                // Check if search text field is being edited
                if self.searchEditMode && self.autoCompleteFetcher.resultsAreLoaded && !self.autoCompleteFetcher.connectionError && self.search != "" {
                    // Check the number of autocomplete results so the scroll view can be dynamically sized
                    if self.autoCompleteFetcher.autoCompleteResults!.results.count < 10 {
                        ScrollView{
                            VStack(alignment: .leading){
                                
                                ForEach(self.autoCompleteFetcher.autoCompleteResults!.results) { result in
                                    /*
                                     Autocomplete items
                                     */
                                    HStack{
                                        Image(systemName: "magnifyingglass.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundColor(Color.black)
                                        
                                        Text(result.name)
                                            .foregroundColor(.black)
                                            .font(.system(size: 18))
                                    }
                                    .padding(.bottom, 5)
                                    .padding(.leading, 5)
                                    .frame(width:  UIScreen.main.bounds.size.width - 25, height: 25, alignment: .leading)
                                    .onTapGesture {
                                        // Sets search to autocomplete item
                                        self.search = result.name
                                        // Sets did search to true
                                        self.didSearch = true
                                        // Api search request
                                        searchFetcher.search(searchString: self.search, completion: { self.setMediaTypeIndex() })
                                        // Closes keyboard
                                        UIApplication.shared.endEditing()
                                    // Remove autofill results from view
                                    self.searchEditMode = false
                                }
                            }
                            
                        }
                        
                    }
                        .frame(height: CGFloat(self.autoCompleteFetcher.autoCompleteResults!.results.count) * 30)
                        .background(Color.white)
                        .offset(y: 75)
                        .padding(.bottom, 75)
                        .simultaneousGesture(DragGesture().onChanged({ _ in
                            // Closes keyboard
                            UIApplication.shared.endEditing()
                            // Keeps autocomplete results up
                            self.searchEditMode = true
                        }))
                    } else {
                        // If autofill results count is more than 10
                        ScrollView(){
                        VStack(alignment: .leading){
                            
                            ForEach(self.autoCompleteFetcher.autoCompleteResults!.results) { result in
                                /*
                                 Autocomplete Result Items
                                 */
                                HStack{
                                    Image(systemName: "magnifyingglass.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.black)
                                    
                                    Text(result.name)
                                        .foregroundColor(.black)
                                        .font(.system(size: 18))
                                }
                                .padding(.bottom, 5)
                                .padding(.leading, 5)
                                .frame(width:  UIScreen.main.bounds.size.width - 25, height: 25, alignment: .leading)
                                .onTapGesture {
                                    // Sets search to autocomplete item
                                    self.search = result.name
                                    // Sets didSearch to true
                                    self.didSearch = true
                                    // Api search request
                                    searchFetcher.search(searchString: self.search, completion: { self.setMediaTypeIndex() })
                                    // Closes keyboard
                                    UIApplication.shared.endEditing()
                                    // Remove autofill results from view
                                    self.searchEditMode = false
                                }
                            }
                        }
                    }
                        .background(Color.white)
                        .offset(y: 75)
                        .padding(.bottom, 75)
                        .simultaneousGesture(DragGesture().onChanged({ _ in
                            // Closes keyboard
                            UIApplication.shared.endEditing()
                            // Keeps autocomplete results up
                            self.searchEditMode = true
                        }))
                    }
                }
        }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(TabState())
    }
}
