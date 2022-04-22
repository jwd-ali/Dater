//
//  ProfileView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 03/03/2022.
//

import SwiftUI

struct ProfileView: View {
  var profile: TinderModel

  var namespace: Namespace.ID
  @State private var isAnimating: Bool = false
  @State var showAlert = false
  @Binding var showHomeScreen: Bool
  @State private var isDrawerOpen: Bool = false
  @Binding var currentPage: Int

    var body: some View {
      ZStack {
        Color("PrimaryWhite")
          .matchedGeometryEffect(id: "bgColor", in: namespace)

      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 0) {
          Image(profile.image[currentPage-1])
            .resizable()
            .scaledToFill()
            .matchedGeometryEffect(id: "cardV", in: namespace)
            .frame(width: UIScreen.main.bounds.maxX, height: 500)
            .clipped()

            .overlay(
              HStack(spacing: 12) {
                // MARK: - DRAWER HANDLE
                Image(systemName: isDrawerOpen ? "chevron.compact.right" :  "chevron.compact.left")
                  .font(Font.system(size: 50, weight: .bold, design: .rounded))
                  .frame(width: 30, height: 120)
                  .foregroundColor(.secondary)
                  .onTapGesture(perform: {
                    withAnimation(.easeOut) {
                      isDrawerOpen.toggle()
                    }
                  })

                // MARK: - THUMBNAILS
                ForEach(profile.image) { item in
                  Image(item)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 120)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .opacity(isDrawerOpen ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                    .onTapGesture(perform: {
                      isAnimating = true
                      currentPage = (profile.image.firstIndex(where: { $0 == item }) ?? 0) + 1
                    })
                }

                Spacer()
              } //: DRAWER
              .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
              .background(Blur(style: .systemUltraThinMaterialLight))
              .cornerRadius(12)
              .opacity(isAnimating ? 1 : 0)
              .frame(width: 70*CGFloat(Double(profile.image.count) + 1.5))
              .padding(.top, UIScreen.main.bounds.height / 12)
              .offset(x: isDrawerOpen ? 20 : 70*CGFloat(Double(profile.image.count)) + 70)
              , alignment: .topTrailing
            )

            .overlay(
              ProfileCustomShape(circleSize: 70)
                .foregroundColor(Color("PrimaryWhite"))
                .frame(maxHeight: 170)
                .shadow(color: Color("shadow"), radius: 10, x: 0.0, y:0)
                .mask(Rectangle().padding(.top, -20))
                .overlay(
                  ZStack {
                    Circle().stroke(Color("PrimaryWhite"), lineWidth: 3)
                      .frame(width: 53, height: 53)


                    Button(action: {showHomeScreen.toggle()}) {

                    Image(systemName: "arrow.down.circle.fill")
                      .resizable()
                      .foregroundColor(Color("logoColor"))

                    }.frame(width: 50, height: 50)
                      .shadow(radius: 10)

                  }
                  .offset(x: 0, y: -10)
                  .padding(.horizontal ,25)
                  , alignment: .trailing
                )
              , alignment: .bottom
            )
            .overlay(

              VStack(spacing: 5) {

              HStack {
                Text(profile.name)
                  .font(.system(size: 30))
                  .fontWeight(.bold)
                  .padding(.horizontal)
                Spacer()
              }

                HStack (spacing: 2){
                  Image("location")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .leading)
                    .scaledToFit()
                    .foregroundColor(Color("lightGrey"))

                  Text("London, UK - \(Int(profile.distance)) miles away")
                    .foregroundColor(.secondary)
                    .font(.title3)
                }.offset(x: -25, y: 0)

              }.padding(.vertical)

              .padding(.horizontal, 40)

              , alignment: .bottom
            )

          HeadlineView(icon: "info.circle", title: "Bio")


          HStack {
          Spacer(minLength: 52)
          Text("I’m new to online dating, but I know what I’m looking for in a man. My Christian faith is important to me, so I want to find a man who feels the same way. Additionally, I’m really into movies, so a guy who likes to cuddle up on the couch instead of going out on a Friday night is the right match for me.")
            .font(.footnote)
            .multilineTextAlignment(.leading)
            .foregroundColor(.secondary)
            .padding(.horizontal, 10)
            .frame(maxHeight: .infinity)
          }

          HeadlineView(icon: "shippingbox", title: "Common interests")

          HStack {
            Spacer(minLength: 52)

            TagView(tagName: "Podcasts")
            TagView(tagName: "Dancing")
            TagView(tagName: "Trekking")
            Spacer()

          }.padding(.horizontal, 10)

          Spacer(minLength: 10)

          HStack {
            Spacer(minLength: 52)


            TagView(tagName: "Yoga")
            TagView(tagName: "Running")
            TagView(tagName: "Tech")
            TagView(tagName: "cooking")

            Spacer()

          }.padding(.horizontal, 20)

          HeadlineView(icon: "photo.on.rectangle.angled", title: "Gallery")

          HStack {
            Spacer(minLength: 52)
            GalleryView(profile: profile)
              .padding(.vertical)
          }

          Spacer(minLength: 30)
        } // VStack
      } // ScrollView
      .onAppear(perform: {
        isAnimating = true
      })

        VStack {
          HStack {
            Spacer()

            Button(action: { showAlert.toggle() }) {
            Image(systemName: "ellipsis")
              .foregroundColor(Color("PrimaryWhite"))
              .font(.system(size: 30))
              .shadow(radius: 5)
              .padding()
            }.padding(.vertical, 25)
          }.shadow(radius: 10)


          Spacer()
        } .actionSheet(isPresented: $showAlert, content: {
          ActionSheet(title: Text("Profile actions"), message: Text("You can share or report user profile using this menu"), buttons: [
            .default(Text("Share profile")) {},
            .destructive(Text("Report profile")),
            .cancel()
          ])
        })
      }.edgesIgnoringSafeArea(.all)
    }
}

struct ProfileView_Previews: PreviewProvider {
 @State static var showHome = false
 @Namespace static var namespace
    static var previews: some View {
      Group {
        ProfileView(profile: TinderData[3], namespace: namespace, showHomeScreen: $showHome, currentPage: .constant(0))
        ProfileView(profile: TinderData[3], namespace: namespace, showHomeScreen: $showHome, currentPage: .constant(0)).preferredColorScheme(.dark)
      }
    }
}
//
struct HeadlineView: View {
  let icon: String
  let title: String

  var body: some View {

    Spacer(minLength: 10)
    HStack(spacing: 20) {
      Image(systemName: icon)
        .font(.system(size: 25))
        .foregroundColor(Color("lightGrey"))
        .opacity(0.7)

      Text(title)
        .foregroundColor(.primary)
        .fontWeight(.bold)
        .font(.system(size: 25))


      Spacer()
    }.padding()
  }
}

struct TagView: View {
  let tagName: String
  var body: some View {
    ZStack {
      Capsule().stroke(Color.gray, lineWidth: 0.5)


      Text(tagName)
        .lineLimit(1)
        .font(.caption)
        .padding(.horizontal, 5)
        .padding(.vertical, 5)
    }.frame(maxHeight: 30)
  }
}

extension String: Identifiable {
  public typealias ID = Int
  public var id: Int {
    return hash
  }
}

struct Blur: UIViewRepresentable {
  var style: UIBlurEffect.Style = .systemMaterial

  func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }

  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}
