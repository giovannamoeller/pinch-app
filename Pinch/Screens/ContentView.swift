//
//  ContentView.swift
//  Pinch
//
//  Created by Giovanna Moeller on 19/04/23.
//

import SwiftUI

struct ContentView: View {
  
  @State private var isAnimating: Bool = false
  @State private var imageScale: CGFloat = 1.0
  
  var body: some View {
    NavigationView {
      ZStack {
        Image("magazine-front-cover")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(10)
          .padding()
          .shadow(color: .black.opacity(isAnimating ? 0.4 : 0), radius: 12, x: 2, y: 2)
          .opacity(isAnimating ? 1 : 0)
          .offset(y: isAnimating ? 0 : 250)
          .animation(.easeOut(duration: 1.0), value: isAnimating)
          .scaleEffect(imageScale)
          .onTapGesture(count: 2) {
            if imageScale == 1 {
              withAnimation(.spring()) {
                imageScale = 5
              }
            } else {
              withAnimation(.spring()) {
                imageScale = 1
              }
            }
          }
        
      }
      .navigationTitle("Pinch and Zoom")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear {
        isAnimating = true
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
