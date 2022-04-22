//
//  FooterView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 26/02/2022.
//

import SwiftUI

struct FooterView: View {
  @State var showAlert: Bool = false
    var body: some View {
      HStack(spacing: 10) {
        Image(systemName: "xmark.circle")
          .font(.system(size: 42, weight: .light, design: .rounded))


        Spacer()

        Button(action: {
          showAlert.toggle()
        }) {
          Text("Book destination".uppercased())
            .font(.system(.subheadline, design: .rounded))
            .fontWeight(.heavy)
            .minimumScaleFactor(0.2)
            .accentColor(.pink)
            .lineLimit(1)

        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(Capsule().stroke(Color.pink, lineWidth: 2))

        Spacer()
        Image(systemName: "heart.circle")
          .font(.system(size: 42, weight: .light, design: .rounded))
      }
      .padding()
      .alert(isPresented: $showAlert, content: {
        Alert(
          title: Text("SUCCESS"),
          message: Text("Wishing a lovely and most precious of the times together for the amazing couple."),
          dismissButton: .default(Text("Happy Honeymoon!")))
      })
    }
}

struct FooterView_Previews: PreviewProvider {
    static var previews: some View {
      FooterView(showAlert: false)
          .previewLayout(.fixed(width: 380, height: 80))
    }
}
