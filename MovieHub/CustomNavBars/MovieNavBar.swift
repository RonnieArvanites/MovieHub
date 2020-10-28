//
//  MovieNavBar.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import SwiftUI

struct NavBarWithShareButton: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    let title: String
    var movieShareLink: String?
    
    var body: some View {
        HStack{
            ////// Back Button //////
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .frame(width: 30, height: 30, alignment: .center)
            }
            .foregroundColor(Color.white)
            .padding(.leading, 10)
            
            Spacer()
            
            /// Title //////
            Text("MovieHub")
                .foregroundColor(.white)
                .font(.system(size:25))
                .fontWeight(.bold)
//            Text(title)
//                .foregroundColor(Color.white)
//                .font(.system(size: 25))
//                .fontWeight(.bold)
//                .minimumScaleFactor(0.50)
            
            Spacer()
            
            //More option button
            //Check if share link is available
            if self.movieShareLink != nil{
                Button(action: {
                        self.actionSheet()
                    //Show more options
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 25))
                        .frame(width: 30, height: 30, alignment: .center)
                }
                .foregroundColor(Color.white)
                .padding(.trailing, 10)
            } else {
                //Invisible button to center title
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 30, height: 30, alignment: .center)
            }
            
        }
        .frame(height: Globals.navBarHeight, alignment: .center)
        .background(Color.black)
        
    }
    
    //Share action sheet
    func actionSheet() {
        guard let data = URL(string: movieShareLink!) else { return }
            let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        }
}

struct MovieNavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBarWithShareButton(movieShareLink: "https://www.themoviedb.org/movie/337401")
    }
}
