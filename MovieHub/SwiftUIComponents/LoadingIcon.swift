//
//  LoadingIcon.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/3/20.
//

import Foundation
import SwiftUI

// SwiftUI wrapper for UIKit Loading Icon
struct LoadingIcon: UIViewRepresentable {

    var isAnimating: Bool
    let style: UIActivityIndicatorView.Style
    let color: UIColor

    func makeUIView(context: UIViewRepresentableContext<LoadingIcon>) -> UIActivityIndicatorView {
         let loadingIcon = UIActivityIndicatorView(style: style)
        loadingIcon.color = self.color
        
        return loadingIcon
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingIcon>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

struct LoadingIcon_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIcon(isAnimating: true, style: .large, color: UIColor.black)
    }
}
