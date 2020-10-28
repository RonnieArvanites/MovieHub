//
//  ReviewListItem.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/6/20.
//

import SwiftUI

// Displays review
struct ReviewListItem: View {
    
    var review: Review
    var borderWidth: CGFloat = 2
    
    var body: some View {
        VStack{
            /*
             Author
             */
            HStack{
                
                Text("Author:")
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                
                Text(review.author)
                    .font(.system(size: 15))
                
                Spacer()
            }
            
            Spacer().frame(height: 5)
            
            /*
             Review
             */
            VStack{
                Text(review.content)
                    .font(.system(size: 15))
            }
        }
        .padding(.all, 10)
        .background(Color.black)
        .foregroundColor(Color.white)
        .frame(width: UIScreen.main.bounds.width - borderWidth, alignment: .top)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white, lineWidth: borderWidth)
            )
    }
}

struct ReviewListItem_Previews: PreviewProvider {
    static var previews: some View {
        ReviewListItem(review: Review(id: "frt564", author: "Bob", content: "This movie rocks!"))
    }
}
