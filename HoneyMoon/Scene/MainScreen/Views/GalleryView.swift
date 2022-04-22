//
//  GalleryView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 04/03/2022.
//

import SwiftUI

struct GalleryView: View {
  var profile: TinderModel
    var body: some View {

      VStack {
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 10) {
            ForEach(profile.image) { name in
              Image(name)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 250)
                .cornerRadius(20)
                .padding(10)
            }
          }.padding()
        }
      }.frame(height: 250)

    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
      GalleryView(profile: TinderData[1]).previewLayout(.sizeThatFits)
    }
}
