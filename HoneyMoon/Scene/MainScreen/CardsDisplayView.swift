//
//  CardsDisplayView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 26/02/2022.
//

import SwiftUI

struct CardsDisplayView: View {

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
 @State private var lastCardIndex = 2
  @State private var cardRemovalTransition = AnyTransition.trailingBottom
 @State private var cardViews: [CardView] = {
    var views = [CardView]()

    for index in 0..<3 {
      views.append(CardView(destination: honeymoonData[index]))
    }
    return views
  }()

  private func isTopCard(card: CardView) -> Bool {
    cardView(index: card) == 0
  }

  private func verticalPadding(card: CardView) -> CGFloat {
    switch cardView(index: card) {
      case 1:
       return 40
      case 2:
        return 80
      default:
        return 0
    }
  }

  private func cardView(index card: CardView)-> Int {
    cardViews.firstIndex(where: { $0.id == card.id }) ?? 0
  }

  private func scaleCard(card: CardView) -> CGFloat {
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

    let honeymoon = honeymoonData[lastCardIndex % honeymoonData.count]

    cardViews.append(CardView(destination: honeymoon))
  }
  @State var showGuide: Bool = false
  @State var showInfo: Bool = false
  @GestureState var dragState = DragState.inActive
  let threshHold: CGFloat = 120

    var body: some View {
      VStack {
        HeaderView(showGuideView: $showGuide, showInfoView: $showGuide)
          .opacity(dragState.isPressing ? 0 : 1)
          .animation(.easeOut)

        Spacer()

        // MARK: - CARDS
        ZStack {
         ForEach(cardViews) { card in
            card
              .zIndex(Double(2 - cardView(index: card)))
              .overlay(
                ZStack {
                Image(systemName: "heart.circle")
                  .font(.system(size: 100, weight: .semibold, design: .rounded))
                  .foregroundColor(.white)
                  .shadow(radius: 12)
                  .opacity((isTopCard(card: card) && dragState.translation.width > threshHold) ? 1 : 0)

                  Image(systemName: "xmark.circle")
                    .font(.system(size: 100, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 12)
                    .opacity((isTopCard(card: card) && dragState.translation.width < -threshHold) ? 1 : 0)
                }
                , alignment: .center)
              .offset(x: isTopCard(card: card) ? dragState.translation.width : 0, y: isTopCard(card: card) ? dragState.translation.height: verticalPadding(card: card))
              .scaleEffect((dragState.isPressing && isTopCard(card: card)) ? 0.8 : scaleCard(card: card))
              .rotationEffect(isTopCard(card: card) ? Angle(degrees: Double(dragState.translation.width)/12): Angle(degrees:  0))
              .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.8), radius: 10, x: 0.0, y: 8)
              .animation(.interpolatingSpring(stiffness: 120, damping: 120))

              /// Sequences a gesture with another one to create a new gesture, which
              /// results in the second gesture only receiving events after the first
              /// gesture succeeds.
              ///
              /// - Parameter other: A gesture you want to combine with another gesture to
              ///   create a new, sequenced gesture.
              ///
              /// - Returns: A gesture that's a sequence of two gestures.

              .gesture(LongPressGesture(minimumDuration: 0.1)
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
                        }
              ).transition(cardRemovalTransition)
          }
        }


        
        Spacer()
        FooterView()
          .frame(maxHeight: 80)
          .opacity(dragState.isPressing ? 0 : 1)
          .animation(.easeOut)
      }
    }
}

struct CardsDisplayView_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        CardsDisplayView()
        CardsDisplayView()
          .previewDevice("iPhone SE (2nd generation)")
        CardsDisplayView()
          .previewDevice("iPhone SE (2nd generation)")
      }
    }
}
