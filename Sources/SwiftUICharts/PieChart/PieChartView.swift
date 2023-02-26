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
            if(oldValue != self.currentValue ) {
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
                
                    Spacer()
                    Spacer()
                    Spacer()
                
            }
        }.frame(width: self.formSize.width, height: self.formSize.height)
    }
}

#if DEBUG
struct PieChartView_Previews : PreviewProvider {
    static var previews: some View {
        PieChartView(data: [PieChartData(name: "AAA", value: 20, color: Color(hexString: "#dc4726")),PieChartData(name: "BBBB", value: 10, color: Color(hexString: "#dc4726")),PieChartData(name: "CCC", value: 30, color: Color(hexString: "#dc4726"))], title: "Title", legend: "Legend", style: Styles.pieChartDarkMode, form: ChartForm.extraLarge, dropShadow: false, valueSpecifier: "%.1f", cornerImage: Image(systemName: "chart.pie.fill"))
    }
}
#endif
