//
//  HeaderView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 26/02/2022.
//

import SwiftUI

struct HeaderView: View {
  // MARK: - PROPERTIES
  @Binding var showGuideView: Bool
  @Binding var showInfoView: Bool

  var body: some View {
    ZStack {
      Color("PrimaryWhite")

      HStack {
        Button(action: {self.showInfoView.toggle()}) {
          Image(systemName: "info.circle.fill")
            .font(.system(size: 30))
            .foregroundColor(Color("logoColor"))
            .sheet(isPresented: $showInfoView) {
              InfoView()
            }
        }.padding(.horizontal, 10)

        Spacer()
        HStack(spacing:0) {
          Image("logoNew")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 50, alignment: .center)

        Text("Dater.")
          .fontWeight(.heavy)
          .font(.system(size: 20))
          .foregroundColor(Color("logoColor"))
          .padding(.horizontal, 0)
        }
        
        Spacer()
        Button(action: {self.showGuideView.toggle()}) {
          Image(systemName: "questionmark.circle.fill")
            .font(.system(size: 30))
            .foregroundColor(Color("logoColor"))
            .sheet(isPresented: $showGuideView) {
              GuideView()
            }
        }.padding(.horizontal, 10)

      }

    }
    .minimumScaleFactor(0.2)

  }
}

struct HeaderView_Previews: PreviewProvider {
  @State static var showGuide: Bool = false
  @State static var showInfo: Bool = false

  static var previews: some View {
    HeaderView(showGuideView: $showGuide, showInfoView: $showInfo)
      .previewLayout(.fixed(width: 375, height: 80))
  }
}
