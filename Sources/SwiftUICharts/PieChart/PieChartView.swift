//
//  PieChartView.swift
//  ChartView
//
//  Created by András Samu on 2019. 06. 12..
//  Copyright © 2019. András Samu. All rights reserved.
//

import SwiftUI


public struct PieChartView : View {
    public var data: [PieChartData]
    public var title: String
    public var legend: String?
    public var style: ChartStyle
    public var formSize:CGSize
    public var dropShadow: Bool
    public var valueSpecifier:String
    public var cornerImage: Image
    
    @State private var showValue = false
    @State private var currentValueName: String = "" {
        didSet{
            print(currentValueName)
        }
    }
    @State private var currentValue: Double = 0 {
        didSet{
            if(oldValue != self.currentValue && self.showValue) {
                HapticFeedback.playSelection()
            }
        }
    }
    
    public init(data: [PieChartData], title: String, legend: String? = nil, style: ChartStyle = Styles.pieChartStyleOne, form: CGSize? = ChartForm.extraLarge, dropShadow: Bool? = true, valueSpecifier: String? = "%.1f", cornerImage: Image){
        self.data = data
        self.title = title
        self.legend = legend
        self.style = style
        self.formSize = form!
        if self.formSize == ChartForm.large {
            self.formSize = ChartForm.extraLarge
        }
        self.dropShadow = dropShadow!
        self.valueSpecifier = valueSpecifier!
        self.cornerImage = cornerImage
    }
    
    public var body: some View {
        ZStack{
            Rectangle()
                .fill(self.style.backgroundColor)
                .cornerRadius(20)
                .shadow(color: self.style.dropShadowColor, radius: self.dropShadow ? 12 : 0)
            VStack(alignment: .leading){
                HStack{
                    if(!showValue){
                        Text(self.title)
                            .font(.headline)
                            .foregroundColor(self.style.textColor)
                    }else{
                        HStack{
                            Spacer()
                            // Show current values title
                            Text(currentValueName)
                                .font(.headline)
                                .foregroundColor(self.style.textColor)
                            Spacer()
                            // Show current value
                            Text("\(self.currentValue, specifier: self.valueSpecifier)")
                                .font(.headline)
                                .foregroundColor(self.style.textColor)
                            Spacer()
                        }
                    }
                    Spacer()
                    cornerImage
                        .imageScale(.large)
                        .foregroundColor(self.style.legendTextColor)
                }.padding()
                PieChartRow(data: data, backgroundColor: self.style.backgroundColor, showValue: $showValue, currentValue: $currentValue, currentValueName: $currentValueName)
                    .foregroundColor(self.style.accentColor).padding(self.legend != nil ? 0 : 12).offset(y:self.legend != nil ? 0 : -10)
                if(self.legend != nil) {
                    Text(self.legend!)
                        .font(.headline)
                        .foregroundColor(self.style.legendTextColor)
                        .padding()
                }
                
            }
        }.frame(width: self.formSize.width, height: self.formSize.height)
    }
}

#if DEBUG
struct PieChartView_Previews : PreviewProvider {
    var data: PieChartData = PieChartData(name: "Deneme", value: 123, color: Color.blue)
    static var previews: some View {
        PieChartView(data:[PieChartData(name: "Category1", value: 200, color: Color.blue),PieChartData(name: "Category2", value: 123, color: Color.orange)], title: "Title", legend: "Legend",style: ChartStyle(backgroundColor: Color.clear, accentColor: Color.orange, secondGradientColor: Color.gray, textColor: Color.white, legendTextColor: Color.white, dropShadowColor: Color.clear), form: ChartForm.extraLarge  ,cornerImage: Image(systemName: "book"))
    }
}
#endif
