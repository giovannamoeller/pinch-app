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
  @State private var imageOffset: CGSize = .zero
  @State private var isDrawerOpen: Bool = true
  
  let pages: [Page] = pagesData
  @State private var pageIndex: Int = 0
  
  func resetImageImageState() {
    return withAnimation(.spring()) {
      imageScale = 1
      imageOffset = .zero
    }
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        Color.clear
        Image(pages[pageIndex].imageName)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(10)
          .padding()
          .shadow(color: .black.opacity(isAnimating ? 0.4 : 0), radius: 12, x: 2, y: 2)
          .opacity(isAnimating ? 1 : 0)
          .offset(y: isAnimating ? 0 : 250)
          .animation(.easeOut(duration: 1.0), value: isAnimating)
          .scaleEffect(imageScale)
          .offset(x: imageOffset.width, y: imageOffset.height)
          .onTapGesture(count: 2) {
            if imageScale == 1 {
              withAnimation(.spring()) {
                imageScale = 5
              }
            } else {
              resetImageImageState()
            }
          }
          .gesture(
            DragGesture().onChanged({ gesture in
              withAnimation {
                imageOffset = gesture.translation
              }
            }).onEnded({ gesture in
              if imageScale <= 1 {
                resetImageImageState()
              } else {
                imageOffset = gesture.translation
              }
            })
          )
          .gesture(
            MagnificationGesture()
              .onChanged { gesture in
                withAnimation(.linear(duration: 1)) {
                  if imageScale >= 1 && imageScale <= 5 {
                    imageScale = gesture
                  } else if imageScale > 5 {
                    imageScale = 5
                  }
                }
              }
              .onEnded { _ in
                if imageScale > 5 {
                  imageScale = 5
                } else if imageScale <= 1 {
                  resetImageImageState()
                }
              }
          )
      }
      .navigationTitle("Pinch and Zoom")
      .navigationBarTitleDisplayMode(.inline)
      .onAppear {
        isAnimating = true
      }
      .overlay (
        InfoPanelView(scale: imageScale, offset: imageOffset)
          .padding(.horizontal)
          .padding(.top, 30)
        , alignment: .top
      )
      .overlay(
        Group {
          HStack {
            Button {
              withAnimation(.spring()) {
                if imageScale > 1 {
                  imageScale -= 1
                  
                  if imageScale <= 1 {
                    resetImageImageState()
                  }
                }
              }
            } label: {
              ControlImageView(imageName: "minus.magnifyingglass")
            }
            
            Button {
              resetImageImageState()
            } label: {
              ControlImageView(imageName: "arrow.up.left.and.down.right.magnifyingglass")
            }
            
            Button {
              withAnimation(.spring()) {
                if imageScale < 5 {
                  imageScale += 1
                  
                  if imageScale > 5 {
                    imageScale = 5
                  }
                }
              }
            } label: {
              ControlImageView(imageName: "plus.magnifyingglass")
            }
          }
          .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
          .background(.ultraThinMaterial)
          .cornerRadius(12)
          .opacity(isAnimating ? 1 : 0)
        }
        .padding(.bottom, 30),
        alignment: .bottom
      )
      .overlay(
        HStack(spacing: 12) {
          Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
            .resizable()
            .scaledToFit()
            .frame(height: 40)
            .padding(8)
            .foregroundStyle(.secondary)
            .onTapGesture(perform: {
              withAnimation(.easeOut(duration: 0.3)) {
                isDrawerOpen.toggle()
              }
            })
          ForEach(pages) { page in
            Image(page.thumbnailName)
              .resizable()
              .scaledToFit()
              .cornerRadius(8)
              .shadow(radius: 4)
              .onTapGesture {
                withAnimation(.easeOut(duration: 0.3)) {
                  pageIndex = page.id - 1
                }
              }
          }
          Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .opacity(isAnimating ? 1 : 0)
        .offset(x: isDrawerOpen ? 12 : UIScreen.main.bounds.width / 2)
        .frame(width: UIScreen.main.bounds.width / 1.5)
        .padding(.top, UIScreen.main.bounds.height / 12)
        , alignment: .topTrailing
      )
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


