//
//  SelectionProgressView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 01/03/2022.
//

import SwiftUI

struct SelectionProgressView: View {
  @Binding var numberOfLines: Int
  @Binding var selectedLine: Int
    var body: some View {
      HStack {
        ForEach(0..<numberOfLines, id: \.self) { index in
          ZStack{
          Capsule().fill( index == (selectedLine-1) ? Color.white : Color.gray)
            .shadow(radius: 5)
            .padding(0.5)

            Capsule().stroke( index == (selectedLine-1) ? Color.white : Color.gray, lineWidth: 0.5)
          }
            .opacity(numberOfLines == 1 ? 0 : 1)
        .frame(maxWidth: 200, maxHeight: 3)
        }
      }
      .animation(nil)
      .padding(.horizontal, 20)
    }
}

struct SelectionProgressView_Previews: PreviewProvider {
  @State static var numberOfLines: Int = 5
  @State static var selectedLine: Int = 3

    static var previews: some View {
      SelectionProgressView(numberOfLines: $numberOfLines, selectedLine: $selectedLine).previewLayout(.sizeThatFits)
    }
}
