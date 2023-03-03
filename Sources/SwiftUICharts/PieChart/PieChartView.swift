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
    @State private var percentage: String?
    @State private var currentValueName: String = "" {
        didSet{
            print(currentValueName)
        }
    }
    @State private var currentValue: Double = 0 {
        didSet{
                HapticFeedback.playSelection()
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
        VStack{
            VStack(alignment: .center){
                PieChartRow(data: data, backgroundColor: self.style.backgroundColor, showValue: $showValue, currentValue: $currentValue, currentValueName: $currentValueName)
                    .foregroundColor(self.style.accentColor).padding(self.legend != nil ? 0 : 12).offset(y:self.legend != nil ? 0 : -10)
            }
            Spacer(minLength: 60)
            
           
            HStack{
                if(!showValue){
                    Text(self.title)
                        .font(.headline)
                        .foregroundColor(self.style.textColor)
                }else{
                    HStack{
                        // Show current values title
                        
                            Spacer()
                            Text(currentValueName)
                                .font(.headline)
                                .foregroundColor(Color.white)
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
            }
        }.frame(width: self.formSize.width, height: self.formSize.height + 50)
    }
}

#if DEBUG
struct PieChartView_Previews : PreviewProvider {
    static var previews: some View {
        PieChartView(data: [PieChartData(name: "AAA", value: 20, color: Colors.customRed),PieChartData(name: "BBBB", value: 10, color: Colors.customBlue),PieChartData(name: "CCC", value: 30, color: Colors.customPink), PieChartData(name: "Deneme", value: 15, color: Colors.customGreen), PieChartData(name: "Deneme2", value: 25, color: Colors.customOrange)
            ], title: "Title", legend: "Legend", style: Styles.pieChartDarkMode, form: ChartForm.extraLarge, dropShadow: false, valueSpecifier: "%.1f", cornerImage: Image(systemName: "chart.pie.fill"))
    }
}
#endif
