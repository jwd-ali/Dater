//
//  Created by Robert Petras
//  SwiftUI Masterclass ♥ Better Apps. Less Code.
//  https://swiftuimasterclass.com 
//

import SwiftUI

struct HeaderComponent: View {
  var body: some View {
    VStack(alignment: .center, spacing: 20) {
      Capsule()
        .frame(width: 120, height: 6)
        .foregroundColor(Color.secondary)
        .opacity(0.2)
      
      HStack(spacing:0) {
        Image("logoNew")
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 70, height: 50, alignment: .center)

        Text("Dater.".uppercased())
          .fontWeight(.heavy)
          .font(.system(size: 20))
          .foregroundColor(Color("logoColor"))
          .padding(.horizontal, 0)
      }
    }
  }
}

struct HeaderComponent_Previews: PreviewProvider {
  static var previews: some View {
    HeaderComponent()
      .previewLayout(.fixed(width: 375, height: 128))
  }
}
