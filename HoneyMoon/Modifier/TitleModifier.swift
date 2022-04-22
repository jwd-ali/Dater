//
//  Created by Robert Petras
//  SwiftUI Masterclass ♥ Better Apps. Less Code.
//  https://swiftuimasterclass.com
//

import SwiftUI

struct TitleModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.largeTitle)
      .foregroundColor(Color("logoColor"))
  }
}
