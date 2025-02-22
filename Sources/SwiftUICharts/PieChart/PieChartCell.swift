//
//  PieChartCell.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI

struct PieSlice: Identifiable {
    var id = UUID()
    var startDeg: Double
    var endDeg: Double
    var value: Double
    var name: String
    var normalizedValue: Double
    var color: Color
}

public struct PieChartCell : View {
    @State private var show:Bool = false
    var rect: CGRect
    var radius: CGFloat {
        return min(rect.width, rect.height) / 1.3
    }
    var startDeg: Double
    var endDeg: Double
    var path: Path {
        var path = Path()
        path.addArc(center:rect.mid , radius:self.radius, startAngle: Angle(degrees: self.startDeg), endAngle: Angle(degrees: self.endDeg), clockwise: false)
        path.addLine(to: rect.mid)
        path.closeSubpath()
        return path
    }
    var index: Int
    var backgroundColor:Color
    var name: String
    var labelOffset: Double = 0.0
    var accentColor:Color
    var totalItems: Int
    private var textRotationAngle: Double {
        if totalItems == 1 {
            return 0.0
        } else if totalItems == 2 {
            let angle = (startDeg + endDeg) / 2
            return 0
        } else {
            return (startDeg + endDeg) / 2 + labelOffset
        }
    }
    
    public var body: some View {
        path
            .fill()
            .foregroundColor(self.accentColor)
            .overlay(path.stroke(self.backgroundColor, lineWidth: 3))
            .scaleEffect(self.show ? 1 : 0)
            .onAppear(){
                self.show = true
            }
        
        Text(name)
            .font(.system(size: 14))
            .foregroundColor(Color.white)
            .bold()
            .lineLimit(1)
            .padding(.horizontal, 4)
            .background(Color.black).opacity(0.7)
            .cornerRadius(10)
            .rotationEffect(Angle(degrees: textRotationAngle))
            .offset(x: radius / 2 * cos((startDeg + endDeg) / 2 * .pi / 180.0), y: radius / 2 * sin((startDeg + endDeg) / 2 * .pi / 180.0))
    }
}

extension CGRect {
    var mid: CGPoint {
        return CGPoint(x:self.midX, y: self.midY)
    }
}

#if DEBUG
struct PieChartCell_Previews : PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            PieChartCell(rect: geometry.frame(in: .local),startDeg: 0.0,endDeg: 90.0, index: 0, backgroundColor: Color.clear, name: "Deneme", accentColor: Color(red: 225.0/255.0, green: 97.0/255.0, blue: 76.0/255.0), totalItems: 1)
        }.frame(width:100, height:100)
        
    }
}
#endif
