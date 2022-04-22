//
//  CardView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 27/02/2022.
//

import SwiftUI

struct CardView: View, Identifiable {
  let id = UUID()
  var destination: Destination
    var body: some View {
      Image(destination.image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .cornerRadius(20)
          .overlay(
            VStack(spacing: 0) {
              Text(destination.place.uppercased())
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 30)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
                .shadow(color: Color.init(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.3), radius: 20, x: 2, y: 1)

              Capsule().fill(Color.white).frame(maxHeight: 3)
                .padding(.horizontal, 60)
                .padding(.vertical, 5)

              Text(destination.country.uppercased())
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .padding(.horizontal, 20)
                .padding(.vertical, 5)
                .background(Capsule().fill(Color.white))
                .padding(.vertical, 5)


            }.padding(.vertical, 30)
            , alignment: .bottom)
          .padding()

    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
      CardView(destination: honeymoonData[0])
    }
}
