//
//  ReviewView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import SwiftUI

struct ReviewView: View {
    
    @ObservedObject var reviewFetcher: ReviewFetcher
    
    //Used for swap back gesture
    @GestureState private var dragOffset = CGSize.zero
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(contentId: Int, contentType: String){
        //Check if content type is movie or tv show
        if contentType == "Movie" {
            //Fetch movie reviews
            _reviewFetcher = ObservedObject(wrappedValue: ReviewFetcher(contentId: contentId, contentType: "Movie"))
        } else {
            //Fetch tv show reviews
            _reviewFetcher = ObservedObject(wrappedValue: ReviewFetcher(contentId: contentId, contentType: "TV Show"))
        }

    }
    
    var body: some View {
        ZStack{
            Color.black
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                //NavBar
                DefaultNavBar(title: "Reviews")
                
                Spacer().frame(height:0)
                
                ScrollView(showsIndicators: false){
                    
                    //Make sure the border is not covered by the NavBar
                    Spacer().frame(height: 2)
                    
                    //Check if reviews are loaded from api call
                    if reviewFetcher.dataIsLoaded && !reviewFetcher.connectionError {
                        LazyVStack(spacing: 20){
                                
                                ForEach((reviewFetcher.reviewList?.reviews)!) { review in
                                    ReviewListItem(review: review).onAppear() {
                                        self.reviewFetcher.loadMoreReviewsIfNeeded(currentReview: review)
                                    }
                                }
                            }
                    }
                }
                .gesture(DragGesture().updating($dragOffset, body: { (value, state, transaction) in

                    if(value.startLocation.x < 20 && value.translation.width > 100) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }))
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
            /// Loading Icon ///
            if !self.reviewFetcher.dataIsLoaded {
                LoadingIcon(isAnimating: true, style: .large, color: UIColor.white)
            } else if self.reviewFetcher.dataIsLoaded && self.reviewFetcher.connectionError {
                //Connection Error Message ///
                Text("Error loading reviews. Please try again.")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .frame(width: 200)
            } else if self.reviewFetcher.dataIsLoaded && !self.reviewFetcher.connectionError && reviewFetcher.reviewList!.reviews!.isEmpty {
                //No Review Message
                Text("No Reviews")
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
            }
        }
    }
}

struct ReviewView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewView(contentId: 38700, contentType: "Movie")
    }
}
