//
//  ProfileCustomView.swift
//  HoneyMoon
//
//  Created by Jawad Ali on 03/03/2022.
//

import SwiftUI

struct ProfileCustomShape: Shape {

  var circleSize: CGFloat
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: 0,y: 0))

    path.addArc(center: CGPoint(x: circleSize, y: 0), radius: circleSize, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 90), clockwise: true)

    path.addLine(to:  CGPoint(x: rect.maxX - circleSize*2, y: path.currentPoint?.y ?? 0))

    path.addArc(center: CGPoint(x: (path.currentPoint?.x ?? 0 ) + circleSize, y: (path.currentPoint?.y ?? 0 ) + circleSize), radius: circleSize, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 10), clockwise: false)

    path.addLine(to:  CGPoint(x: path.currentPoint?.x ?? 0,y: rect.maxY))

    path.addLine(to:  CGPoint(x: 0,y: rect.maxY))
    //
    path.closeSubpath()

    return path
  }

}

