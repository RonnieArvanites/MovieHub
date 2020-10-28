//
//  LazyView.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/26/20.
//

import Foundation
import SwiftUI

// Used to only initialize the view when the user asks for the view
struct LazyView<Content: View>: View {
    
    var content: () -> Content
    
    var body: some View {
       self.content()
    }
}
