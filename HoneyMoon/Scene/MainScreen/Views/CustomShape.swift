//
//  CustomShape.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 28/02/2022.
//

import SwiftUI
struct CustomShapeA: Shape {

  func path(in rect: CGRect) -> Path {
    var path = Path()


    path.move(to: CGPoint(x: 0,y: rect.maxY))

    path.addQuadCurve(to: CGPoint(x: rect.midX/1.5, y: rect.midY/0.65), control: CGPoint(x: rect.midX/9, y: rect.midY/0.85))

    path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY), control: CGPoint(x: rect.midX * 1.8, y: rect.maxY*1.2))

    path.addLine(to:  CGPoint(x: rect.maxX,y: rect.maxY))
    path.addLine(to:  CGPoint(x: rect.minX,y: rect.maxY))

    path.closeSubpath()

    return path
  }
}

struct CustomShapeB: Shape {

  func path(in rect: CGRect) -> Path {
    var path = Path()


    path.move(to: CGPoint(x: 0,y: rect.maxY))

    path.addQuadCurve(to: CGPoint(x: rect.midX/1.5, y: rect.midY/0.75), control: CGPoint(x: rect.midX/9, y: rect.midY/0.85))

    path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.midY*0.8), control: CGPoint(x: rect.midX * 1.8, y: rect.maxY ))

    path.addLine(to:  CGPoint(x: rect.maxX,y: rect.maxY))
    path.addLine(to:  CGPoint(x: rect.minX,y: rect.maxY))

    path.closeSubpath()

    return path
  }
}

struct CustomShapeView: View,Identifiable {
  let id = UUID()
  let person: TinderModel
  @Binding var imageIndex: Int
  
  var body: some View {
    VStack {
      ZStack {
        Image(person.image.count > (imageIndex-1) ? person.image[imageIndex-1] : person.image[0])
          .resizable()
          .scaledToFill()
          .transition(.opacity)
          .clipped()

      }
      .frame(maxHeight: UIScreen.main.bounds.maxY/2)
      .animation(nil)

      .overlay(
        ZStack {
          CustomShapeB().fill(Color("PrimaryWhite").opacity(0.4))
          CustomShapeA().fill(Color("PrimaryWhite"))

        }.frame(maxHeight: 100)
        .offset(x: 0, y: 8)
        , alignment: .bottom)

      ZStack {
        Color("PrimaryWhite")
        VStack(spacing: 10) {
          HStack {
            Text(person.name)
              .font(.system(size: 30, weight: .bold, design: .rounded))
            Spacer()
            Image(systemName: "info.circle.fill")
              .foregroundColor(Color("lightGrey"))
              .font(.system(size: 30))
          }

          VStack (spacing: 3){
            HStack {
              Text(person.occupation)
                .font(.system(size: 20, weight: .light, design: .rounded))
                .foregroundColor(.secondary)
              Spacer()
            }


          HStack {
            Text("\(Int(person.distance)) miles away")
              .font(.system(size: 20, weight: .light, design: .rounded))
              .foregroundColor(.secondary)
            Spacer()
          }
            Spacer(minLength: 20)
          }
        }.padding(.horizontal)

      }
    } .cornerRadius(20)
    .padding()
  }
}

struct CustomShape_Previews: PreviewProvider {
  @State static var selectedImage: Int = 0
    static var previews: some View {
      CustomShapeView(person: TinderData[0], imageIndex: $selectedImage).preferredColorScheme(.light).previewLayout(.fixed(width: 400, height: 700))
    }
}
