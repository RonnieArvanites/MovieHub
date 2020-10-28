//
//  NavBarWithShareButton.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import SwiftUI

// Navigation bar with a back button, title, and share button
struct NavBarWithShareButton: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var shareLink: String?
    
    var body: some View {
        HStack{
            /*
                Back Button
             */
            Button(action: {
                // Navigates back to previous screen
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 25))
                    .frame(width: 30, height: 30, alignment: .center)
            }
            .foregroundColor(Color.white)
            .padding(.leading, 10)
            
            Spacer()
            
            /*
                Title
             */
            Text("MovieHub")
                .foregroundColor(.white)
                .font(.system(size:25))
                .fontWeight(.bold)
            
            Spacer()
            
            /*
                More Option Button
             */
            // Check if share link is available
            if self.shareLink != nil{
                Button(action: {
                    // Show more options
                    self.actionSheet()
                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 25))
                        .frame(width: 30, height: 30, alignment: .center)
                }
                .foregroundColor(Color.white)
                .padding(.trailing, 10)
            } else {
                // Invisible button to center title
                Rectangle()
                    .fill(Color.clear)
                    .frame(width: 30, height: 30, alignment: .center)
            }
            
        }
        .frame(height: Globals.navBarHeight, alignment: .center)
        .background(Color.black)
        
    }
    
    /*
        Share Action Sheet
     */
    func actionSheet() {
        guard let link = URL(string: shareLink!) else { return }
        let actionSheet = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(actionSheet, animated: true, completion: nil)
    }
}

struct MovieNavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBarWithShareButton(shareLink: "https://www.themoviedb.org/movie/337401")
    }
}
