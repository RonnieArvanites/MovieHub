//
//  DefaultNavBar.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/2/20.
//

import SwiftUI

// Navigation bar with a back button and title
struct DefaultNavBar: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let title: String
    
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
            Text(title)
                .foregroundColor(Color.white)
                .font(.system(size: 25))
                .fontWeight(.bold)
                .minimumScaleFactor(0.50)
                .lineLimit(1)
            
            Spacer()
            
            // Imaginary Icon to help center title
            Rectangle()
                .fill(Color.clear)
                .frame(width: 30, height: 30, alignment: .center)
                .padding(.trailing, 10)
            
            
        }
        .frame(height: Globals.navBarHeight, alignment: .center)
        .background(Color.black)
        
    }
}

struct DefaultNavBar_Previews: PreviewProvider {
    static var previews: some View {
        DefaultNavBar(title: "MovieHub")
    }
}
