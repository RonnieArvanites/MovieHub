//
//  ScoreIcon.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/4/20.
//

import SwiftUI

// Score icon used in movie and tv show scores
struct ScoreIcon: View {
    
    var score: CGFloat
    var circleColor: Color
    
    init(score: CGFloat){
        self.score = score
        // Determine the color of the circle based on the rating
        if (score <= 20) {
            // Sets color to red
            self.circleColor = Color(red: 255 / 255, green: 69 / 255, blue: 69 / 255)
        } else if (score <= 40) {
            // Sets color to orange
            self.circleColor = Color(red: 255 / 255, green: 165 / 255, blue: 52 / 255)
        } else if (score <= 60) {
            // Sets color to yellow
            self.circleColor = Color(red: 255 / 255, green: 226 / 255, blue: 52 / 255)
        } else if (score <= 80) {
            // Sets color to light green
            self.circleColor = Color(red: 183 / 255, green: 221 / 255, blue: 41 / 255)
        } else if (score <= 100) {
            // Sets color to green
            self.circleColor = Color(red: 87 / 255, green: 227 / 255, blue: 44 / 255)
        } else {
            // Sets color to green
            self.circleColor = Color(red: 87 / 255, green: 227 / 255, blue: 44 / 255)
        }
    }
    
    var body: some View {
        ZStack {
            /*
             Outer Circle
             */
            Circle()
                .stroke(circleColor, lineWidth: 5)
                .opacity(0.1)
            /*
             Score Color Ring
             */
            Circle()
                .trim(from: 0, to: score/100)
                .stroke(circleColor, lineWidth: 5)
                .rotationEffect(.degrees(-90))
                .overlay(
                    /*
                     Inner Black Circle
                     */
                    Circle()
                        .fill(Color.black)
                        .overlay(
                            /*
                             Score
                             */
                            Text("\(Int(score))%")
                                .font(.system(size: 12))
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        )
                )
        }
        .padding(5)
        .frame(width: 50, height: 50)
    }
}

struct ScoreIcon_Previews: PreviewProvider {
    static var previews: some View {
        ScoreIcon(score: 90)
    }
}
