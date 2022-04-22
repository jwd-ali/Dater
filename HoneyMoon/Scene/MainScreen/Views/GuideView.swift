//
//  Created by Robert Petras
//  SwiftUI Masterclass ♥ Better Apps. Less Code.
//  https://swiftuimasterclass.com
//

import SwiftUI

struct GuideView: View {
  // MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .center, spacing: 20) {
        HeaderComponent()
        
        Spacer(minLength: 10)
        
        Text("Get Started!")
          .fontWeight(.black)
          .modifier(TitleModifier())
        
        Text("Discover and pick the perfect Partner for your romantic Date!")
          .lineLimit(nil)
          .foregroundColor(.primary)
          .multilineTextAlignment(.center)
        
        Spacer(minLength: 10)
        
        VStack(alignment: .leading, spacing: 25) {
          GuideComponent(
            title: "Like",
            subtitle: "Swipe right",
            description: "Do you like her? Touch the screen and swipe right. It will be saved to the favourites.",
            icon: "heart.circle")
          
          GuideComponent(
            title: "Dismiss",
            subtitle: "Swipe left",
            description: "Would you rather skip this date? Touch the screen and swipe left. You will no longer see her.",
            icon: "xmark.circle")
          
          GuideComponent(
            title: "Profile",
            subtitle: "Tap the button",
            description: "You can view the profile of the beautiful person by tapping this button",
            icon: "checkmark.square")
        }
        
        Spacer(minLength: 10)
        
        Button(action: {
          // ACTION
          // print("A button was tapped.")
          self.presentationMode.wrappedValue.dismiss()
        }) {
          Text("Continue".uppercased())
            .modifier(ButtonModifier())
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity)
      .padding(.top, 15)
      .padding(.bottom, 25)
      .padding(.horizontal, 25)
    }
  }
}

struct GuideView_Previews: PreviewProvider {
  static var previews: some View {
    GuideView()
  }
}
