//
//  TinderHomeView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 28/02/2022.
//

import SwiftUI


struct TinderHomeView: View {

  enum DragState {
    case inActive
    case pressing
    case dragging(translation: CGSize)


    var translation: CGSize {
      switch self {
        case .inActive, .pressing:
          return .zero
        case .dragging(let translation):
          return translation
      }
    }

    var isPressing: Bool {
      switch self {
        case .inActive:
          return false
        default:
          return true
      }
    }

    var isDragging: Bool {
      switch self {
        case .dragging:
          return true
        default:
          return false
      }
    }
  }

  @State var showGuide: Bool = false
  @State var showInfo: Bool = false

  @State private var lastCardIndex = 2
  @State private var cardRemovalTransition = AnyTransition.trailingBottom

  @State var likeProgress: CGFloat = 0
  @State var dislikeProgress: CGFloat = 0

  @State var isShowingProfile = false

 @Namespace var nameSpace

  @GestureState var dragState = DragState.inActive
  @State var numberOfImages: Int = 4
  @State var selectedImage: Int = 1

  let threshHold: CGFloat = 120
  @State var viewAppear: Bool = false
  @State private var cardViews = [CustomShapeView]()

  func initializeCardViews() {
    for index in 0..<3 {
      let view = CustomShapeView(person: TinderData[index], imageIndex: $selectedImage)
      cardViews.append(view)
    }
  }

  private func isTopCard(card: CustomShapeView) -> Bool {
    cardView(index: card) == 0
  }

  private func verticalPadding(card: CustomShapeView) -> CGFloat {
    switch cardView(index: card) {
      case 1:
        return 30
      case 2:
        return 60
      default:
        return 0
    }
  }

  private func getNumberOfImages() {
    numberOfImages = TinderData[(lastCardIndex - 2) % TinderData.count].image.count
  }

  private func changeImage() {

    selectedImage = selectedImage % TinderData[((lastCardIndex - 2) % TinderData.count)].image.count
    selectedImage += 1

    print(selectedImage)
  }

  private func cardView(index card: CustomShapeView)-> Int {
    cardViews.firstIndex(where: { $0.id == card.id }) ?? 0
  }

  private func opacity(index card: CustomShapeView) -> Double {
    switch cardView(index: card) {
      case 1:
        return 0.85
      case 2:
        return 0.75
      default:
        return 1
    }
  }

  private func scaleCard(card: CustomShapeView) -> CGFloat {
    switch cardView(index: card) {
      case 1:
        return 0.94
      case 2:
        return 0.9
      default:
        return 1
    }
  }

  private func moveCards() {
    cardViews.removeFirst()
    lastCardIndex += 1
    selectedImage = 1
    let person = TinderData[lastCardIndex % TinderData.count]
    getNumberOfImages()
    cardViews.append(CustomShapeView(person: person, imageIndex: $selectedImage))
  }

  var body: some View {

    ZStack {
      Color("PrimaryWhite")
        .matchedGeometryEffect(id: "bgColor", in: nameSpace)
        .edgesIgnoringSafeArea(.all)

      VStack {
        HeaderView(showGuideView: $showGuide, showInfoView: $showInfo)
         // .matchedGeometryEffect(id: "header", in: nameSpace)
          .opacity(dragState.isPressing ? 0 : 1)
          .animation(.easeOut)
          .onAppear(perform: {
            initializeCardViews()
            getNumberOfImages()
            viewAppear.toggle()
          })

        // MARK: - CARDS
        ZStack {
          ForEach(cardViews) { card in
            card
              .zIndex(Double(2 - cardView(index: card)))
              .overlay(
                  Text("LIKE")
                    .likeDislike(color: .green)
                    .rotationEffect(Angle(degrees: -13))
                    .padding(40)
                    .opacity(isTopCard(card: card) ? Double(likeProgress) : 0)
                , alignment: .topLeading)
          .overlay(
            Text("NOPE")
              .likeDislike(color: .red)
              .rotationEffect(Angle(degrees: 13))
              .padding(40)
              .opacity(isTopCard(card: card) ? Double(dislikeProgress) : 0)
          , alignment: .topTrailing
          )
              .overlay(
                SelectionProgressView(numberOfLines: $numberOfImages, selectedLine: $selectedImage)
                  .animation(.default)
                  .padding(.horizontal, 20)
                  .padding(.vertical, 30)
                  .opacity(dragState.isPressing ? 0 : 1)
                , alignment: .top
              )
              .opacity(opacity(index: card))
              .offset(x: isTopCard(card: card) ? dragState.translation.width : 0, y: isTopCard(card: card) ? dragState.translation.height: verticalPadding(card: card))
              .scaleEffect((dragState.isPressing && isTopCard(card: card)) ? 0.8 : scaleCard(card: card))
              .rotationEffect(isTopCard(card: card) ? Angle(degrees: Double(dragState.translation.width)/12): Angle(degrees:  0))
              .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.15), radius: 10, x: 0.0, y: 8)
              .animation(.interpolatingSpring(stiffness: 120, damping: 120))

              /// Sequences a gesture with another one to create a new gesture, which
              /// results in the second gesture only receiving events after the first
              /// gesture succeeds.
              ///
              /// - Parameter other: A gesture you want to combine with another gesture to
              ///   create a new, sequenced gesture.
              ///
              /// - Returns: A gesture that's a sequence of two gestures.
              .gesture(TapGesture()
              .onEnded {
                changeImage()
              })

              .gesture(
                LongPressGesture(minimumDuration: 0.01)
                        .sequenced(before: DragGesture())
                        .updating($dragState, body: { value, state, transaction in
                          switch value {

                            case .first:
                              state = .pressing

                            case .second(_, let drag):
                              state = .dragging(translation: drag?.translation ?? .zero)
                          }
                        })
                        .onChanged({ (value) in
                          guard case .second(true, let drag?) = value else {
                            return
                          }

                          likeProgress = drag.translation.width > 0 ? drag.translation.width/threshHold : 0
                          dislikeProgress = drag.translation.width < 0 ? abs(drag.translation.width)/threshHold : 0

                          if drag.translation.width < -threshHold {
                            self.cardRemovalTransition = .leadingBottom
                          }

                          if drag.translation.width > threshHold {
                            self.cardRemovalTransition = .trailingBottom
                          }
                        })
                        .onEnded { value in
                          guard case .second(true, let drag?) = value else {
                            return
                          }
                          if drag.translation.width > threshHold || drag.translation.width < -threshHold {
                            moveCards()
                          }
                          likeProgress = 0
                          dislikeProgress = 0
                        }
              ).transition(cardRemovalTransition)
          }//.matchedGeometryEffect(id: "card", in: nameSpace)
        }.matchedGeometryEffect(id: "cardV", in: nameSpace)

        Spacer()
        TinderFooterButtonView(likeProgress: $likeProgress, dislikeProgress: $dislikeProgress) {
          print("456666")
          withAnimation(.spring()) {
          isShowingProfile.toggle()
          }
        }
          .frame(maxHeight: UIScreen.main.bounds.maxX/3 < 120 ? 120 : UIScreen.main.bounds.maxX/3)
          .opacity(viewAppear ? 1 : 0)
      }

      if isShowingProfile {
        ProfileView(profile: TinderData[((lastCardIndex - 2) % TinderData.count)], namespace: nameSpace, showHomeScreen: $isShowingProfile, currentPage: $selectedImage)
      }

    }
  }
}

struct TinderHomeView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      TinderHomeView()
      TinderHomeView()
        .preferredColorScheme(.dark)
    }
  }
}

struct likeDislike: ViewModifier {
  var color: Color = .green
  func body(content: Content) -> some View {
    content
      .font(.system(size: 42, weight: .heavy, design: .rounded))
      .padding(.vertical, 5)
      .padding(.horizontal, 30)
      .background(Capsule().stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)))
      .foregroundColor(color)
      .shadow(color: .black, radius: 5, x: 2, y: 2)
  }

  init(textColor: Color = .green) {
   color = textColor
  }
}
extension View {
  func likeDislike(color: Color = .green) -> some View {
    modifier(HoneyMoon.likeDislike(textColor: color))
  }
}
