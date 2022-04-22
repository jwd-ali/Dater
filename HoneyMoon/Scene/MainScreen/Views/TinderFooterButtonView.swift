//
//  TinderFooterButtonView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 28/02/2022.
//

import SwiftUI

struct TinderFooterButtonView: View {

  @Binding var likeProgress: CGFloat
  @Binding var dislikeProgress: CGFloat
  var action: (() -> Void)?

    var body: some View {
      VStack {
        Spacer()
        HStack {
          TinderButton(imageName: "xmark", imageColor: .yellow,name: "Nope", progress: dislikeProgress)
          TinderButton(imageName: "chevron.up", imageColor: .green, name: "Profile") {
            action?()
          }
          TinderButton(imageName: "heart.fill" ,name: "Like", progress: likeProgress)

        }
      }
    }
}

struct TinderButton: View {
  var imageName: String
  var imageSize: CGFloat = 40
  var imageColor: Color = Color("logoColor")
  var bgColor: Color = .white
  var name: String
  var progress: CGFloat = 0
  var action: (() -> Void)?

  var body: some View {
    Button(action: {action?()}) {
      VStack(spacing: 5) {

        ZStack {

          Circle().fill(Color("shadow"))
            .blur(radius: 5)


          Circle().fill(Color("PrimaryWhite"))
            .padding(8)
            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.12), radius: 5, x: 0, y: 0)
            .animation(.spring())

          Circle()
            .trim(from:  0, to:  progress)
            .rotation(Angle(degrees: -90))
            .stroke(imageColor, style: StrokeStyle(lineWidth: 7, lineCap: .round))
            .padding(8)

          Image(systemName: imageName)
            .font(.system(size: imageSize, weight: .heavy, design: .rounded))
            .minimumScaleFactor(0.1)
            .accentColor(imageColor)
            .scaleEffect(progress >= 1 ? 1.2 : 1)
            .animation(.linear(duration: 0.2))

        }

        Text(name)
          .font(.system(size: 20))
          .fontWeight(.light)
          .foregroundColor(.primary)
      }


    }
  }
}

struct TinderFooterButtonView_Previews: PreviewProvider {
  @State static var likeProgress: CGFloat = 0
  @State static var dislikeProgress: CGFloat = 0
    static var previews: some View {
      Group{
      TinderFooterButtonView(likeProgress: $likeProgress, dislikeProgress: $dislikeProgress).preferredColorScheme(.light).previewLayout(.fixed(width: 600, height: 190))

        TinderFooterButtonView(likeProgress: $likeProgress, dislikeProgress: $dislikeProgress).preferredColorScheme(.dark)
      }
    }
}

