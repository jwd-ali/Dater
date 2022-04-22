//
//  TinderCardView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 28/02/2022.
//

import SwiftUI

struct TinderCardView: View, Identifiable {
  let id = UUID()
  var destination: Destination
  var body: some View {
    ZStack {
      Color(.white)
      VStack(alignment: .center) {
        // MARK:- top view

        Image(destination.image)
          .resizable()
          .scaledToFit()
          .cornerRadius(20)


      }
    }
  }
}

struct TinderCardView_Previews: PreviewProvider {
    static var previews: some View {
        TinderCardView(destination: honeymoonData[0])
          .previewLayout(.fixed(width: 350, height: 500))
    }
}
