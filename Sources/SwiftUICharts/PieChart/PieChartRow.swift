//
//  PieChartRow.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI



public struct PieChartRow : View {
    var data: [PieChartData]
    var backgroundColor: Color
    
    var slices: [PieSlice] {
        var tempSlices:[PieSlice] = []
        var lastEndDeg:Double = 0
        let maxValue = data.map({$0.value}).reduce(0, +)
        for slice in data {
            let normalized:Double = slice.value / maxValue
            let startDeg = lastEndDeg
            let endDeg = lastEndDeg + (normalized * 360)
            lastEndDeg = endDeg
            tempSlices.append(PieSlice(startDeg: startDeg, endDeg: endDeg, value: slice.value, name: slice.name, normalizedValue: normalized, color: slice.color))
        }
        return tempSlices
    }
    
    @Binding var showValue: Bool
    @Binding var currentValue: Double
    @Binding var currentValueName: String
    @State public var currentTouchedIndex = -1 {
        didSet {
            if oldValue != currentTouchedIndex {
                showValue = currentTouchedIndex != -1
                currentValue = showValue ? slices[currentTouchedIndex].value : 0
                currentValueName = showValue ? slices[currentTouchedIndex].name : ""
            }
        }
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack{
                ForEach(0..<self.slices.count){ i in
                    PieChartCell(rect: geometry.frame(in: .local), startDeg: self.slices[i].startDeg, endDeg: self.slices[i].endDeg, index: i, backgroundColor: self.backgroundColor,accentColor: self.slices[i].color)
                        .scaleEffect(self.currentTouchedIndex == i ? 1.1 : 1)
                        .animation(Animation.spring())
                }
            }
            .gesture(DragGesture()
                        .onChanged({ value in
                            let rect = geometry.frame(in: .local)
                            let isTouchInPie = isPointInCircle(point: value.location, circleRect: rect)
                            if isTouchInPie {
                                let touchDegree = degree(for: value.location, inCircleRect: rect)
                                self.currentTouchedIndex = self.slices.firstIndex(where: { $0.startDeg < touchDegree && $0.endDeg > touchDegree }) ?? -1
                            } else {
                                self.currentTouchedIndex = -1
                            }
                        })
                        .onEnded({ value in
                            self.currentTouchedIndex = -1
                        }))
        }
    }
}

#if DEBUG
struct PieChartRow_Previews : PreviewProvider {
    
    var data: PieChartData = PieChartData(name: "Deneme", value: 123, color: Color.blue)
    static var previews: some View {
        Group {
            PieChartRow(data:[PieChartData(name: "Deneme", value: 123, color: Color.blue),PieChartData(name: "Deneme", value: 123, color: Color.blue),PieChartData(name: "Deneme", value: 123, color: Color.blue),PieChartData(name: "Deneme", value: 123, color: Color.blue),PieChartData(name: "Deneme", value: 123, color: Color.blue),PieChartData(name: "Deneme", value: 123, color: Color.blue)], backgroundColor: Color.black,  showValue: Binding.constant(false), currentValue: Binding.constant(0), currentValueName: Binding.constant(""))
                .frame(width: 150, height: 150)
                        PieChartRow(data:[PieChartData(name: "Deneme", value: 123, color: Color.blue),PieChartData(name: "Deneme", value: 123, color: Color.blue),PieChartData(name: "Deneme", value: 123, color: Color.blue),PieChartData(name: "Deneme", value: 123, color: Color.blue),PieChartData(name: "Deneme", value: 123, color: Color.blue),PieChartData(name: "Deneme", value: 123, color: Color.blue)], backgroundColor: Color.blue, showValue: Binding.constant(false), currentValue: Binding.constant(0), currentValueName: Binding.constant(""))
                .frame(width: 100, height: 100)
        }
    }
}
#endif
